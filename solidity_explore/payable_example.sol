// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ERC20Token {
    string name;
    mapping(address => uint256) public balance;

    function mint() public {
        balance[tx.origin] += 1;
    }
}

contract PayableExample {

    address payable wallet;
    address token;
    // mapping(address => uint256) public balance;

    event Purchase(
        address _buyer,
        uint256 _amount
    );

    constructor(address _token, address payable _wallet) {
        token = _token;
        wallet = _wallet;
    }

    function buyToken() public payable {
        require(msg.value > 0);
        // balance[msg.sender] += 1;
        ERC20Token erc20Token = ERC20Token(address(token));
        erc20Token.mint();
        wallet.transfer(msg.value);

        emit Purchase(msg.sender, 1);
    }

}