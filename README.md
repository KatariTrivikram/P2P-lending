# 📜 Document-Backed P2P Lending DApp

A decentralized peer-to-peer lending platform on **Ethereum**. Lenders and borrowers transact directly through a **Solidity smart contract**, with a hash of a shared document acting as the collateral check and interest handled automatically. The app is deployed on the **Sepolia Testnet** and uses **MetaMask** for authentication.

> ✏️ Lines marked **[CONFIRM]** are placeholders. Check them against your code and edit or delete them before you commit this file.

**Contract (Sepolia):** [`0xEA7475F4eF55336bf631635dF6f37d26F236bE61`](https://sepolia.etherscan.io/address/0xEA7475F4eF55336bf631635dF6f37d26F236bE61) **[CONFIRM: network]**

---

## ✨ Features

- 🔌 **MetaMask wallet connection** that identifies the lender and the borrower by their account
- 💰 **Offer a loan**: the lender sets an interest rate and amount (in ETH) and attaches a document
- 📄 **Document-backed collateral**: a hash of the document is computed in the browser and stored on-chain; the file itself is never uploaded
- 🔁 **Full loan lifecycle**: offer → submit document → take loan → repay → reset
- 🧮 **Automated interest handling** based on the time since the loan started
- 📜 **Transaction history** modal, toast notifications, and a dark mode toggle
- 📱 **Responsive** HTML/CSS/JavaScript interface

## 🔄 How It Works

1. **Lender** connects MetaMask, enters the interest rate and loan amount, uploads a document, and calls `offerLoan`. The ETH is sent with the transaction and the document hash is stored.
2. **Borrower** connects MetaMask and submits the same document through `submitDocument`. **[CONFIRM: the contract compares the hashes]**
3. **Borrower** calls `takeLoan` to receive the funds.
4. **Borrower** calls `repayLoan` with the principal plus interest. Interest is charged per month elapsed (minimum one month):

   ```
   interest = loanAmount × interestRate × (monthsElapsed + 1) / 100
   totalDue = loanAmount + interest
   ```

5. **Lender** calls `resetLoan` so a new loan can be offered.

## 🛠️ Tech Stack

| Layer | Technologies |
|---|---|
| Smart contract | Solidity, Ethereum (Sepolia Testnet) |
| Blockchain integration | Web3.js, MetaMask |
| Frontend | HTML, CSS, JavaScript, Bootstrap 5 |
| Extras | Font Awesome, Lottie animation |

## 📑 Smart Contract Interface

Functions the frontend calls, taken from the contract ABI in `index.html`:

| Function | Type | Purpose |
|---|---|---|
| `offerLoan(interestRate, docHash)` | payable | Lender deposits the loan amount and stores the document hash |
| `submitDocument(userDocHash)` | write | Borrower submits the document hash |
| `takeLoan()` | write | Borrower takes the offered loan |
| `repayLoan()` | payable | Borrower repays the principal plus interest |
| `resetLoan()` | write | Resets the loan state for a new cycle |

State readable on-chain: `lender`, `borrower`, `loanAmount`, `interestRate`, `documentHash`, `loanStartTime`, `loanOffered`, `loanTaken`, `loanRepaid`, `docSubmitted`.

## 📁 Project Structure

```
P2P-lending/
├── index.html      # DApp frontend (HTML, CSS, JavaScript, Web3.js)
└── README.md
```

<!-- [CONFIRM] If you add the Solidity source, show it here, for example: -->
<!-- ├── contracts/LendingContract.sol -->

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

Use two MetaMask accounts, one as lender and one as borrower, and follow the steps in *How It Works*.



## 🔮 Future Improvements

- Add a network check that prompts users to switch to Sepolia
- Support multiple simultaneous loans
- Store collateral documents on IPFS and keep only the hash on-chain
- Add automated tests for the smart contract

## 👤 Author

**Trivikram Katari**

- GitHub: [KatariTrivikram](https://github.com/KatariTrivikram)
- LinkedIn: [trivikramkatari](https://www.linkedin.com/in/trivikramkatari/)
- Email: trivikramkatari@gmail.com
