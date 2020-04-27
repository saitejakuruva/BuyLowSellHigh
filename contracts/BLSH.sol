pragma solidity 0.5.8;

import "./TwoStepOwnable.sol";
import "./interfaces/IAave.sol";
import "./interfaces/IChainLink.sol";
import "./interfaces/ICompound.sol";
import "./interfaces/IKyberSwap.sol";
import "./interfaces/IERC20.sol";
import "./Utils.sol";

contract BuyLowSellHigh is TwoStepOwnable {

    IAave public aave;
    ICompound public compound;
    IChainLink public chainlink;
    IKyberSwap public kyberswap;
    uint256 internal setLimit;

    mapping(address => address) public oracles;

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

    event LogDeposit(uint256 indexed amount, address indexed token, address indexed by);



    constructor(IAave _aave, ICompound _compound, IChainLink _chainlink, IKyberSwap _kyberswap, uint256 _setLimit)
        public
    {
        aave = _aave;
        compound = _compound;
        chainlink = _chainlink;
        kyberswap = _kyberswap;
        setLimit = _setLimit;
    }
    function setAave(IAave _aave)
        public
        onlyOwner
        addressValid(address(_aave))
    {
        aave = _aave;
    }

    function setCompound(ICompound _compound)
        public
        onlyOwner
        addressValid(address(_compound))
    {
        compound = _compound;
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
    function deposit(uint256 _amount, IERC20 _tokenAddr) public payable {
        require(_tokenAddr.balanceOf(msg.sender) >= _amount, "BLSH::deposit INSUFFICIENT_BALANCE");
        _tokenAddr.approve(address(this), _amount);
        _tokenAddr.transfer(address(this), _amount);
        emit LogDeposit(_amount, address(_tokenAddr), msg.sender);
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
        payable
        returns(bool)
        addressValid(_tokenAddr)

    {
        uint256 diff = sub(_sellPrice, _buyPrice);
    //TODO: Add expiration time validation too.
        if(diff > setLimit){
            //Mint ATokens
        }
        
    }
}