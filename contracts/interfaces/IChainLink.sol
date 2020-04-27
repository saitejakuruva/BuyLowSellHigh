pragma solidity 0.5.8;

interface IChainLink {
  function latestAnswer() external view returns (uint256);
}