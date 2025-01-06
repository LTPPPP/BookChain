const hre = require("hardhat");

async function main() {
  const BookChain = await hre.ethers.getContractFactory("BookChain");
  const bookChain = await BookChain.deploy();

  await bookChain.deployed();

  console.log("BookChain deployed to:", bookChain.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
