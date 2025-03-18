// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import '../interfaces/IBurnable.sol';

abstract contract Burnable is IBurnable {
    mapping(address burner => bool isBurner) public canBurn;

    function _setBurner(address burner, bool isBurner) internal {
        if (canBurn[burner] == isBurner) {
            revert BurnableSameValueAlreadySet();
        }
        canBurn[burner] = isBurner;
        emit BurnerSet(burner, isBurner);
    }

    function burn(uint256 /* amount */ ) public virtual {
        _canBurn(msg.sender);
    }

    function burnFrom(address from, uint256 /* amount */ ) public virtual;

    function _canBurn(address burner) private view {
        // everyone can burn when address(0) is burner
        if (!canBurn[address(0)] && !canBurn[burner]) {
            revert BurnableUnauthorizedBurner(burner);
        }
    }
}
