// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./string_helper.sol";
import "./safe_math.sol";

contract LibraryExample {

    using SafeMath for uint256;
    string firstName;
    string lastName;
    uint256 public value;

    constructor(string memory _firstName, string memory _lastName) {
        firstName = _firstName;
        lastName = _lastName;
    }

    function getFullName() public view returns (string memory) {
        return StringHelper.concatenateString(firstName, lastName);
    }

    function divide(uint256 a, uint256 b) public {
        value = a.div(b);
    }
}