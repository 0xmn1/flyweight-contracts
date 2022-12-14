import '@nomicfoundation/hardhat-toolbox';
import 'solidity-docgen';

import { HardhatUserConfig } from "hardhat/config";
import dotenv from 'dotenv';

dotenv.config();

if (!process.env.ALCHEMY_URL) {
  throw 'Config error: missing alchemy url';
}
if (!process.env.GOERLI_PRIVATE_KEY) {
  throw 'Config error: missing goerli private key';
}
if (!process.env.GOERLI_ETHERSCAN_API_KEY) {
  throw 'Config error: missing goerli etherscan api key';
}

const settings = {
  optimizer: {
    enabled: true,
    runs: 1,  // Optimize gas cost during contract creation
  }
};

const config: HardhatUserConfig = {
  solidity: {
    settings,
    compilers: [
      {
        version: "0.7.0",
        settings
      },
      {
        version: "0.7.5",
        settings
      },
      {
        version: "0.8.0",
        settings
      },
      {
        version: "0.8.17",
        settings
      }
    ]
  },
  paths: {
    sources: './src/contracts'
  },
  networks: {
    goerli: {
      url: process.env.ALCHEMY_URL,
      accounts: [process.env.GOERLI_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: {
      goerli: process.env.GOERLI_ETHERSCAN_API_KEY
    }
  },
  docgen: {
  },
};

export default config;
