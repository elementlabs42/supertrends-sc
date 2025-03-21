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
 */
contract Factory is IFactory, Ownable, UUPSUpgradeable {
    uint256 private constant DEFAULT_ERC20_SUPPLY = 1e27; // 1B

    mapping(address token => address bondingCurve) private _bondingCurves;
    mapping(address child => address parent) private _superTokens;
    mapping(address parent => address[] children) private _subTokens;
    address[] private _allTokens;

    uint256 public tokenCreationFee;
    uint256 public tokenTradeFee;
    uint256 public listingFee;
    uint256 public creatorRewadr;
    uint256 public listingRate;
    uint256 public donationRate;

    constructor() initializer { }

    function initialize(
        address _owner,
        uint256 _tokenCreationFee,
        uint256 _tokenTradeFee,
        uint256 _listingFee,
        uint256 _creatorRewadr,
        uint256 _listingRate,
        uint256 _donationRate
    ) public initializer {
        _setOwner(_owner);
        ERC1967Utils.changeAdmin(msg.sender);

        tokenCreationFee = _tokenCreationFee;
        tokenTradeFee = _tokenTradeFee;
        listingFee = _listingFee;
        creatorRewadr = _creatorRewadr;
        listingRate = _listingRate;
        donationRate = _donationRate;
    }

    function _authorizeUpgrade(address) internal view override onlyAdmin { }

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

    /**
     * @dev A token is a super token if it points to itself
     */
    function isSuperToken(address token) public view returns (bool) {
        return token != address(0) && _superTokens[token] == token;
    }

    /**
     * @dev A token is a sub token if it points to a super token
     */
    function isSubToken(address subToken) public view returns (bool) {
        address superToken = _superTokens[subToken];
        return superToken != address(0) && superToken != subToken;
    }

    function setTokenCreationFee(uint256 fee) external onlyOwner {
        if (fee == tokenCreationFee) {
            revert FactorySameValueAlreadySet();
        }
        tokenCreationFee = fee;
        emit TokenCreationFeeSet(fee);
    }

    function setTokenTradeFee(uint256 fee) external onlyOwner {
        if (fee == tokenTradeFee) {
            revert FactorySameValueAlreadySet();
        }
        tokenTradeFee = fee;
        emit TokenTradeFeeSet(fee);
    }

    function setListingFee(uint256 fee) external onlyOwner {
        if (fee == listingFee) {
            revert FactorySameValueAlreadySet();
        }
        listingFee = fee;
        emit ListingFeeSet(fee);
    }

    function setCreatorRewadr(uint256 reward) external onlyOwner {
        if (reward == creatorRewadr) {
            revert FactorySameValueAlreadySet();
        }
        creatorRewadr = reward;
        emit CreatorRewadrSet(reward);
    }

    function setDonationRate(uint256 rate) external onlyOwner {
        if (rate == donationRate) {
            revert FactorySameValueAlreadySet();
        }
        donationRate = rate;
        emit DonationRateSet(rate);
    }

    function setListingRate(uint256 rate) external onlyOwner {
        if (rate == listingRate) {
            revert FactorySameValueAlreadySet();
        }
        listingRate = rate;
        emit ListingRateSet(rate);
    }

    function withdrawFees(address bondingCurve, address to, uint256 amount) external onlyOwner { }

    function createToken(string memory name, string memory symbol, address superToken)
        external
        returns (address token)
    {
        bool isSubTokenCreation = superToken != address(0);
        if (isSubTokenCreation && !isSuperToken(superToken)) {
            revert FactoryMustBeSuperToken(superToken);
        }

        address bondingCurve = address(new BondingCurve());
        token = address(new TrendToken(name, symbol, DEFAULT_ERC20_SUPPLY, bondingCurve));
        // initialize bonding curve: associate a token with its bonding curve

        _bondingCurves[token] = bondingCurve;
        _allTokens.push(token);
        if (isSubTokenCreation) {
            _superTokens[token] = superToken;
            _subTokens[superToken].push(token);
            emit SubTokenCreated(token, superToken, msg.sender);
        } else {
            _superTokens[token] = token;
            emit SuperTokenCreated(token, msg.sender);
        }
    }
}
