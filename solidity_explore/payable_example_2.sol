// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "erc20_token.sol";

contract PayableExample2 {

address payable wallet;
address token;
address owner;

constructor(address _token, address payable _wallet) {
    token = _token;
    wallet = _wallet;
    owner = msg.sender;
}

modifier ownerOnly() {
require(msg.sender == owner);
_;
}

function buyToken() public ownerOnly payable {
    require(msg.value > 0);
    ERC20Token2 erc20Token = ERC20Token2(address(token));
    erc20Token.mint();
    wallet.transfer(msg.value);
}

}