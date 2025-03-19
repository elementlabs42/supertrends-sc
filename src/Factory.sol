// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.29;

import {IFactory} from "./Interfaces/IFactory.sol";
import {ERC20} from "./ERC20.sol";
import {BondingCurve} from "./BondingCurve.sol";

contract Factory is IFactory {
    uint256 private constant DEFAULT_ERC20_SUPPLY = 1e27;

    mapping(address => address) public override getBondingCurve;
    mapping(address => address) public override getSuperToken;
    mapping(address => address[]) public override getSubTokens;
    address[] public override allTokens;
    address public override owner;

    function createSuperToken(
        string memory symbol,
        string memory name
    ) external override returns (address superToken) {
        superToken = address(new SuperToken(symbol, name));
    }

    function createSubToken(
        string memory symbol,
        string memory name,
        address superToken
    ) external override returns (address subToken) {
        subToken = address(new SubToken(symbol, name, superToken));
    } 

    function createToken(
        string memory symbol,
        string memory name,
        address superToken
    ) private override returns (address bondingCurve) {
        require(msg.sender == owner, 'TF00');
        require(superToken == address(0) || isSuperToken(superToken), 'TF3B');

        bytes memory bytecode = type(BondingCurve).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token, superToken));
        assembly {
            bondingCurve := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        ERC20 token = new ERC20(symbol, name, bondingCurve, DEFAULT_ERC20_SUPPLY);
        IBondingCurve(bondingCurve).initialize(token, superToken, creationFee, swapFee, listingFee, listingReward, donationRate, ammFactory);

        getBondingCurve[token] = bondingCurve;
        if (superToken == address(0)) {
          getSubTokens[token].push(token); // Push a self-reference to make the super token initialized
        } else {
          getSuperToken[token] = superToken;
          getSubTokens[superToken].push(token);
        }
        allTokens.push(pair);

        emit TokenCreated(token, superToken, bondingCurve, allTokens.length);
    }

    function isSuperToken(address superToken) external view override returns (bool) {
        return getSubTokens[superToken].length > 0;
    }

    function setOwner(address _owner) external override {
        require(msg.sender == owner, 'TF00');
        require(_owner != owner, 'TF01');
        require(_owner != address(0), 'TF02');
        owner = _owner;
        emit OwnerSet(_owner);
    }
}
