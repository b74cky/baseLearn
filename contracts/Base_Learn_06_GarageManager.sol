// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GarageManager {
    // Define the Car struct
    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    // Mapping from address to an array of Cars
    mapping(address => Car[]) public garage;

    // Custom error for invalid car index
    error BadCarIndex(uint256 index);

    // Add a car to the user's garage
    function addCar(
        string memory make,
        string memory model,
        string memory color,
        uint256 numberOfDoors
    ) public {
        Car memory newCar = Car({
            make: make,
            model: model,
            color: color,
            numberOfDoors: numberOfDoors
        });

        garage[msg.sender].push(newCar);
    }

    // Get all cars for the calling user
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    // Get all cars for any user
    function getUserCars(address user) public view returns (Car[] memory) {
        return garage[user];
    }

    // Update a car at a specific index
    function updateCar(
        uint256 index,
        string memory make,
        string memory model,
        string memory color,
        uint256 numberOfDoors
    ) public {
        if (index >= garage[msg.sender].length) {
            revert BadCarIndex(index);
        }

        garage[msg.sender][index] = Car({
            make: make,
            model: model,
            color: color,
            numberOfDoors: numberOfDoors
        });
    }

    // Reset the sender's garage
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
