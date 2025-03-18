// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IInitializable {
    event InitializedBy(address initializer);

    error InitializableAlreadyInitialized();

    function initialize() external;
}
