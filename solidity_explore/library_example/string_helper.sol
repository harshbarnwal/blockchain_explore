// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

library StringHelper {

    function concatenateString(string memory a, string memory b) internal pure returns (string memory) {
        return string.concat(a, " ", b);
    }

}