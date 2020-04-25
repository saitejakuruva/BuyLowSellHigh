pragma solidity 0.5.8;

interface IChainLink {
  function currentAnswer() external view returns (uint256);
}