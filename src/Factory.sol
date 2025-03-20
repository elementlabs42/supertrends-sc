// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {IFactory} from "./Interfaces/IFactory.sol";
import {ERC20} from "./ERC20.sol";
import {BondingCurve} from "./BondingCurve.sol";

contract Factory is IFactory {
    uint256 private constant DEFAULT_ERC20_SUPPLY = 1e27;

    address public override owner;
    mapping(address superOrSubToken => address bondingCurve) public override getBondingCurve;
    mapping(address subToken => address superToken) public override getSuperToken;
    mapping(address superToken=> address[] subTokens) public override getSubTokens;
    address[] public override allTokens;
    uint256 public override defaultCreationFee;
    uint256 public override defaultSwapFee;
    uint256 public override defaultListingFee;
    uint256 public override defaultListingReward;
    uint256 public override defaultDonationRate;
    address public override defaultAmmFactory;

    constructor() {
        owner = msg.sender;

        emit OwnerSet(msg.sender);
    }

    function createSuperToken(
        string memory symbol,
        string memory name
    ) external override returns (address superToken, address bondingCurve) {
        return createToken(symbol, name, address(0));
    }

    function createSubToken(
        string memory symbol,
        string memory name,
        address superToken
    ) external override returns (address subToken, address bondingCurve) {
        return createToken(symbol, name, superToken);
    } 

    function createToken(
        string memory symbol,
        string memory name,
        address superToken
    ) private override returns (address token, address bondingCurve) {
        require(msg.sender == owner, 'TF00');
        bool isCreatingSuperToken = superToken == address(0);
        require(isCreatingSuperToken || isSuperToken(superToken), 'TF3B');

        bondingCurve = address(new BondingCurve());
        ERC20 token = new ERC20(symbol, name, bondingCurve, DEFAULT_ERC20_SUPPLY);
        IBondingCurve(bondingCurve).initialize(token, superToken, defaultCreationFee, defaultSwapFee, defaultListingFee, defaultListingReward, defaultDonationRate, defaultAmmFactory);

        getBondingCurve[token] = bondingCurve;
        if (isCreatingSuperToken) {
          getSuperToken[token] = token; // Self-reference to mark super token
        } else {
          getSuperToken[token] = superToken;
          getSubTokens[superToken].push(token);
        }
        allTokens.push(pair);

        emit TokenCreated(token, superToken, bondingCurve, allTokens.length);
    }

    function isSuperToken(address superToken) external view override returns (bool) {
        return getSuperToken[superToken] == superToken;
    }

    function setOwner(address _owner) external override {
        require(msg.sender == owner, 'TF00');
        require(_owner != owner, 'TF01');
        require(_owner != address(0), 'TF02');
        owner = _owner;
        emit OwnerSet(_owner);
    }
}
