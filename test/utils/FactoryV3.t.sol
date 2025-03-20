// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import { Ownable } from '../../src/contracts/abstracts/Ownable.sol';
import { UUPSUpgradeable } from '../../src/contracts/abstracts/UUPSUpgradeable.sol';
import { ERC1967Utils } from '../../src/contracts/libraries/ERC1967Utils.sol';

contract FactoryV3 is Ownable, UUPSUpgradeable {
    constructor() reinitializer(3) { }

    function initializeV3(address _owner) public reinitializer(3) {
        _setOwner(_owner);
    }

    function _authorizeUpgrade(address) internal override onlyAdmin { }
}
