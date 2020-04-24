pragma solidity 0.5.8;

interface IChainLinkRef {
  function currentAnswer() external view returns (int256);
}