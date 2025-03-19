// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Ownable } from './abstracts/Ownable.sol';
import { UUPSUpgradeable } from './abstracts/UUPSUpgradeable.sol';
import { IFactory } from './interfaces/IFactory.sol';
import { ERC1967Utils } from './libraries/ERC1967Utils.sol';

/**
 * @dev IMPORTANT: This contract implements a proxy pattern. Do not modify inheritance list in this contract.
 * Adding, removing, changing or rearranging these base contracts can result in a storage collision after a contract upgrade.
 *
 * IMPORTANT: This contract is used as parent contract in contracts that implement a proxy pattern.
 * Adding, removing, changing or rearranging state variables in this contract can result in a storage collision
 * in child contracts in case of a contract upgrade.
 */
contract Factory is IFactory, Ownable, UUPSUpgradeable {
    mapping(address superToken => address bondingCurve) public superTokenBondingCurve;
    mapping(address subToken => address bondingCurve) public subTokenBondingCurve;
    mapping(address superToken => address subToken) public isParentToken;

    constructor() initializer { }

    function initialize(address _owner) public initializer {
        _setOwner(_owner);
        ERC1967Utils.changeAdmin(msg.sender);
    }

    function _authorizeUpgrade(address) internal override onlyAdmin { }

    function createSuperToken(string memory name, string memory symbol) external returns (address) {
        return address(0);
    }

    function createSubToken(address superToken, string memory name, string memory symbol) external returns (address) {
        return address(0);
    }

    function setMintFee(address token, uint256 fee) external onlyOwner { }

    function setTokenCreationFee(uint256 fee) external onlyOwner { }

    function withdrawFees(address bondingCurve, address to, uint256 amount) external onlyOwner { }
}
