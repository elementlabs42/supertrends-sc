// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { ERC20Permit } from './abstracts/ERC20Permit.sol';
import { Ownable } from './abstracts/Ownable.sol';

contract TrendToken is ERC20Permit, Ownable {
    constructor(string memory name_, string memory symbol_) ERC20Permit(name_, symbol_) {
        _setOwner(msg.sender);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function burnFrom(address from, uint256 amount) public {
        _spendAllowance(from, msg.sender, amount);
        _burn(from, amount);
    }
}
