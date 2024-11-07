// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Employee {
    // State Variables
    uint16 private shares;    // Employee's number of shares owned
    uint32 private salary;    // Employee's salary (0 to 1,000,000)
    string public name;       // Employee's name
    uint256 public idNumber;  // Employee's ID number (up to 2^256 - 1)

    // Custom error for exceeding maximum shares
    error TooManyShares(uint256 totalShares);

    // Constructor to initialize state variables
    constructor(uint16 _shares, string memory _name, uint32 _salary, uint256 _idNumber) {
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }

    // Function to view the salary
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    // Function to view the number of shares
    function viewShares() public view returns (uint16) {
        return shares;
    }

    // Function to grant additional shares
    function grantShares(uint16 _newShares) public {
        uint256 newTotalShares = shares + _newShares;

        if (_newShares > 5000) {
            revert("Too many shares");
        }

        if (newTotalShares > 5000) {
            revert TooManyShares(newTotalShares);
        }

        shares += _newShares;
    }

    /**
    * Do not modify this function.  It is used to enable the unit test for this pin
    * to check whether or not you have configured your storage variables to make
    * use of packing.
    *
    * If you wish to cheat, simply modify this function to always return `0`
    * I'm not your boss ¯\_(ツ)_/¯
    *
    * Fair warning though, if you do cheat, it will be on the blockchain having been
    * deployed by your wallet....FOREVER!
    */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    /**
    * Warning: Anyone can use this function at any time!
    */
    function debugResetShares() public {
        shares = 1000;
    }
}


