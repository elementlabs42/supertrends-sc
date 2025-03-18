// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import './abstracts/Proxy.sol';
import './libraries/ERC1967Utils.sol';

contract UUPSProxy is Proxy {
    constructor(address implementation, bytes memory data) payable {
        ERC1967Utils.upgradeToAndCall(implementation, data);
    }

    function _implementation() internal view virtual override returns (address) {
        return ERC1967Utils.getImplementation();
    }
}
