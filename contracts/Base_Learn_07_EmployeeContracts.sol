// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Abstract contract Employee
abstract contract Employee {
    uint256 public idNumber;
    uint256 public managerId;

    constructor(uint256 _idNumber, uint256 _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() public view virtual returns (uint256);
}

// Salaried contract inheriting from Employee
contract Salaried is Employee {
    uint256 public annualSalary;

    constructor(uint256 _idNumber, uint256 _managerId, uint256 _annualSalary)
        Employee(_idNumber, _managerId)
    {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public view override returns (uint256) {
        return annualSalary;
    }
}

// Hourly contract inheriting from Employee
contract Hourly is Employee {
    uint256 public hourlyRate;

    constructor(uint256 _idNumber, uint256 _managerId, uint256 _hourlyRate)
        Employee(_idNumber, _managerId)
    {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public view virtual override returns (uint256) {
        return hourlyRate * 2080; // 2080 working hours in a year
    }
}

// Manager contract
contract Manager {
    uint256[] public employeeIds;

    function addReport(uint256 _employeeId) public {
        employeeIds.push(_employeeId);
    }

    function resetReports() public {
        delete employeeIds;
    }
}

// Salesperson contract inheriting from Hourly
contract Salesperson is Hourly {
    constructor(uint256 _idNumber, uint256 _managerId, uint256 _hourlyRate)
        Hourly(_idNumber, _managerId, _hourlyRate)
    {}
}

// EngineeringManager contract inheriting from Salaried and Manager
contract EngineeringManager is Salaried, Manager {
    constructor(uint256 _idNumber, uint256 _managerId, uint256 _annualSalary)
        Salaried(_idNumber, _managerId, _annualSalary)
    {}
}

// InheritanceSubmission contract
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}
