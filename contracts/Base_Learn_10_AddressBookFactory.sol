// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import the AddressBook contract
import "./Base_Learn_09_AddressBook.sol";

/**
 * @title AddressBookFactory
 * @dev Factory contract to deploy AddressBook instances.
 */
contract AddressBookFactory {
    /**
     * @dev Deploys a new AddressBook contract and assigns ownership to the caller.
     * @return The address of the newly deployed AddressBook contract.
     */
    function deploy() public returns (address) {
        AddressBook addressBook = new AddressBook(msg.sender);
        // No need to transfer ownership since it's set in the constructor
        return address(addressBook);
    }
}
