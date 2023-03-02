import { ethers } from "hardhat";

async function main() {
  let instance_token = await (await ethers.getContractFactory("TokenExample")).deploy();
  await instance_token.deployed();
  console.log(`Address Token Example Contract: ${instance_token.address}`);
  
  let instance_share_owner_sc99 = await (await ethers.getContractFactory("ShareOwnerSC99")).deploy();
  await instance_share_owner_sc99.deployed();
  console.log(`Address Share Owner Contract: ${instance_share_owner_sc99.address}`);
  
  let instance_matrix_sc99 = await (await ethers.getContractFactory("MatrixSC99"))
  .deploy(instance_token.address, "ipfs://", instance_share_owner_sc99.address);
  await instance_matrix_sc99.deployed();
  console.log(`Address Matrix Contract: ${instance_matrix_sc99.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
