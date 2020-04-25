pragma solidity 0.5.8;

interface IKyberSwap {
    function executeSwap(
        address srcToken,
        uint256 srcQty,
        address destToken,
        address destAddress,
        uint256 maxDestAmount
    ) external;
}