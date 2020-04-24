pragma solidity 0.5.8;

import "./Ownable.sol";

contract TwoStepOwnable is Ownable {
  address private _pendingOwner;

  event OwnershipPending(address indexed owner, address indexed pendingOwner);
  event OwnershipCancelPending(address indexed pendingOwner);

  modifier onlyPendingOwner() {
    require(msg.sender == _pendingOwner, "Ownable: caller is not the pending owner");
    _;
  }

  function pendingOwner() public view returns (address) {
    return _pendingOwner;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    require(
      _newOwner != address(0),
      "TwoStepOwnable: invalid address for new owner"
    );

    _pendingOwner = _newOwner;
    emit OwnershipPending(owner(), _pendingOwner);
  }

  function cancelOwnershipTransfer() public onlyOwner {
    emit OwnershipCancelPending(_pendingOwner);
    _pendingOwner = address(0);
  }

  function acceptOwnership() public onlyPendingOwner {
    _pendingOwner = address(0);
    _transferOwnership(msg.sender);
  }
}