// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Import the SillyStringUtils library
library SillyStringUtils {

    struct Haiku {
        string line1;
        string line2;
        string line3;
    }

    function shruggie(string memory _input) internal pure returns (string memory) {
        return string.concat(_input, unicode" 🤷");
    }
}

contract ImportsExercise {
    // Use the SillyStringUtils library for string operations
    using SillyStringUtils for string;

    // Public instance of Haiku called haiku
    SillyStringUtils.Haiku public haiku;

    // Save Haiku function
    function saveHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) public {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }

    // Get Haiku function that returns the haiku as a Haiku type
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    // Shruggie Haiku function
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        SillyStringUtils.Haiku memory modifiedHaiku = haiku;
        modifiedHaiku.line3 = modifiedHaiku.line3.shruggie();
        return modifiedHaiku;
    }
}
