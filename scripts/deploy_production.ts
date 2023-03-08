import { ethers, upgrades } from "hardhat";

async function main() {
  let instance_share_owner_sc99 = await (await ethers.getContractFactory("ShareOwnerSC99")).deploy();
  await instance_share_owner_sc99.deployed();
  console.log(`Address Share Owner Contract: ${instance_share_owner_sc99.address}`);
  
  let instance_matrix_sc99 = await (await ethers.getContractFactory("MatrixSC99"))
  .deploy("0x7f5c764cbc14f9669b88837ca1490cca17c31607", "ipfs://", instance_share_owner_sc99.address);
  await instance_matrix_sc99.deployed();
  console.log(`Address Matrix Contract: ${instance_matrix_sc99.address}`);
  
  let instance_swap_sc99 = await (await ethers.getContractFactory("SwapSC99"))
  .deploy("0x4200000000000000000000000000000000000006", "0xe592427a0aece92de3edee1f18e0157c05861564");
  await instance_swap_sc99.deployed();
  console.log(`Address Swap Contract: ${instance_swap_sc99.address}`);
  
  let instance_nft_reward_sc99 = await (await ethers.getContractFactory("NFTRewardSC99"))
  .deploy("0x7f5c764cbc14f9669b88837ca1490cca17c31607", "0xB598c2Ca6323aE388A260E215817fE49d80916a6");
  await instance_nft_reward_sc99.deployed();
  console.log(`Address Swap Contract: ${instance_nft_reward_sc99.address}`);

  let instance_reward_sc99 = await upgrades.deployProxy((await ethers.getContractFactory("RewardSC99")),
  ["0x7f5c764cbc14f9669b88837ca1490cca17c31607", "0xc45376BE05153316b01E06FC3e341feF51283322"], { kind: 'uups' });
  await instance_reward_sc99.deployed();
  console.log(`Address Swap Contract: ${instance_reward_sc99.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
