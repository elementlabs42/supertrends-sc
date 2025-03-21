// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import { Factory } from '../../src/Factory.sol';

import { UUPSProxy } from '../../src/UUPSProxy.sol';
import { Initializable } from '../../src/abstracts/Initializable.sol';
import { UUPSUpgradeable } from '../../src/abstracts/UUPSUpgradeable.sol';
import { ERC1967Utils } from '../../src/libraries/ERC1967Utils.sol';

import { FactoryV2 } from '../utils/FactoryV2.t.sol';
import { FactoryV3 } from '../utils/FactoryV3.t.sol';
import { TestToken } from '../utils/TestToken.t.sol';
import { FactoryTestBase } from './FactoryTestBase.t.sol';

contract FactoryProxyTest is FactoryTestBase {
    function test_initialize_success() public view {
        // Assert
        assertEq(factory.getAdmin(), address(this));
        assertEq(factory.getOwner(), wallet);
    }

    function test_initialize_revert_if_already_initialized() public {
        // Assert
        vm.expectRevert(abi.encodeWithSelector(Initializable.InvalidInitialization.selector));
        factory.initialize(address(this));
    }

    function test_upgrade_revert_if_not_admin() public {
        // Arrange
        address newImplementation = address(new Factory());

        // Act && Assert
        vm.startPrank(randomUser);
        vm.expectRevert(abi.encodeWithSelector(UUPSUpgradeable.OnlyAdminCanUpgrade.selector));
        factory.upgradeToAndCall(newImplementation, '');
        vm.stopPrank();
    }

    function test_upgrade_success() public {
        // Arrange
        address newImplementation = address(new Factory());

        // Act && Assert
        vm.prank(factory.getAdmin());
        factory.upgradeToAndCall(newImplementation, '');
    }

    function test_upgrade_revert_if_implementation_not_uups_upgradeable() public {
        // Arrange
        address invalidImplementation = address(new TestToken('Test', 'TEST'));

        // Act && Assert
        vm.startPrank(factory.getAdmin());
        vm.expectRevert(
            abi.encodeWithSelector(ERC1967Utils.ERC1967InvalidImplementation.selector, invalidImplementation)
        );
        factory.upgradeToAndCall(invalidImplementation, '');
        vm.stopPrank();
    }

    function test_upgrade_and_reinitialize_V2() public {
        // Arrange
        FactoryV2 newImplementation = new FactoryV2();

        // Act
        vm.startPrank(factory.getAdmin());
        factory.upgradeToAndCall(
            address(newImplementation), abi.encodeWithSelector(FactoryV2.initializeV2.selector, randomUser)
        );
        vm.stopPrank();

        vm.expectRevert(abi.encodeWithSelector(Initializable.InvalidInitialization.selector));
        newImplementation.initializeV2(address(this));

        // Assert
        FactoryV2 factoryV2 = FactoryV2(payable(proxy));
        assertEq(factoryV2.getImplementation(), address(newImplementation));
        assertEq(factoryV2.getOwner(), randomUser);
    }

    function test_upgrade_and_reinitialize_V3() public {
        // Arrange
        address implementationV2 = address(new FactoryV2());
        address implementationV3 = address(new FactoryV3());

        // Act
        vm.startPrank(factory.getAdmin());
        factory.upgradeToAndCall(implementationV2, abi.encodeWithSelector(FactoryV2.initializeV2.selector, address(2)));
        factory.upgradeToAndCall(implementationV3, abi.encodeWithSelector(FactoryV3.initializeV3.selector, address(3)));
        vm.stopPrank();

        // Assert
        FactoryV3 factoryV3 = FactoryV3(payable(proxy));
        assertEq(factoryV3.getImplementation(), implementationV3);
        assertEq(factoryV3.getOwner(), address(3));
    }
}
