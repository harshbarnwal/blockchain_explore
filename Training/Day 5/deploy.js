const ethers = require("ethers");
const config = require("./config.json");
const fs = require("fs-extra");

const providerInfura = new ethers.providers.InfuraProvider("goerli", "62c36671929247c28067de709013b0ef");

const adminWallet = new ethers.Wallet("ca7cce5b6393464333eed7f6e4c287dafe42ae41f0636cba17a49245a6080583", providerInfura)
console.log(`Loaded wallet ${adminWallet.address}`);

let compiled = require(`./build/${process.argv[2]}.json`);

(async () => {
    console.log(`\nDeploying ${process.argv[2]} in ${config.network}...`);
    let contract = new ethers.ContractFactory(
        compiled.abi,
        compiled.bytecode,
        adminWallet
    );

    let instance = await contract.deploy(config.decimals, config.symbol, config.name, config.total_supply);
    console.log(`deployed at ${instance.address}`);
    config[`${process.argv[2]}`] = instance.address;
    console.log("Waiting for the contract to get mined...");
    await instance.deployed();
    console.log("Contract deployed");
    fs.outputJsonSync(
        "config.json",
        config,
        {
            spaces: 2,
            EOL: "\n"
        }
    );

})();
