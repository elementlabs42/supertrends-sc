// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import { ERC20 } from '../../src/abstracts/ERC20.sol';

contract TestToken is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) { }
}
