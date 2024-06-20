// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ERC20Token3 {
    string public name;
    mapping(address => uint256) public balance;

    constructor(string memory _name) {
        name = _name;
    }

    function mint() public virtual {
        balance[tx.origin] += 1;
    }
}


contract MyToken is ERC20Token3 {
    string public symbol;
    address[] owners;
    uint256 public ownerCount = 0;

    constructor(string memory _symbol, string memory _name) ERC20Token3(_name) {
        symbol = _symbol;
    }

function mint() public override {
    super.mint();
    ownerCount++;
    owners.push(msg.sender);
}
}