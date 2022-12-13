import "@nomicfoundation/hardhat-toolbox";
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

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.7.0"
      },
      {
        version: "0.7.5"
      },
      {
        version: "0.8.0"
      },
      {
        version: "0.8.17"
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
