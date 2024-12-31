const { ethers } = require("ethers");
require("dotenv").config();

async function main() {
  const contractAddress = process.env.CONTRACT_ADDRESS;
  const abi = [
    "function addBook(string ISBN, string title, string author, string publisher, uint256 year) public",
    "function getBook(string ISBN) public view returns (string, string, string, uint256)",
    "function bookExists(string ISBN) public view returns (bool)",
  ];

  const infuraProjectId = process.env.INFURA_PROJECT_ID;
  // Updated to use Sepolia instead of Goerli
  const provider = new ethers.JsonRpcProvider(
    `https://sepolia.infura.io/v3/${infuraProjectId}`
  );

  const privateKey = process.env.PRIVATE_KEY.startsWith("0x")
    ? process.env.PRIVATE_KEY.slice(2)
    : process.env.PRIVATE_KEY;

  const signer = new ethers.Wallet(privateKey, provider);

  const contract = new ethers.Contract(contractAddress, abi, signer);

  try {
    // First, verify we can connect to the network
    const network = await provider.getNetwork();
    console.log("Connected to network:", network.name);

    const tx = await contract.addBook(
      "978-3-16-148410-0",
      "Professional Solidity",
      "Alice Developer",
      "Blockchain Press",
      2024
    );
    console.log("Đang thêm sách, transaction hash:", tx.hash);
    await tx.wait();

    const book = await contract.getBook("978-3-16-148410-0");
    console.log("Thông tin sách:", book);

    const exists = await contract.bookExists("978-3-16-148410-0");
    console.log("Sách có tồn tại không?", exists);
  } catch (error) {
    console.error("Lỗi:", error.message);
    // Additional error details if available
    if (error.error) {
      console.error("Chi tiết lỗi:", error.error);
    }
  }
}

main().catch(console.error);
