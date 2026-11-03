package com.bank.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.bank.pojo.Customer;
import com.bank.pojo.Transaction;
import com.bank.repository.CustomerRepository;
import com.bank.repository.TransactionRepository;

@Service
public class TransactionService {

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private TransactionRepository transactionRepository;

    // 1️⃣ DEPOSIT
    @Transactional
    public String deposit(Long accno, double amount) {
        if (amount <= 0) return "Invalid Amount";

        Optional<Customer> op = customerRepository.findById(accno);
        if (op.isPresent()) {
            Customer c = op.get();
            c.setBalance(c.getBalance() + amount);
            customerRepository.save(c);

            Transaction t = new Transaction(accno, accno, amount, LocalDateTime.now(), "DEPOSIT");
            transactionRepository.save(t);

            return "Deposit Successful";
        }
        return "Account Not Found";
    }

    // 2️⃣ WITHDRAW
    @Transactional
    public String withdraw(Long accno, double amount) {
        if (amount <= 0) return "Invalid Amount";

        Optional<Customer> op = customerRepository.findById(accno);
        if (op.isPresent()) {
            Customer c = op.get();
            if (c.getBalance() < amount) {
                return "Insufficient Balance";
            }
            c.setBalance(c.getBalance() - amount);
            customerRepository.save(c);

            Transaction t = new Transaction(accno, accno, amount, LocalDateTime.now(), "WITHDRAW");
            transactionRepository.save(t);

            return "Withdrawal Successful";
        }
        return "Account Not Found";
    }

    // 3️⃣ TRANSFER
    @Transactional
    public String transfer(Long senderAccno, Long receiverAccno, double amount) {
        if (amount <= 0) return "Invalid Amount";
        if (senderAccno.equals(receiverAccno)) return "Cannot Transfer To Same Account";

        Optional<Customer> senderOp = customerRepository.findById(senderAccno);
        Optional<Customer> receiverOp = customerRepository.findById(receiverAccno);

        if (senderOp.isPresent() && receiverOp.isPresent()) {
            Customer sender = senderOp.get();
            Customer receiver = receiverOp.get();

            if (sender.getBalance() < amount) {
                return "Insufficient Balance";
            }

            sender.setBalance(sender.getBalance() - amount);
            receiver.setBalance(receiver.getBalance() + amount);

            customerRepository.save(sender);
            customerRepository.save(receiver);

            Transaction t = new Transaction(senderAccno, receiverAccno, amount, LocalDateTime.now(), "TRANSFER");
            transactionRepository.save(t);

            return "Transfer Successful";
        }
        return "Invalid Account Details";
    }

    // 4️⃣ ACCOUNT STATEMENT
    public List<Transaction> getTransactionsByAccno(Long accno) {
        return transactionRepository.findBySenderAccnoOrReceiverAccnoOrderByDateTimeDesc(accno, accno);
    }

    // 5️⃣ MINI STATEMENT (Last 5)
    public List<Transaction> getTop5TransactionsByAccno(Long accno) {
        return transactionRepository.findTop5BySenderAccnoOrReceiverAccnoOrderByDateTimeDesc(accno, accno);
    }

	public List<Transaction> getAllTransactions(Long accno) {
		// TODO Auto-generated method stub
		 return transactionRepository.findAllByOrderByDateTimeDesc();
	}

	
}