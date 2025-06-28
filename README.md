# SimpleSwap

Ethereum SimpleSwap Smart Contract Project - Final Assignment Module III (ETH Kipu)

This project implements a smart contract named **SimpleSwap**, replicating core functionalities of Uniswap V2 for educational purposes.

## Features

- ✅ **Add Liquidity:** Users can deposit two ERC-20 tokens to the liquidity pool.
- ✅ **Remove Liquidity:** Users can withdraw tokens based on their liquidity share.
- ✅ **Swap Exact Tokens:** Swap one token for another using Uniswap's constant product formula.
- ✅ **Get Token Price:** Retrieve the price of token A in terms of token B based on current reserves.
- ✅ **Calculate Output Amount:** Calculate expected output tokens using reserves and swap fees.

The contract manages liquidity and swaps internally without requiring external Router or Factory contracts.

## Deployment Details

- **Network:** Sepolia
- **Contract Address:** [0xca3dEc0d6A6F0265C507e2790C56B257d46bd1A4](https://sepolia.etherscan.io/address/0xca3dEc0d6A6F0265C507e2790C56B257d46bd1A4#code)
- Contract verified and published on Etherscan.

## Tools Used

- Remix IDE (development and deployment)
- Etherscan (verification)
- GitHub (documentation and version control)
- MetaMask (interaction with Sepolia)
- Visual Studio Code (optional for local edits)

## Technical Overview

The **SimpleSwap** contract allows:

- Adding/removing liquidity to ERC-20 pools.
- Swapping exact tokens.
- Retrieving price quotes.
- Calculating expected output tokens.

The project uses Solidity 0.8.18 with optimizer enabled (200 runs), following ETH Kipu's assignment guidelines.

## Author

Developed by **Gerardo Fernandez** as part of the **Ethereum Developer Pack - Module III Final Project (ETH Kipu)**.

---

> This repository serves as the final deliverable for the course, demonstrating understanding of ERC-20 interactions, liquidity pools, and swap mechanics on Ethereum.
 
