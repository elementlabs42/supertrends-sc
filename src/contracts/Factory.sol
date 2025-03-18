// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Ownable } from './abstracts/Ownable.sol';
import { UUPSUpgradeable } from './abstracts/UUPSUpgradeable.sol';
import { IFactory } from './interfaces/IFactory.sol';

contract Factory is IFactory, Ownable, UUPSUpgradeable {
    mapping(address superToken => address bondingCurve) public superTokenBondingCurve;
    mapping(address subToken => address bondingCurve) public subTokenBondingCurve;
    mapping(address superToken => address subToken) public isParentToken;

    constructor() { }

    function initialize() public override {
        _setOwner(msg.sender);
        super.initialize();
    }

    function _authorizeUpgrade(address) internal override onlyOwner { }

    function createSuperToken(string memory name, string memory symbol) external returns (address) {
        return address(0);
    }

    function createSubToken(address superToken, string memory name, string memory symbol) external returns (address) {
        return address(0);
    }

    function setMintFee(address token, uint256 fee) external { }

    function setTokenCreationFee(uint256 fee) external { }

    function withdrawFees(address bondingCurve, address to, uint256 amount) external { }
}
