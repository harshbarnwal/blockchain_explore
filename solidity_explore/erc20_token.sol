// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ERC20Token2 {
    mapping(address => uint256) public balance;

    function mint() public {
        balance[tx.origin] += 1;
    }
}