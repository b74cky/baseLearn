// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArraysExercise {
    // Initialize the numbers array with values 1 to 10
    uint[] public numbers = [1,2,3,4,5,6,7,8,9,10];

    // Return the entire numbers array
    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    // Reset numbers array to its initial value without using .push()
    function resetNumbers() public {
        uint[10] memory initialNumbers = [uint(1),2,3,4,5,6,7,8,9,10];
        numbers = initialNumbers;
    }

    // Append an array to the existing numbers array
    function appendToNumbers(uint[] calldata _toAppend) public {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    // Declare senders and timestamps arrays
    address[] public senders;
    uint[] public timestamps;

    // Save the timestamp and the caller's address
    function saveTimestamp(uint _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    // Return timestamps and senders after Y2K (January 1, 2000)
    function afterY2K() public view returns (uint[] memory, address[] memory) {
        uint count = 0;
        // First loop to count how many timestamps are after Y2K
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                count++;
            }
        }

        // Create arrays of the correct size
        uint[] memory recentTimestamps = new uint[](count);
        address[] memory recentSenders = new address[](count);

        uint index = 0;
        // Second loop to populate the arrays
        for (uint i = 0; i < timestamps.length; i++) {
            if (timestamps[i] > 946702800) {
                recentTimestamps[index] = timestamps[i];
                recentSenders[index] = senders[i];
                index++;
            }
        }

        return (recentTimestamps, recentSenders);
    }

    // Reset the senders array
    function resetSenders() public {
        delete senders;
    }

    // Reset the timestamps array
    function resetTimestamps() public {
        delete timestamps;
    }
}
