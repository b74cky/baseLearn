// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UnburnableToken {
    // Mapping to store balances of addresses
    mapping(address => uint256) public balances;

    // Total supply of tokens
    uint256 public totalSupply;

    // Total tokens claimed so far
    uint256 public totalClaimed;

    // Mapping to track whether an address has already claimed tokens
    mapping(address => bool) private hasClaimed;

    // Custom errors
    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address to);

    // Constructor that sets the total supply to 100,000,000
    constructor() {
        totalSupply = 100_000_000;
    }

    // Claim function
    function claim() public {
        // Check if all tokens have been claimed
        if (totalClaimed >= totalSupply) {
            revert AllTokensClaimed();
        }

        // Check if the caller has already claimed
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        // Update balances and total claimed
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
        hasClaimed[msg.sender] = true;
    }

    // Safe transfer function
    function safeTransfer(address _to, uint256 _amount) public {
        // Check if the recipient is a valid address and has a non-zero Ether balance
        if (_to == address(0) || _to.balance == 0) {
            revert UnsafeTransfer(_to);
        }

        // Check if the sender has enough tokens
        if (balances[msg.sender] < _amount) {
            revert("Insufficient balance");
        }

        // Perform the transfer
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}
