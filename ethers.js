const { ethers } = require("ethers");

async function main() {
  const contractAddress = "address";
  const abi = [
    "function addBook(string ISBN, string title, string author, string publisher, uint256 year) public",
    "function getBook(string ISBN) public view returns (string, string, string, uint256)",
    "function bookExists(string ISBN) public view returns (bool)",
  ];

  const provider = new ethers.providers.JsonRpcProvider(
    "https://rpc.testnet.url"
  );
  const signer = provider.getSigner("0xYourWalletAddress");
  const contract = new ethers.Contract(contractAddress, abi, signer);

  // Thêm sách mới
  await contract.addBook(
    "978-3-16-148410-0",
    "Professional Solidity",
    "Alice Developer",
    "Blockchain Press",
    2024
  );

  // Lấy thông tin sách
  const book = await contract.getBook("978-3-16-148410-0");
  console.log("Thông tin sách:", book);

  // Kiểm tra sách tồn tại
  const exists = await contract.bookExists("978-3-16-148410-0");
  console.log("Sách có tồn tại không?", exists);
}

main().catch(console.error);
