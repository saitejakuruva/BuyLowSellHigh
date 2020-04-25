pragma solidity 0.5.8;

interface IAave {
    function deposit( address _reserve, uint256 _amount, uint16 _referralCode) external;
    function redeem(uint256 _amount) external;
}