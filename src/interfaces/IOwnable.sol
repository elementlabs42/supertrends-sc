// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IOwnable {
    event OwnerSet(address indexed _owner);

    error OwnableInvalidOwner(address _owner);
    error OwnableSameValueAlreadySet();
    error OwnableUnauthorizedOwner(address _owner);

    function getOwner() external view returns (address _owner);

    function setOwner(address _owner) external;
}
