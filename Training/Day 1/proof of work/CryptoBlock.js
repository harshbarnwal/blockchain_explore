const SHA256 = require("crypto-js/sha256");
class CryptoBlock {
  constructor(index, timestamp, data, precedingHash = " ") {
    //this is the basic bloc structure
    this.index = index; //block height
    this.timestamp = timestamp; //the time of the block
    this.data = data; //this is the transaction data
    this.precedingHash = precedingHash;
    this.hash = this.computeHash();
    this.nonce = 0;
  }

  computeHash() {
    return SHA256(
      this.index +
        this.precedingHash +
        this.timestamp +
        JSON.stringify(this.data) +
        this.nonce
    ).toString();
  }

  proofOfWork(difficulty) {
    while (
    	//this.hash == 0000000adsiauhdiushdu
      this.hash.substring(0, difficulty) !== Array(difficulty + 1).join("0")
    ) {
      this.nonce++;
      	console.log("nonce now "+this.nonce)
      this.hash = this.computeHash();
    }
  }
}


//this is a blockchain ledger
class CryptoBlockchain {
  constructor() {
    this.blockchain = [this.startGenesisBlock()];
    this.difficulty = 5;
  }
  startGenesisBlock() {
    return new CryptoBlock(0, "01/01/2022", "Initial Block in the Chain", "0");
  }

  obtainLatestBlock() {
    return this.blockchain[this.blockchain.length - 1];
  }
  addNewBlock(newBlock) {
    newBlock.precedingHash = this.obtainLatestBlock().hash;
    //newBlock.hash = newBlock.computeHash();
    newBlock.proofOfWork(this.difficulty);
    this.blockchain.push(newBlock);
  }

  checkChainValidity() {
    for (let i = 1; i < this.blockchain.length; i++) {
      const currentBlock = this.blockchain[i];
      const precedingBlock = this.blockchain[i - 1];

      if (currentBlock.hash !== currentBlock.computeHash()) {
        return false;
      }
      if (currentBlock.precedingHash !== precedingBlock.hash) return false;
    }
    return true;
  }
}

let trainingCoin = new CryptoBlockchain();

console.log("trainingCoin mining in progress....");
trainingCoin.addNewBlock(
  new CryptoBlock(1, "01/06/2020", {
    sender: "Yash Sharma",
    recipient: "Vikas Gupta",
    quantity: 50
  })
);

trainingCoin.addNewBlock(
  new CryptoBlock(2, "01/07/2020", {
    sender: "Vikas Gupta",
    recipient: "Vivek Singh",
    quantity: 100
  })
);

console.log(JSON.stringify(trainingCoin, null, 4));

