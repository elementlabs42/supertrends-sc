// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { BondingCurve } from './BondingCurve.sol';
import { TrendToken } from './TrendToken.sol';
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
    uint256 private constant DEFAULT_ERC20_SUPPLY = 1e27;

    mapping(address token => address bondingCurve) private _bondingCurves;
    mapping(address subToken => address superToken) private _superTokens;
    mapping(address superToken => address[] subTokens) private _subTokens;
    address[] private _allTokens;

    constructor() initializer { }

    function initialize(address _owner) public initializer {
        _setOwner(_owner);
        ERC1967Utils.changeAdmin(msg.sender);
    }

    function _authorizeUpgrade(address) internal override onlyAdmin { }

    function getAllTokens() external view returns (address[] memory) {
        return _allTokens;
    }

    function getAllTokensLength() external view returns (uint256) {
        return _allTokens.length;
    }

    function getBondingCurve(address token) external view returns (address) {
        return _bondingCurves[token];
    }

    function getSuperToken(address subToken) external view returns (address) {
        return _superTokens[subToken];
    }

    function getSubTokens(address superToken) external view returns (address[] memory) {
        return _subTokens[superToken];
    }

    function isSuperToken(address token) public view returns (bool) {
        return _superTokens[token] == address(0);
    }

    function createSuperToken(string memory name, string memory symbol) external returns (address) {
        return createToken(name, symbol, address(0));
    }

    function createSubToken(address superToken, string memory name, string memory symbol) external returns (address) {
        return createToken(name, symbol, superToken);
    }

    function setMintFee(address token, uint256 fee) external onlyOwner { }

    function setTokenCreationFee(uint256 fee) external onlyOwner { }

    function withdrawFees(address bondingCurve, address to, uint256 amount) external onlyOwner { }

    function createToken(string memory name, string memory symbol, address superToken)
        internal
        returns (address token)
    {
        bool isSubToken = superToken != address(0);
        if (isSubToken && !isSuperToken(superToken)) {
            revert FactoryMustBeSuperToken(superToken);
        }

        address bondingCurve = address(new BondingCurve());
        token = address(new TrendToken(name, symbol, DEFAULT_ERC20_SUPPLY, bondingCurve));
        // initialize bonding curve: associate a token with its bonding curve

        _bondingCurves[token] = bondingCurve;
        _allTokens.push(token);
        if (isSubToken) {
            _superTokens[token] = superToken;
            _subTokens[superToken].push(token);
            emit SubTokenCreated(token, superToken, msg.sender);
        } else {
            emit SuperTokenCreated(token, msg.sender);
        }
    }
}
