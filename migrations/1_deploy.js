const TurpleCore = artifacts.require("TurpleCore")
const TurpleToken = artifacts.require("TurpleToken")

module.exports = async function(deployer, network, accounts) {
    if (network == "testnet_test") return;
    await deployer.deploy(TurpleToken)
    await deployer.deploy(TurpleCore, TurpleToken.address)
};