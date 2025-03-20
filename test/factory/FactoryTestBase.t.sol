// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { Factory } from '../../src/contracts/Factory.sol';
import { UUPSProxy } from '../../src/contracts/UUPSProxy.sol';
import { Test } from 'forge-std/Test.sol';

abstract contract FactoryTestBase is Test {
    address public wallet = vm.addr(1);
    address public randomUser = vm.addr(123);

    Factory public implementationFactory;
    UUPSProxy public proxy;
    Factory public factory;

    function setUp() public {
        // set up wallet balance
        vm.deal(wallet, 10 ether);

        implementationFactory = new Factory();

        proxy =
            new UUPSProxy(address(implementationFactory), abi.encodeWithSelector(Factory.initialize.selector, wallet));

        factory = Factory(payable(proxy));
    }
}
