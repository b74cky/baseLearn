// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ControlStructures {
    // Custom error for AfterHours
    error AfterHours(uint256 time);

    // fizzBuzz function
    function fizzBuzz(uint256 _number) public pure returns (string memory) {
        if (_number % 15 == 0) {
            return "FizzBuzz";
        } else if (_number % 3 == 0) {
            return "Fizz";
        } else if (_number % 5 == 0) {
            return "Buzz";
        } else {
            return "Splat";
        }
    }

    // doNotDisturb function
    function doNotDisturb(uint256 _time) public pure returns (string memory) {
        // If _time >= 2400, trigger a panic
        if (_time >= 2400) {
            assert(false);
        }
        // If _time > 2200 or _time < 800, revert with custom error AfterHours
        else if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        }
        // If _time between 1200 and 1259, revert with string message "At lunch!"
        else if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        }
        // If _time between 800 and 1199, return "Morning!"
        else if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }
        // If _time between 1300 and 1799, return "Afternoon!"
        else if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        }
        // If _time between 1800 and 2200, return "Evening!"
        else if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }
        // For any other time not covered, return an empty string
        else {
            return "";
        }
    }
}
