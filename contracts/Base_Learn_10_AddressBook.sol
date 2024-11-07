// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import the Ownable contract from OpenZeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/**
 * @title AddressBook
 * @dev An address book that allows the owner to add, delete, and view contacts.
 */
contract AddressBook is Ownable {
    // Contact struct
    struct Contact {
        uint256 id;
        string firstName;
        string lastName;
        uint256[] phoneNumbers;
    }

    // Mapping from contact ID to Contact struct
    mapping(uint256 => Contact) private contacts;

    // Array of contact IDs to keep track of contacts
    uint256[] private contactIds;

    // Custom error for contact not found
    error ContactNotFound(uint256 id);

    /**
     * @dev Initializes the contract by setting the deployer as the initial owner.
     */
    constructor(address initialOwner) Ownable(initialOwner) {
        // Additional initialization if needed
    }

    /**
     * @dev Adds a new contact to the address book.
     * @param _id The unique ID of the contact.
     * @param _firstName The first name of the contact.
     * @param _lastName The last name of the contact.
     * @param _phoneNumbers An array of phone numbers for the contact.
     */
    function addContact(
        uint256 _id,
        string memory _firstName,
        string memory _lastName,
        uint256[] memory _phoneNumbers
    ) public onlyOwner {
        // Check if contact with the same ID already exists
        if (bytes(contacts[_id].firstName).length != 0) {
            revert("Contact with this ID already exists");
        }

        contacts[_id] = Contact({
            id: _id,
            firstName: _firstName,
            lastName: _lastName,
            phoneNumbers: _phoneNumbers
        });
        contactIds.push(_id);
    }

    /**
     * @dev Deletes a contact from the address book.
     * @param _id The unique ID of the contact to delete.
     */
    function deleteContact(uint256 _id) public onlyOwner {
        if (bytes(contacts[_id].firstName).length == 0) {
            revert ContactNotFound(_id);
        }
        delete contacts[_id];

        // Remove the ID from the contactIds array
        for (uint256 i = 0; i < contactIds.length; i++) {
            if (contactIds[i] == _id) {
                contactIds[i] = contactIds[contactIds.length - 1];
                contactIds.pop();
                break;
            }
        }
    }

    /**
     * @dev Retrieves a contact's information.
     * @param _id The unique ID of the contact to retrieve.
     * @return The Contact struct containing the contact's information.
     */
    function getContact(uint256 _id) public view returns (Contact memory) {
        if (bytes(contacts[_id].firstName).length == 0) {
            revert ContactNotFound(_id);
        }
        return contacts[_id];
    }

    /**
     * @dev Retrieves all contacts in the address book.
     * @return An array of Contact structs.
     */
    function getAllContacts() public view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](contactIds.length);
        for (uint256 i = 0; i < contactIds.length; i++) {
            allContacts[i] = contacts[contactIds[i]];
        }
        return allContacts;
    }
}
