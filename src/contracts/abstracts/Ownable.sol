// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { IOwnable } from '../interfaces/IOwnable.sol';
/**
 * @dev IMPORTANT: This contract is used as parent contract in contracts that implement a proxy pattern.
 * Adding, removing, changing or rearranging state variables in this contract can result in a storage collision
 * in child contracts in case of a contract upgrade.
 */

abstract contract Ownable is IOwnable {
    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Ownable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant _OWNER_SLOT = 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300;

    modifier onlyOwner() {
        if (msg.sender != owner()) {
            revert OwnableUnauthorizedOwner(msg.sender);
        }
        _;
    }

    function owner() public view virtual returns (address __owner) {
        assembly {
            __owner := sload(_OWNER_SLOT)
        }
    }

    function setOwner(address newOwner) external virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) internal virtual {
        if (newOwner == owner()) {
            revert OwnableSameValueAlreadySet();
        }

        assembly {
            sstore(_OWNER_SLOT, newOwner)
        }
        emit OwnerSet(newOwner);
    }
}
