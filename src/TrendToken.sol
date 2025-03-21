// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { ERC20Permit } from './abstracts/ERC20Permit.sol';
import { IERC20Capped } from './interfaces/IERC20Capped.sol';

contract TrendToken is ERC20Permit, IERC20Capped {
    uint256 private immutable _cap;

    constructor(string memory name_, string memory symbol_, uint256 cap_, address mintTo) ERC20Permit(name_, symbol_) {
        if (cap_ == 0) {
            revert ERC20InvalidCap(0);
        }
        _cap = cap_;

        _mint(mintTo, cap_);
    }

    function cap() public view override returns (uint256) {
        return _cap;
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function burnFrom(address from, uint256 amount) public {
        _spendAllowance(from, msg.sender, amount);
        _burn(from, amount);
    }

    /**
     * @dev See {ERC20-_update}.
     */
    function _update(address from, address to, uint256 value) internal virtual override {
        super._update(from, to, value);

        if (from == address(0)) {
            uint256 maxSupply = cap();
            uint256 supply = totalSupply();
            if (supply > maxSupply) {
                revert ERC20ExceededCap(supply, maxSupply);
            }
        }
    }
}
