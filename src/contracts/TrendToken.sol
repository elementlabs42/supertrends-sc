// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import { Burnable } from './abstracts/Burnable.sol';
import { ERC20 } from './abstracts/ERC20.sol';
import { Mintable } from './abstracts/Mintable.sol';
import { Ownable } from './abstracts/Ownable.sol';
import { IERC20Permit } from './interfaces/IERC20Permit.sol';

contract TrendToken is ERC20, IERC20Permit, Ownable, Mintable, Burnable {
    bytes32 public constant DOMAIN_TYPEHASH =
        keccak256('EIP712Domain(string name,uint256 chainId,address verifyingContract)');
    bytes32 public constant PERMIT_TYPEHASH =
        keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 expiry)');

    mapping(address account => uint256 nextNonce) public nonces;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {
        _setOwner(msg.sender);
        // _setMinter(msg.sender, true); // TODO: should Factory be minter?
        // _setBurner(msg.sender, true); // TODO: should Factory be burner?
    }

    function setMinter(address minter, bool isMinter) external onlyOwner {
        _setMinter(minter, isMinter);
    }

    function setBurner(address burner, bool isBurner) external onlyOwner {
        _setBurner(burner, isBurner);
    }

    function mint(address receiver, uint256 amount) public virtual override {
        super.mint(receiver, amount);
        _mint(receiver, amount);
    }

    function burn(uint256 amount) public virtual override {
        super.burn(amount);
        _burn(msg.sender, amount);
    }

    function burnFrom(address from, uint256 amount) public virtual override {
        super.burn(amount);
        _spendAllowance(from, msg.sender, amount);
        _burn(from, amount);
    }

    function permit(address _owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external
        override
    {
        if (block.timestamp > deadline) {
            revert ERC20PermitSignatureExpired(deadline);
        }
        bytes32 domainSeparator =
            keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name())), block.chainid, address(this)));
        uint256 nonce = nonces[_owner]++;
        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, _owner, spender, value, nonce, deadline));
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainSeparator, structHash));
        address signer = ecrecover(digest, v, r, s);
        if (signer != _owner) {
            revert ERC20InvalidSigner(signer, _owner);
        }
        _approve(signer, spender, value, true);
    }
}
