// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FavoriteRecords {
    // Mapping of approved album names to a boolean
    mapping(string => bool) public approvedRecords;

    // List of approved album names
    string[] public approvedRecordList;

    // Mapping from user addresses to their favorite records (album name => bool)
    mapping(address => mapping(string => bool)) private userFavorites;

    // Mapping from user addresses to a list of their favorite album names
    mapping(address => string[]) private userFavoriteList;

    // Custom error for non-approved albums
    error NotApproved(string albumName);

    // Constructor to load approved records
    constructor() {
        // List of approved album names
        string[9] memory albums = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];

        // Load approved records into the mapping and array
        for (uint256 i = 0; i < albums.length; i++) {
            approvedRecords[albums[i]] = true;
            approvedRecordList.push(albums[i]);
        }
    }

    // Function to get all approved records
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordList;
    }

    // Function to add a record to the caller's favorites
    function addRecord(string memory albumName) public {
        if (!approvedRecords[albumName]) {
            revert NotApproved(albumName);
        }
        if (!userFavorites[msg.sender][albumName]) {
            userFavorites[msg.sender][albumName] = true;
            userFavoriteList[msg.sender].push(albumName);
        }
    }

    // Function to get a user's favorite records
    function getUserFavorites(address user) public view returns (string[] memory) {
        return userFavoriteList[user];
    }

    // Function to reset the caller's favorite records
    function resetUserFavorites() public {
        string[] storage favorites = userFavoriteList[msg.sender];

        // Reset the mapping entries to false
        for (uint256 i = 0; i < favorites.length; i++) {
            userFavorites[msg.sender][favorites[i]] = false;
        }

        // Delete the user's favorite list
        delete userFavoriteList[msg.sender];
    }
}
