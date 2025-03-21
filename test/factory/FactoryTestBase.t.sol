// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { Factory } from '../../src/Factory.sol';
import { UUPSProxy } from '../../src/UUPSProxy.sol';
import { Test } from 'forge-std/Test.sol';

abstract contract FactoryTestBase is Test {
    uint256 public constant DEFAULT_TOKEN_CREATION_FEE = 1e18;
    uint256 public constant DEFAULT_TOKEN_TRADE_FEE = 1e18;
    uint256 public constant DEFAULT_LISTING_FEE = 1e18;
    uint256 public constant DEFAULT_CREATOR_REWARD = 1e18;
    uint256 public constant DEFAULT_DONATION_RATE = 1e18;
    uint256 public constant DEFAULT_LISTING_RATE = 1e18;

    address public wallet = vm.addr(1);
    address public randomUser = vm.addr(123);

    Factory public implementationFactory;
    UUPSProxy public proxy;
    Factory public factory;

    function setUp() public {
        // set up wallet balance
        vm.deal(wallet, 10 ether);

        implementationFactory = new Factory();

        proxy = new UUPSProxy(
            address(implementationFactory),
            abi.encodeWithSelector(
                Factory.initialize.selector,
                wallet,
                DEFAULT_TOKEN_CREATION_FEE,
                DEFAULT_TOKEN_TRADE_FEE,
                DEFAULT_LISTING_FEE,
                DEFAULT_CREATOR_REWARD,
                DEFAULT_DONATION_RATE,
                DEFAULT_LISTING_RATE
            )
        );

        factory = Factory(payable(proxy));
    }
}
