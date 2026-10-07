# 📜 Document-Backed P2P Lending DApp

A decentralized peer-to-peer lending platform on **Ethereum**. A lender and a borrower transact directly through a **Solidity smart contract**: a hash of a shared document acts as the collateral check, and interest is calculated and enforced on-chain. The app is deployed on the **Sepolia Testnet** and uses **MetaMask** for authentication.

**Contract (Sepolia):** [`0xEA7475F4eF55336bf631635dF6f37d26F236bE61`](https://sepolia.etherscan.io/address/0xEA7475F4eF55336bf631635dF6f37d26F236bE61)

---

## ✨ Features

- 🔌 **MetaMask wallet connection** that identifies the lender and the borrower by their account
- 💰 **Offer a loan**: the lender sets an interest rate and amount (in ETH) and attaches a document
- 📄 **Document-backed collateral**: a hash of the document is computed in the browser and stored on-chain; the file itself is never uploaded. The borrower must present the same document, and the contract rejects any mismatch
- 🔁 **Full loan lifecycle**: offer → submit document → take loan → repay → reset
- 🧮 **Automated interest handling**: the contract calculates the amount due from the time elapsed and rejects any other repayment amount
- 📜 **Transaction history** modal, toast notifications, and a dark mode toggle
- 📱 **Responsive** HTML/CSS/JavaScript interface

## 🔄 How It Works

1. **Lender** connects MetaMask, enters the interest rate (% per month) and loan amount, uploads a document, and calls `offerLoan`. The ETH is sent with the transaction and the document hash is stored.
2. **Borrower** connects MetaMask and submits the same document through `submitDocument`. The contract checks that its hash matches the lender's, then records the caller as the borrower.
3. **Borrower** calls `takeLoan` to receive the funds, which starts the loan timer.
4. **Borrower** calls `repayLoan` with the exact amount due. Interest is charged per 30-day period elapsed (minimum one period):

   ```
   interest = loanAmount × interestRate × (monthsElapsed + 1) / 100
   totalDue = loanAmount + interest
   ```

   The payment is forwarded to the lender.
5. **Lender** calls `resetLoan` so a new loan can be offered.

## 🛠️ Tech Stack

| Layer | Technologies |
|---|---|
| Smart contract | Solidity ^0.8.0, Ethereum (Sepolia Testnet) |
| Blockchain integration | Web3.js, MetaMask |
| Frontend | HTML, CSS, JavaScript, Bootstrap 5 |
| Extras | Font Awesome, Lottie animation |

## 📑 Smart Contract

Source: [`contracts/DocumentBackedLoan.sol`](contracts/DocumentBackedLoan.sol)

| Function | Who can call | What it does |
|---|---|---|
| `offerLoan(interestRate, docHash)` | Lender only (payable) | Deposits the loan amount (must be above 0) and stores the rate and document hash; one active loan at a time |
| `submitDocument(userDocHash)` | Any account | Requires a matching document hash; the caller becomes the borrower |
| `takeLoan()` | Borrower only | Requires a submitted document; transfers the loan amount to the borrower and starts the timer |
| `repayLoan()` | Borrower only (payable) | Requires the exact total due; transfers the payment to the lender |
| `resetLoan()` | Lender only | Clears all loan state for a new cycle |

The lender is the account that deploys the contract. Public state: `lender`, `borrower`, `loanAmount`, `interestRate`, `documentHash`, `loanStartTime`, `loanOffered`, `loanTaken`, `loanRepaid`, `docSubmitted`.

## 📁 Project Structure

```
P2P-lending/
├── contracts/
│   └── DocumentBackedLoan.sol   # Solidity smart contract
├── index.html                   # DApp frontend (HTML, CSS, JavaScript, Web3.js)
└── README.md
```

## 🚀 Run Locally

**Prerequisites:** the [MetaMask](https://metamask.io/) browser extension and some Sepolia test ETH (from any Sepolia faucet).

**1. Clone the repository**

```bash
git clone https://github.com/KatariTrivikram/P2P-lending.git
cd P2P-lending
```

**2. Serve the page** (MetaMask works best from a local server, not from a `file://` link)

```bash
python -m http.server 8000
```

**3. Open the app**

Go to `http://localhost:8000`, switch MetaMask to the **Sepolia** network, and click **Connect Wallet**.

**4. Try the flow**

Use two MetaMask accounts, one as lender and one as borrower, and follow the steps in *How It Works*. The lender account must be the one that deployed the contract.

**Deploy your own copy (optional):** compile `contracts/DocumentBackedLoan.sol` in [Remix IDE](https://remix.ethereum.org/), deploy it to Sepolia with MetaMask, and replace the contract address in `index.html` with your new address.

## 📸 Screenshots

<!-- Add screenshots here, for example: -->
<!-- ![Lender panel](screenshots/lender.png) -->

## 🔮 Future Improvements

- Allow `resetLoan` only after repayment, so an active loan cannot be cleared
- Support multiple simultaneous loans
- Add a network check that prompts users to switch to Sepolia
- Store collateral documents on IPFS and keep only the hash on-chain
- Add automated tests for the smart contract

## 👤 Author

**Trivikram Katari**

- GitHub: [KatariTrivikram](https://github.com/KatariTrivikram)
- LinkedIn: [trivikramkatari](https://www.linkedin.com/in/trivikramkatari/)
- Email: trivikramkatari@gmail.com
