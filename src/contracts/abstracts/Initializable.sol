// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import '../interfaces/IInitializable.sol';

abstract contract Initializable is IInitializable {
    // keccak256(abi.encode(uint256(keccak256("openzeppelin.storage.Initializable")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant _INITIALIZED_SLOT = 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00;

    /**
     * @notice Emitted when the contract is initialized
     * @dev This event is emitted when the contract is initialized, and it should only initialize once
     */
    function initialize() public virtual override {
        if (getInitialized()) {
            revert InitializableAlreadyInitialized();
        }
        assembly {
            sstore(_INITIALIZED_SLOT, true)
        }
        emit InitializedBy(msg.sender);
    }

    function getInitialized() internal view returns (bool __initialized) {
        assembly {
            __initialized := sload(_INITIALIZED_SLOT)
        }
    }
}
