// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicMath {
    // Adder function
    function adder(uint _a, uint _b) public pure returns (uint sum, bool error) {
        unchecked {
            sum = _a + _b;
        }
        // Check for overflow
        if (sum >= _a) {
            error = false; // No overflow
        } else {
            sum = 0;
            error = true; // Overflow occurred
        }
    }

    // Subtractor function
    function subtractor(uint _a, uint _b) public pure returns (uint difference, bool error) {
        unchecked {
            difference = _a - _b;
        }
        // Check for underflow
        if (_a >= _b) {
            error = false; // No underflow
        } else {
            difference = 0;
            error = true; // Underflow occurred
        }
    }
}
