pragma solidity 0.5.8;

import "./TwoStepOwnable.sol";
import "./interfaces/IAave.sol";
import "./interfaces/IChainLink.sol";
import "./interfaces/ICompound.sol";
import "./interfaces/IKyberSwap.sol";
import "./Utils.sol";

contract BuyLowSellHigh is TwoStepOwnable {

    IAave public aave;
    ICompound public compound;
    IChainLink public chainlink;
    IKyberSwap public kyberswap;
    address public baseCurrency;

    mapping(address => address) public oracles;

    modifier addressValid(address _address) {
        require(_address != address(0), "Utils::_ INVALID_ADDRESS");
        _;
    }


    constructor(IAave _aave, ICompound _compound, IChainLink _chainlink, IKyberSwap _kyberswap, address _baseCurrency)
        public
    {
        aave = _aave;
        compound = _compound;
        chainlink = _chainlink;
        kyberswap = _kyberswap;
        baseCurrency = _baseCurrency;
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

    function setBaseCurrency(address _baseCurrency)
        public
        onlyOwner
        addressValid(_baseCurrency)
    {
        baseCurrency = _baseCurrency;
    }

    function setOracle(address _tokenAddr, address _oracleAddr)
        public
        onlyOwner
    {
        oracles[_tokenAddr] = _oracleAddr;
    }

    function getPrice(address _tokenAddr) public view returns(uint256){
        uint256 price = uint256(IChainLink(oracles[_tokenAddr]).currentAnswer());
        return Utils.changePrecision(price, 8, 18);
    }
}