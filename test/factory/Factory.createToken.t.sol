// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import { IFactory } from '../../src/interfaces/IFactory.sol';

import { FactoryTestBase } from './FactoryTestBase.t.sol';
import 'forge-std/Test.sol';

contract FactoryCreateTokenTest is FactoryTestBase {
    function test_createSuperToken_success() public {
        // Act
        vm.recordLogs();
        factory.createToken('SuperToken', 'SUP', address(0));
        Vm.Log[] memory logs = vm.getRecordedLogs();

        // Assert
        assertEq(logs.length, 2, 'Event was not emitted');
        assertEq(logs[1].topics[0], keccak256('SuperTokenCreated(address,address)'));
        assertEq(address(uint160(uint256(logs[1].topics[1]))), factory.getAllTokens()[0]);
        assertEq(address(uint160(uint256(logs[1].topics[2]))), address(this));

        address superToken = factory.getAllTokens()[0];
        assertEq(factory.getAllTokens().length, 1);
        assertNotEq(factory.getBondingCurve(superToken), address(0));
        assertTrue(factory.isSuperToken(superToken));
        assertEq(factory.getSuperToken(superToken), superToken);
    }

    function test_createSubToken_success() public {
        // Act
        factory.createToken('SuperToken', 'SUP', address(0));
        vm.recordLogs();
        factory.createToken('SubToken', 'SUB', factory.getAllTokens()[0]);
        Vm.Log[] memory logs = vm.getRecordedLogs();

        // Assert
        assertEq(logs.length, 2, 'Events were not emitted');
        assertEq(logs[0].topics[0], keccak256('Transfer(address,address,uint256)'));
        assertEq(logs[1].topics[0], keccak256('SubTokenCreated(address,address,address)'));
        assertEq(address(uint160(uint256(logs[1].topics[1]))), factory.getAllTokens()[1]);
        assertEq(address(uint160(uint256(logs[1].topics[2]))), factory.getAllTokens()[0]);
        assertEq(address(uint160(uint256(logs[1].topics[3]))), address(this));

        address superToken = factory.getAllTokens()[0];
        address subToken = factory.getAllTokens()[1];
        assertEq(factory.getAllTokens().length, 2);
        assertNotEq(factory.getBondingCurve(subToken), address(0));
        assertFalse(factory.isSuperToken(subToken));
        assertEq(factory.getSuperToken(subToken), superToken);
        assertEq(factory.getSubTokens(superToken).length, 1);
        assertEq(factory.getSubTokens(superToken)[0], subToken);
    }

    function test_createSubToken_revert_if_not_superToken() public {
        // Act && Assert
        factory.createToken('SuperToken', 'SUP', address(0));
        vm.expectRevert(abi.encodeWithSelector(IFactory.FactoryMustBeSuperToken.selector, address(1)));
        factory.createToken('SubToken', 'SUB', address(1));
    }
}
