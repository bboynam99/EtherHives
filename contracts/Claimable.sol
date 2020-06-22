// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@openzeppelin/contracts/access/Ownable.sol";


contract Claimable is Ownable {

    address public pendingOwner;

    modifier onlyPendingOwner() {
        require(msg.sender == pendingOwner);
        _;
    }

    function renounceOwnership() public override(Ownable) onlyOwner {
        revert();
    }

    function transferOwnership(address newOwner) public override(Ownable) onlyOwner {
        pendingOwner = newOwner;
    }

    function claimOwnership() public virtual onlyPendingOwner {
        transferOwnership(pendingOwner);
        delete pendingOwner;
    }
}
