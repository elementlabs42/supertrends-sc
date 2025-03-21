// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import { Ownable } from '../../src/abstracts/Ownable.sol';
import { UUPSUpgradeable } from '../../src/abstracts/UUPSUpgradeable.sol';
import { ERC1967Utils } from '../../src/libraries/ERC1967Utils.sol';

contract FactoryV2 is Ownable, UUPSUpgradeable {
    constructor() reinitializer(2) { }

    function initializeV2(address _owner) public reinitializer(2) {
        _setOwner(_owner);
    }

    function _authorizeUpgrade(address) internal view override onlyAdmin { }
}
