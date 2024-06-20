// SPDX-License-Identifier: MIT
// HarshCoin ICO
pragma solidity ^0.8.18;

contract harshcoin_ico {

    // Introducing the max no of Harshcoins available for sale
    uint public max_harshcoins = 1000000;

    // Introducing the USD to Harshcoins conversion rate
    uint public usd_to_harshcoins = 1000;

    // Introducing the total no of Harshcoins that have been brought by the investors
    uint public total_harshcoins_bought = 0;

    // Mapping from the investor address to its equity in Harshcoins and USD
    mapping(address => uint) equity_harshcoins;
    mapping(address => uint) equity_usd;

    // Checking if an investor can buy Harshcoins
    modifier can_buy_harshcoins(uint usd_invested) {
        require(usd_invested * usd_to_harshcoins + total_harshcoins_bought <= max_harshcoins, "Not enough Harshcoins available to buy");
        _;
    }

    // Checking if an investor can sell Harscoins
    modifier can_sell_harshcoins(address seller, uint harshcoins_sold) {
        require(equity_harshcoins[seller] >= harshcoins_sold, "You dont't have enough Harshcoins to sell");
        _;
    }

    // Getting the equity in Harshcoins of an investor
    function equity_in_harshcoins(address investor) external view returns (uint) {
        return equity_harshcoins[investor];
    }

    // Getting the equity in USD of an investor
    function equity_in_usd(address investor) external view returns (uint) {
        return equity_usd[investor];
    }

    // Buying Harshcoins
    function buy_harshcoins(address investor, uint usd_invested) external can_buy_harshcoins(usd_invested) {
        uint harshcoins_bought = usd_invested * usd_to_harshcoins;
        equity_harshcoins[investor] += harshcoins_bought;
        equity_usd[investor] = equity_harshcoins[investor] / usd_to_harshcoins;
        total_harshcoins_bought += harshcoins_bought;
    }

    // Selling Harshcoins
    function sell_harshcoins(address investor, uint harshcoins_sold) external can_sell_harshcoins(investor, harshcoins_sold) {
        equity_harshcoins[investor] -= harshcoins_sold;
        equity_usd[investor] = equity_harshcoins[investor] / usd_to_harshcoins;
        total_harshcoins_bought -= harshcoins_sold;
    }

}