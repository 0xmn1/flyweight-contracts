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
