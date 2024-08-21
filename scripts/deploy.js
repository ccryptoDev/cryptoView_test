const { ethers, upgrades } = require("hardhat");

async function main() {
  const contractInstance = await ethers.getContractFactory("SimpleNFT");
  const contract = await contractInstance.deploy();
  console.log("SimpleNFT Contract is deployed to:", contract.address);
}

main();
