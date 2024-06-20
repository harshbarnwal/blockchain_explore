// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

//check basic string operations

contract String {
    //two strings can be concatinated using an explicit conversion to bytes
    function concat() pure public returns (string memory) {
       string memory s = string(bytes.concat(bytes("first"), bytes("second")));
       return s;
    }

     //two strings can be compared using hash comparison
    function compare() pure public returns (bool) {
       return keccak256(abi.encodePacked("hello")) == keccak256(abi.encodePacked("hello"));
       
    }


}

