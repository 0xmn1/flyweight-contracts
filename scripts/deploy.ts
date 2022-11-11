import { ethers } from "hardhat";

async function main() {
  const flyweightFactory = await ethers.getContractFactory("Flyweight");
  const flyweightContract = await flyweightFactory.deploy();
  console.log('Deploying...');
  await flyweightContract.deployed();
  console.log(`Deployed to ${flyweightContract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
