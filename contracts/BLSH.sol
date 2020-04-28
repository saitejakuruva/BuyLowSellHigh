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
    mapping(address => address) public oracles;
    address constant AaveLendingPoolAddressProviderAddress = 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8;


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
    mapping(address => OrderDetails) public orders;
    mapping (address => uint256) balances;


    constructor(IChainLink _chainlink, IKyberSwap _kyberswap, uint256 _setLimit)
        public
    {
        chainlink = _chainlink;
        kyberswap = _kyberswap;
        setLimit = _setLimit;
    }

    function setChainLink(IChainLink _chainlink)
        public
        onlyOwner
        addressValid(address(_chainlink))
    {
        chainlink = _chainlink;
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

    //Write Deposit function and Implement Transfer function with Validations.
    function deposit(address _tokenAddr) public payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        ILendingPool lendingPool = ILendingPool(
            ILendingPoolAddressesProvider(AaveLendingPoolAddressProviderAddress)
                .getLendingPool()
        );
        lendingPool.deposit(_tokenAddr, balances[msg.sender], 0);
    }

    // function placeOrder
    // (
    //     uint256 _srcAmount,
    //     uint256 _dstAmount,
    //     uint256 _buyPrice,
    //     uint256 _sellPrice,
    //     uint256 _expirationTime,
    //     address _tokenAddr
    //     )
    //     public
    //     payable
    //     returns(bool)
    //     addressValid(_tokenAddr)

    // {
    //     uint256 diff = sub(_sellPrice, _buyPrice);
    // //TODO: Add expiration time validation too.
    //     if(diff > setLimit){
    //         //Mint ATokens
    //         deposit(_srcAmount, _tokenAddr);

    //     }
        
    // }
}