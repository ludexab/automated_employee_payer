//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract EmployeePayer {
    address employer;
    uint256 budget;
    uint256 salary;
    bool payday;
    address payable[] public employees;
    mapping(address => uint256) employeeToWage;

    constructor() public payable {
        employer = msg.sender;
        budget = msg.value;
        payday = false;
    }

    modifier mustBeEmployer() {
        require(msg.sender == employer, "sorry, you are not the employer");
        _;
    }

    modifier mustBePayday() {
        require(payday == true, "sorry! it's not payday yet");
        _;
    }

    function setEmployeeWage(address payable _employee, uint256 _salary)
        public
        mustBeEmployer
    {
        employees.push(_employee);
        employeeToWage[_employee] = _salary;
    }

    function payEmployees() private mustBePayday {
        for (uint256 i = 0; i < employees.length; i++) {
            employees[i].transfer(employeeToWage[employees[i]]);
        }
    }

    function checkEmployee(uint256 _employeeIndex)
        public
        view
        returns (address)
    {
        return employees[_employeeIndex];
    }

    function checkEmployeeSalary(address _employeeAddress)
        public
        view
        returns (uint256)
    {
        return employeeToWage[_employeeAddress];
    }

    function ensurePayday() public {
        payday = true;
        payEmployees();
    }

    function checkEmployeeBalance(address _employeeAddress)
        public
        view
        returns (uint256)
    {
        return _employeeAddress.balance;
    }
}
