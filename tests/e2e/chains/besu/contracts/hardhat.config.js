require("@nomicfoundation/hardhat-toolbox");
require("./scripts/sendPacket");

const mnemonic =
  "math razor capable expose worth grape metal sunset metal sudden usage scheme";

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    version: "0.8.28",
    settings: {
      optimizer: {
        enabled: true,
        runs: 9_999_999
      }
    },
  },
  networks: {
    besu_local: {
      chainId: 2018,
      url: 'http://localhost:8645',
      accounts: {
        mnemonic: mnemonic,
        path: "m/44'/60'/0'/0",
        initialIndex: 0,
        count: 10
      }
    }
  }
}
