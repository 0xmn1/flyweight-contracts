import * as Contracts from '../typechain-types/index';

import { ethers } from 'hardhat';
import getContractConfig from './utils/getContractConfig';
import hardhat from 'hardhat';

async function deploy() {
  const flyweightFactory = await ethers.getContractFactory("Flyweight");
  const opts = getContractConfig(hardhat.hardhatArguments.network);
  console.log('using contract config:');
  console.log(opts);

  const flyweightContract = await flyweightFactory.deploy(
    opts.uniswapRouterAddress,
    opts.oracleNodeAddress,
    Object.keys(opts.tokens),
    Object.values(opts.tokens),
  );

  console.log('deploying...');
  await flyweightContract.deployed();
  console.log(`deployed to ${flyweightContract.address}`);
}

deploy().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
