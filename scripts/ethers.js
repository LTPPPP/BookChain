const { ethers } = require("ethers");
const csv = require("csv-parser");
const fs = require("fs");
const path = require("path");
require("dotenv").config();

async function main() {
  // Check environment variables
  if (!process.env.CONTRACT_ADDRESS || !process.env.PRIVATE_KEY) {
    throw new Error("Missing required environment variables");
  }

  const contractAddress = process.env.CONTRACT_ADDRESS;

  // Debug: Log artifact path and verify it exists
  const artifactPath = path.resolve(
    __dirname,
    "../artifacts/contracts/BookChain.sol/BookChain.json"
  );
  console.log("Looking for contract artifact at:", artifactPath);

  if (!fs.existsSync(artifactPath)) {
    throw new Error(
      `Contract artifact not found at ${artifactPath}. Did you run 'npx hardhat compile'?`
    );
  }

  const contractArtifact = require(artifactPath);

  // Debug: Log ABI
  const abiFunctions = contractArtifact.abi
    .filter((item) => item.type === "function")
    .map((item) => item.name);
  console.log("Contract ABI methods:", abiFunctions);

  if (!abiFunctions.includes("addBook")) {
    throw new Error("Contract ABI does not include 'addBook' method");
  }

  const abi = contractArtifact.abi;
  const provider = new ethers.JsonRpcProvider("http://127.0.0.1:8545");

  // Check network connection
  try {
    const network = await provider.getNetwork();
    console.log("Connected to network:", network.name);
  } catch (error) {
    throw new Error("Cannot connect to the network: " + error.message);
  }

  // Check contract deployment
  const contractCode = await provider.getCode(contractAddress);
  if (contractCode === "0x") {
    throw new Error("No contract found at address: " + contractAddress);
  }
  console.log("Contract found at address:", contractAddress);

  // Initialize contract
  const privateKey = process.env.PRIVATE_KEY;
  const signer = new ethers.Wallet(privateKey, provider);
  const contract = new ethers.Contract(contractAddress, abi, signer);

  // Verify contract has required method
  if (typeof contract.addBook !== "function") {
    throw new Error(
      "Contract instance does not have a callable addBook method"
    );
  }
  console.log("Contract initialized successfully with addBook method");

  // Process CSV data
  const data = [];

  // Create a function to process a single book
  async function processBook(book, contract) {
    try {
      const categories = book.Categories
        ? book.Categories.split(",").map((cat) => cat.trim())
        : [];

      const bookInput = {
        id: book.Id,
        eTag: book.eTag,
        title: book.Title,
        subtitle: book.Subtitle,
        author: book.Author,
        publisher: book.Publisher,
        publishedDate: book["Published-Date"],
        description: book.Description,
        ISBN_10: book.ISBN_10,
        ISBN_13: book.ISBN_13,
        pageCount: parseInt(book.PageCount, 10),
        categories: categories,
        language: book.Language,
        saleInfo: book.Sale_Info,
        saleability: book.Saleability,
        isEBook: book.isEBook === "True",
        epub: book.epub === "True",
        pdf: book.pdf === "True",
        accessInfo: book.Access_Info,
        viewability: book.Viewability,
        publicDomain: book.PublicDomain === "True",
      };

      console.log(`Processing book: ${book.Title}`);

      // Calculate gas cost
      const gasEstimate = await contract.estimateGas.addBook(bookInput);
      const gasPrice = await provider.getGasPrice();
      const cost = gasEstimate * gasPrice;

      console.log(
        `Estimated gas cost for adding book ${book.Title}: ${ethers.formatEther(
          cost
        )} ETH`
      );

      // Send transaction
      const tx = await contract.addBook(bookInput);
      console.log(`Book added successfully: ${book.Title}, hash: ${tx.hash}`);
      await tx.wait();
    } catch (error) {
      console.error(`Error adding book ${book.Title}:`, error.message);
      console.error("Full error:", error);
    }
  }

  return new Promise((resolve, reject) => {
    fs.createReadStream("searching.csv")
      .pipe(csv())
      .on("data", (row) => {
        data.push(row);
      })
      .on("end", async () => {
        console.log("CSV file successfully processed");
        try {
          for (const book of data) {
            await processBook(book, contract);
          }
          resolve();
        } catch (error) {
          reject(error);
        }
      })
      .on("error", reject);
  });
}

main().catch((error) => {
  console.error("Error in main:", error);
  process.exit(1);
});
