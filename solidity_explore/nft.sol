// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Example {
    enum BidState {notStarted, secretBid, openBid, endedBid}

    struct NFT {
 	    string name;
	    string imageUrl;
	    uint256 id;
	    address payable owner;
    }

    struct NFTBiding {
        uint256 highestBid;
        uint8 maxBidMultiplier;
        uint256 reservePrice;
        BidState bidState;
        uint256 bidStartTime;
    }

    mapping(uint256 => NFTBiding) nftBidingData;
    mapping(uint256 => mapping(address => bool)) participants;

    mapping(uint256 => NFT) nftList;
    uint256 public nftItemCount = 0;
    uint8 constant discountPerSec = 10;
    event SecretBidEnded();
    event SecretBidStarted(uint256 nftId);
    event StartOpenBid(uint256 nftId);
    event BidPriceChanged(uint256 nftId, uint256 newPrice);
    event AuctionCompleted(uint256 nftId);
    // event TestPrice(string, uint256);

    // user can add item
    function addItem(string memory name, string memory url, uint256 _reservePrice, uint8 maxMultiplier) public {
        nftList[nftItemCount] = NFT(name, url, nftItemCount, payable(msg.sender));
        nftBidingData[nftItemCount].highestBid = _reservePrice;
        nftBidingData[nftItemCount].maxBidMultiplier = maxMultiplier;
        nftBidingData[nftItemCount].reservePrice = _reservePrice;
        nftBidingData[nftItemCount].bidState = BidState.notStarted;
        nftItemCount++;
    }

    function startSecretBid(uint256 id) public {
        require(id < nftItemCount, "Item doesn't exists");
        NFTBiding memory bidingData = nftBidingData[id];
        NFT memory nftData = nftList[id];
        require(bidingData.bidState == BidState.notStarted, "Secret Bid has not started yet");
        require(nftData.owner == payable(msg.sender), "Only owner can start the bid");
        emit SecretBidStarted(id);
        nftBidingData[id].bidState = BidState.secretBid;
    }

    function addSecretBid(uint256 id, uint256 bidAmount) public {
        require(id < nftItemCount, "Item doesn't exists");
        NFTBiding memory bidingData = nftBidingData[id];
        NFT memory nftData = nftList[id];
        require(bidingData.bidState == BidState.secretBid, "Secret Bid has not started yet");
        require(nftData.owner != payable(msg.sender), "Owner can't place the bid");
        if (bidingData.highestBid < bidAmount) {
            nftBidingData[id].highestBid = bidAmount;
        }
        participants[id][msg.sender] = true;
    }

    function startOpenBid(uint256 id) public returns (uint256) {
        require(id < nftItemCount, "Item doesn't exists");
        NFTBiding memory bidingData = nftBidingData[id];
        NFT memory nftData = nftList[id];
        require(bidingData.bidState == BidState.secretBid, "Secret Bid has not started yet");
        require(nftData.owner == payable(msg.sender), "Only owner can start the bid");
        nftBidingData[id].bidStartTime = block.timestamp;
        nftBidingData[id].bidState = BidState.openBid;
        emit StartOpenBid(id);
        return bidingData.highestBid * bidingData.maxBidMultiplier;
    }

    function endOpenBid(uint256 id) public {
        require(id < nftItemCount, "Item doesn't exists");
        NFTBiding memory bidingData = nftBidingData[id];
        NFT memory nftData = nftList[id];
        require(bidingData.bidState == BidState.openBid, "Bid has not started yet");
        require(nftData.owner == payable(msg.sender), "Only owner can start the bid");
        nftBidingData[id].bidState = BidState.endedBid;
    }
    
    function getBidState(uint256 id) public view returns (NFTBiding memory) {
        require(id < nftItemCount, "Item doesn't exists");
        NFTBiding memory bidingData = nftBidingData[id];
        return bidingData;
    }

    function getItemCurrentPrice(uint256 id) public view returns (uint256) {
        require(id < nftItemCount, "Item doesn't exists");
        NFTBiding memory bidingData = nftBidingData[id];
        require(bidingData.bidState == BidState.openBid, "Open Bid has not started yet");
        uint256 elapsedTime = block.timestamp - bidingData.bidStartTime;
        // emit TestPrice("elapsedTime", elapsedTime);
        // emit TestPrice("block.timestamp", block.timestamp);
        uint256 discountPercentage = elapsedTime * (discountPerSec / 100);
        uint256 startAmount = (bidingData.highestBid * bidingData.maxBidMultiplier);
        uint256 price = startAmount - ((startAmount * discountPercentage) / 100);
        // emit TestPrice("price", price);
        return price;
    } // this will be calculated on FE

    function placeBid(uint256 id, uint256 amount) public payable {
        require(id < nftItemCount, "Item doesn't exists");
        NFTBiding memory bidingData = nftBidingData[id];
        NFT memory nftData = nftList[id];
        require(nftData.owner != payable(msg.sender), "Owner can't place the bid");
        require(bidingData.bidState == BidState.openBid, "Open bid has not started yet");
        require(amount > bidingData.reservePrice, "Bid price should not be less than reserve price");
        // require(msg.value >= amount, "Insuficient balance");
        // emit TestPrice("value", msg.value);
        nftList[id].owner.transfer(msg.value);
        nftList[id].owner = payable(msg.sender);
        nftBidingData[id].bidState = BidState.endedBid;
        emit AuctionCompleted(id);
    }

    function getNFTOwners() public view returns (NFT[] memory) {
        NFT[] memory ownerData = new NFT[](nftItemCount);
        for (uint8 i = 0; i < nftItemCount; i++) {
            ownerData[i] = nftList[i];
        }
        return ownerData;
    }
}