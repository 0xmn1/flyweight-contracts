import { ethers } from "hardhat";

async function main() {

  console.log(1); // dm

  const flyweightFactory = await ethers.getContractFactory("Flyweight");

  console.log(2); // dm

  const flyweightContract = await flyweightFactory.deploy();

  console.log(3); // dm

  await flyweightContract.deployed();

  console.log(`Deployed to ${flyweightContract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
