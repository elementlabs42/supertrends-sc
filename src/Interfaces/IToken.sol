// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {IERC20} from "./IERC20.sol";
import {IERC20Permit} from "./IERC20Permit.sol";

interface IToken is IERC20, IERC20Permit {
}