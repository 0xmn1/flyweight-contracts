import getContractConfig from './utils/getContractConfig';
import hardhat from 'hardhat';

const opts = getContractConfig(hardhat.hardhatArguments.network);
export default [
  opts.uniswapRouterAddress,
  opts.oracleNodeAddress,
  Object.keys(opts.tokens),
  Object.values(opts.tokens),
];
