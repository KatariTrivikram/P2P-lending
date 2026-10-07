// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentBackedLoan {
    address payable public lender;
    address payable public borrower;
    bytes32 public documentHash;
    uint256 public interestRate; // in % per month
    uint256 public loanAmount;
    uint256 public loanStartTime;
    bool public loanOffered;
    bool public loanTaken;
    bool public loanRepaid;
    bool public docSubmitted;

    constructor() {
        lender = payable(msg.sender);
    }

    function offerLoan(uint256 _interestRate, bytes32 _docHash) public payable {
        require(msg.sender == lender, "Only lender can offer loan");
        require(!loanOffered, "Loan already offered");
        require(msg.value > 0, "Loan amount must be > 0");

        interestRate = _interestRate;
        loanAmount = msg.value;
        documentHash = _docHash;
        loanOffered = true;
    }

    function submitDocument(bytes32 _userDocHash) public {
        require(!docSubmitted, "Document already submitted");
        require(loanOffered, "Loan not offered yet");
        require(_userDocHash == documentHash, "Document mismatch");

        borrower = payable(msg.sender);
        docSubmitted = true;
    }

    function takeLoan() public {
        require(msg.sender == borrower, "Only borrower can take loan");
        require(docSubmitted, "Document not submitted");
        require(!loanTaken, "Loan already taken");

        loanTaken = true;
        loanStartTime = block.timestamp;
        borrower.transfer(loanAmount);
    }

    function repayLoan() public payable {
        require(msg.sender == borrower, "Only borrower can repay");
        require(loanTaken, "Loan not taken");
        require(!loanRepaid, "Already repaid");

        uint256 monthsElapsed = (block.timestamp - loanStartTime) / 30 days;
        uint256 totalInterest = (loanAmount * interestRate * (monthsElapsed + 1)) / 100;
        uint256 totalDue = loanAmount + totalInterest;

        require(msg.value == totalDue, "Incorrect repayment amount");

        loanRepaid = true;
        lender.transfer(msg.value);
    }

    function resetLoan() public {
        require(msg.sender == lender, "Only lender can reset");

        loanOffered = false;
        loanTaken = false;
        loanRepaid = false;
        docSubmitted = false;
        borrower = payable(address(0));
        documentHash = 0x0;
        interestRate = 0;
        loanAmount = 0;
        loanStartTime = 0;
    }
}
