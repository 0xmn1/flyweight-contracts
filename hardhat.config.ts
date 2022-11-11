import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from 'dotenv';

dotenv.config();

if (!process.env.ALCHEMY_URL) {
  throw 'Config error: missing alchemy url';
}
if (!process.env.GOERLI_PRIVATE_KEY) {
  throw 'Config error: missing goerli private key';
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
  }
};

export default config;