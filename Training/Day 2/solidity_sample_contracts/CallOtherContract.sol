// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Callee {
    uint public x;
    uint public value;

    function setX(uint _x) public returns (uint) {
        x = _x;
        return x;
    }

    function setXandSendEther(uint _x) public payable returns (uint, uint) {
        x = _x;
        value = msg.value;

        return (x, value);
    }
}

contract Caller {
    //this demonstrates a contract type
    //pass the address - but it is recieved as an address.
    function setX(Callee _callee, uint _x) public {
        uint x = _callee.setX(_x);
    }
    //pass the address which gets casted to a contract 
    function setXFromAddress(address _addr, uint _x) public {
        Callee callee = Callee(_addr);
        callee.setX(_x);
    }
    //send the value to the callee contract 
    function setXandSendEther(Callee _callee, uint _x) public payable {
        (uint x, uint value) = _callee.setXandSendEther{value: msg.value}(_x);
    }
}

