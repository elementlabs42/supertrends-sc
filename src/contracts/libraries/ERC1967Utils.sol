// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

library ERC1967Utils {
    event Upgraded(address indexed implementation);
    event AdminChanged(address previousAdmin, address newAdmin);

    error ERC1967InvalidImplementation(address implementation);
    error ERC1967SameValueAlreadySet();
    error ERC1967NonPayable();
    error ERC1967InvalidAdmin(address admin);
    error ERC1967FailedCall();

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    function getImplementation() internal view returns (address __implementation) {
        assembly {
            __implementation := sload(_IMPLEMENTATION_SLOT)
        }
    }

    function _setImplementation(address __implementation) private {
        if (__implementation.code.length == 0) {
            revert ERC1967InvalidImplementation(__implementation);
        }
        if (__implementation == getImplementation()) {
            revert ERC1967SameValueAlreadySet();
        }
        assembly {
            sstore(_IMPLEMENTATION_SLOT, __implementation)
        }
    }

    /**
     * @dev Performs implementation upgrade with additional setup call if data is nonempty.
     * This function is payable only if the setup call is performed, otherwise `msg.value` is rejected
     * to avoid stuck value in the contract.
     */
    function upgradeToAndCall(address __implementation, bytes memory data) internal {
        _setImplementation(__implementation);
        emit Upgraded(__implementation);

        if (data.length > 0) {
            (bool success, bytes memory returndata) = __implementation.delegatecall(data);
            if (!success) {
                if (returndata.length > 0) {
                    // The easiest way to bubble the revert reason is using memory via assembly
                    assembly {
                        let returndata_size := mload(returndata)
                        revert(add(32, returndata), returndata_size)
                    }
                } else {
                    revert ERC1967FailedCall();
                }
            }
        } else {
            _checkNonPayable();
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1.
     */
    bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    function getAdmin() internal view returns (address __admin) {
        assembly {
            __admin := sload(_ADMIN_SLOT)
        }
    }

    function _setAdmin(address __admin) private {
        if (__admin == address(0)) {
            revert ERC1967InvalidAdmin(address(0));
        }
        if (__admin == getAdmin()) {
            revert ERC1967SameValueAlreadySet();
        }
        assembly {
            sstore(_ADMIN_SLOT, __admin)
        }
    }

    function changeAdmin(address __admin) internal {
        _setAdmin(__admin);
        emit AdminChanged(getAdmin(), __admin);
    }

    /**
     * @dev Reverts if `msg.value` is not zero. It can be used to avoid `msg.value` stuck in the contract
     * if an upgrade doesn't perform an initialization call.
     */
    function _checkNonPayable() private {
        if (msg.value > 0) {
            revert ERC1967NonPayable();
        }
    }
}
