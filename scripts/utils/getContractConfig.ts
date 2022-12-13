import configs from '../resources/contract-network-configs.json';

type DeployParams = {
  readonly uniswapRouterAddress: string,
  readonly oracleNodeAddress: string,
  readonly tokens: {[key: string]: string},
}

const getContractConfig = (networkId: string | undefined) => {
  if (networkId === undefined) {
    throw 'please specify a network to deploy to';
  }

  const configsTyped: {[key: string]: DeployParams} = configs;
  const config = configsTyped[networkId];
  if (!config) {
    throw `unrecognized network id: ${networkId}`;
  }

  return config;
};

export default getContractConfig;
