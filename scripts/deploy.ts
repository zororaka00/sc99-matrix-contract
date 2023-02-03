import { ethers } from "hardhat";

async function main() {
  let instance_busd = await (await ethers.getContractFactory("TokenExample")).deploy();
  await instance_busd.deployed();
  console.log(`Address BUSD Contract: ${instance_busd.address}`);

  let instance_shareowner = [];
  const ShareOwner = await ethers.getContractFactory("ShareOwner");
  instance_shareowner[0] = await ShareOwner.deploy();
  instance_shareowner[1] = await ShareOwner.deploy();
  instance_shareowner[2] = await ShareOwner.deploy();
  instance_shareowner[3] = await ShareOwner.deploy();
  instance_shareowner[4] = await ShareOwner.deploy();
  instance_shareowner[5] = await ShareOwner.deploy();
  instance_shareowner[6] = await ShareOwner.deploy();
  instance_shareowner[7] = await ShareOwner.deploy();
  instance_shareowner[8] = await ShareOwner.deploy();
  instance_shareowner[9] = await ShareOwner.deploy();
  instance_shareowner[10] = await ShareOwner.deploy();
  instance_shareowner[11] = await ShareOwner.deploy();
  let address_shareowner = await instance_shareowner.map((d: any) => d.address);
  console.log(`Address Share Owner Contract: ${address_shareowner}`);

  let instance_matrix = await (await ethers.getContractFactory("MatrixTest")).deploy(instance_busd.address, address_shareowner);
  await instance_matrix.deployed();
  console.log(`Address Matrix Contract: ${instance_matrix.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
