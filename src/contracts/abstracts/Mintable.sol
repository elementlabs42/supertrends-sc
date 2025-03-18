// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import '../interfaces/IMintable.sol';

abstract contract Mintable is IMintable {
    mapping(address minter => bool isMinter) public canMint;

    function _setMinter(address minter, bool isMinter) internal {
        if (minter == address(0)) {
            revert MintableInvalidMinter(address(0));
        }
        if (canMint[minter] == isMinter) {
            revert MintableSameValueAlreadySet();
        }
        canMint[minter] = isMinter;
        emit MinterSet(minter, isMinter);
    }

    function mint(address receiver, uint256 /* amount */ ) public virtual {
        if (receiver == address(0)) {
            revert MintableInvalidReceiver(address(0));
        }
        if (!canMint[msg.sender]) {
            revert MintableUnauthorizedMinter(msg.sender);
        }
    }
}
