// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Admin {
    // State variable to store a number
    address public owner;

    // You need to send a transaction to write to a state variable.
    constructor() {
    //    msg.sender;
       owner =  msg.sender;
        
    }

    // You can read from a state variable without sending a transaction.
    function adminOnly() public {
        require(msg.sender == owner, "caller not the owner");
        
    }
}

