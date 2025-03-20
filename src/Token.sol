// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {ERC20Permit} from "./abstracts/ERC20Permit.sol";
import {ERC20Capped} from "./abstracts/ERC20Capped.sol";

contract Token is ERC20, ERC20Permit, ERC20Capped {

    constructor(string memory name, string memory symbol, uint256 cap, address mintTo) ERC20(name, symbol) ERC20Capped(cap) {
      _mint(mintTo, cap);
    }
}