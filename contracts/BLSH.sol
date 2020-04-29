pragma solidity 0.5.8;

import "./TwoStepOwnable.sol";
import "./interfaces/IChainLink.sol";
import "./interfaces/IKyberSwap.sol";
import "./interfaces/IERC20.sol";
import "./Utils.sol";
import "./interfaces/Aave/ILendingPoolAddressesProvider.sol";
import "./interfaces/Aave/ILendingPool.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract BuyLowSellHigh is TwoStepOwnable {
    using SafeMath for uint256;

    IChainLink public chainlink;
    IKyberSwap public kyberswap;
    uint256 internal setLimit;
    ILendingPoolAddressesProvider public provider;
    bool public limitOrderEnabled;
    uint256 public id;
    mapping(address => address) public oracles;
    mapping(uint256 => OrderDetails) public orders;
    mapping (address => uint256) public balances;
    mapping (address => uint256[]) public tracker;



    modifier addressValid(address _address) {
        require(_address != address(0), "Utils::_ INVALID_ADDRESS");
        _;
    }

    struct OrderDetails {
        uint256 srcAmount;
        uint256 dstAmount;
        uint256 buyPrice;
        uint256 sellPrice;
        uint256 expirationTime;
        address tokenAddr;
    }
    event LimitOrderEnabled(bool limitOrderEnabled);



    constructor(IChainLink _chainlink, IKyberSwap _kyberswap, ILendingPoolAddressesProvider _provider, uint256 _setLimit)
        public
    {
        chainlink = _chainlink;
        kyberswap = _kyberswap;
        provider = _provider;
        setLimit = _setLimit;
    }

    function enableLimitOrder()
        internal
        onlyOwner
    {
        limitOrderEnabled = true;
        emit LimitOrderEnabled(limitOrderEnabled);
    }

    function disableLimitOrder()
        internal
        onlyOwner
    {
        limitOrderEnabled = false;
        emit LimitOrderEnabled(limitOrderEnabled);
    }

    function setChainLink(IChainLink _chainlink)
        public
        onlyOwner
        addressValid(address(_chainlink))
    {
        chainlink = _chainlink;
    }

    function setLendingPoolAddressesProvider(ILendingPoolAddressesProvider _provider)
        public
        onlyOwner
        addressValid(address(_provider))
    {
        provider = _provider;
    }

    function setKyberSwap(IKyberSwap _kyberswap)
        public
        onlyOwner
        addressValid(address(_kyberswap))
    {
        kyberswap = _kyberswap;
    }

    function setLimitOnDiff(uint256 _setLimit)
        public
        onlyOwner
    {
        setLimit = _setLimit;
    }

    function setOracle(address _tokenAddr, address _oracleAddr)
        public
        onlyOwner
    {
        oracles[_tokenAddr] = _oracleAddr;
    }

    function getPrice(address _tokenAddr) public view returns(uint256){
        uint256 price = uint256(IChainLink(oracles[_tokenAddr]).latestAnswer());
        return Utils.changePrecision(price, 8, 18);
    }

    function deposit(address _tokenAddr) public payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        ILendingPool lendingPool = ILendingPool(
                provider.getLendingPool()
        );
        lendingPool.deposit(_tokenAddr, balances[msg.sender], 0);
    }

    function placeOrder
    (
        uint256 _srcAmount,
        uint256 _dstAmount,
        uint256 _buyPrice,
        uint256 _sellPrice,
        uint256 _expirationTime,
        address _tokenAddr
        )
        public
        addressValid(_tokenAddr)
        returns(bool)

    {
        id = id.add(1);
        orders[id] = OrderDetails(_srcAmount, _dstAmount, _buyPrice, _sellPrice, _expirationTime, _tokenAddr);
        tracker[msg.sender].push(id);
        enableLimitOrder();
        return limitOrderEnabled;
    }

}