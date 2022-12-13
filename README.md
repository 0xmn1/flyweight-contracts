# Flyweight Smart Contracts
This repo contains **Solidity** smart contracts that support the Flyweight platform, & is live on the Goerli & Ethereum blockchains.

## Getting started
To view the front-end (that exists to allow users to interact with these contracts in a UX-friendly way), please visit [flyweight.me](https://flyweight.me/) or the [Flyweight Web3 Frontend](https://github.com/0xmn1/flyweight-web3-frontend) repo.

## Local setup
This repo has **hardhat** integration, including build & deploy scripts.
```bash
git clone git@github.com:0xmn1/flyweight-smart-contracts.git
cd 'flyweight-smart-contracts'
npm i
```

You will then need to do the usual secrets/env setup, which is in the `.env` file:
- `ALCHEMY_URL` is an [Alchemy](https://dashboard.alchemy.com/) api url.
- `GOERLI_PRIVATE_KEY` is an Alchemy **private** API key. Used by Hardhat during smart contract deployment.
- `GOERLI_ETHERSCAN_API_KEY` is an [Etherscan](https://etherscan.io/) API key. Used by hardhat during smart contract source verification. 

> Developer note: [Alchemy](https://dashboard.alchemy.com/) was originally chosen over [Infura](https://www.infura.io/) due to Infura logging IP addresses, however it has since come to public light that Alchemy *also* logs IP addresses. In the interest of decentralization, a more privacy-focused RPC provider is intended to be migrated to in the future.

After the above initial one-time-dev-machine-setup, you can compile the contracts:
```bash
npm run compile
```

### Deploying:
This repo comes with a **Hardhat deploy** script.
```bash
npm run deploy <goerli|mainnet>
```

e.g.:
```bash
npm run deploy goerli
```

### Verifying contract source code on Etherscan:
This repo comes with a **Hardhat verification** script.
```bash
npm run verify <goerli|mainnet> <`Flyweight.sol` contract address>
```

e.g.:
```bash
npm run verify goerli 0xc7A45A1d083DaB3F0b8AdfdE9Bab4f8996851Ff0
```

## Contributing
Any open source developers are welcome to contribute by opening new PRs. Please set the PR's target branch to `staging-goerli`.
