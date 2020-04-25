pragma solidity 0.5.8;

interface ICompound {
    function mint(uint256 mintAmount) external view returns (uint256);
    function redeem(uint256 redeemTokens) external view returns (uint256);
}