# 🧱 Ethereum Staking Smart Contract

A simple staking smart contract built with Solidity and Foundry. This contract allows users to stake ETH (above a minimum USD value), records their staking details, and enables withdrawal after a minimum staking period.

---

## 📌 Features

- ✅ Stake ETH equivalent to at least **$1** (USD) using Chainlink Price Feeds
- ⏱ Enforces a **5-minute minimum lock-up time**
- 🔒 Tracks staking amount and time for each user
- 💸 Secure withdrawal of staked ETH after the staking period

---

## 🛠 Built With

- [Solidity ^0.8.18](https://soliditylang.org/)
- [Foundry](https://book.getfoundry.sh/)
- [Chainlink Price Feeds](https://docs.chain.link/data-feeds)
- [ETH](https://ethereum.org/en/)

---

## 📂 Project Structure

```bash
.
├── contracts/
│   ├── Stake.sol                # Main staking contract
│   └── PriceConverter.sol       # Library for price conversion
├── script/
│   └── Deploy.s.sol             # Deployment script
├── test/
│   └── Stake.t.sol              # Unit and integration tests
└── foundry.toml                 # Foundry config
```

---

## 🔐 How It Works

1. **Staking ETH**  
   Users stake ETH by calling `stakeFunds()` and sending at least $1 worth of ETH.

2. **Price Conversion**  
   Uses Chainlink Price Feeds to validate that the sent ETH meets the $1 minimum requirement.

3. **Lock Period**  
   A 5-minute lock-up period is enforced before users can withdraw.

4. **Withdrawal**  
   After 5 minutes, users can call `withdraw()` to retrieve their staked ETH.

---

## ✨ Example Usage

```solidity
stakeFunds{value: 0.01 ether}(); // Staking ETH
withdraw(); // After 5 minutes
```

---

## 🧪 Running Locally

### 1. Install Foundry
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2. Clone the Repo
```bash
git clone https://github.com/yourusername/eth-staking-contract.git
cd eth-staking-contract
```

### 3. Install Dependencies
```bash
forge install
```

### 4. Run Tests
```bash
forge test
```

### 5. Deploy Locally (using Anvil)
```bash
anvil
```

```bash
forge script script/Deploy.s.sol --fork-url http://127.0.0.1:8545 --broadcast --private-key YOUR_PRIVATE_KEY
```

---

## 🧠 Developer Notes

- Uses `PriceConverter` library for ETH/USD conversion.
- Uses Chainlink AggregatorV3Interface.
- You can extend this contract with reward logic, penalty for early withdrawal, or ERC20 staking.

---

## 📚 Author

**Emperor Bona**  
Solidity & Web3 Developer  
Background in Front-End Development (HTML, CSS, JS, Tailwind, React)  
Computer Science graduate from Benson Idahosa University  
Actively building Web3 projects using Solidity and Foundry 🚀

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

