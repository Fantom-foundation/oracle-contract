const OracleStore = artifacts.require("OracleStore");

module.exports = async(deployer, network, accounts) => {
  let accs = accounts.slice(0, 2);
  await deployer.deploy(OracleStore, accs);
};
