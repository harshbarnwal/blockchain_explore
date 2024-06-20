pragma solidity ^0.8.17

contract DutchAuction {

    struct Item {
        uint id,
        string name,
        uint256 reservePrice,
        address ownerAddress,
    }
    
    mapping(uint => Item) public items;
    event InitialBidStart(timestamp startTime, uint itemName);

    function addNewItem(string name, uint256 reservePrice) {
        items[items.length] = Item(
            id: items.length,
            name: name,
            reservePrice: reservePrice,
            ownerAddress: msg.sender
        )
    }

    function startInitialBid() {
        
    }

}