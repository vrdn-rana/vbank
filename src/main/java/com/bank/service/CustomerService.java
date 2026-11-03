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
public class CustomerService {

    @Autowired
    private CustomerRepository customerRepository;
    
    @Autowired
    private TransactionRepository transactionRepository;
    

    public boolean createAccount(Customer customer) {
        if (customerRepository.existsByEmail(customer.getEmail())) {
            return false;
        }
        customerRepository.save(customer);
        return true;
    }

    public Customer checkAccount(String email, String password) {
        return customerRepository.findByEmailAndPassword(email, password).orElse(null);
    }

    public Customer searchAccountByAccNo(Long accno) {
        return customerRepository.findById(accno).orElse(null);
    }
    
 // 1️⃣ Fetch All Customers
    public List<Customer> getAllCustomers() {
        return customerRepository.findAll();
    }

    // 2️⃣ Fetch Customers Filtered by Status (ACTIVE / PENDING)
    public List<Customer> getCustomersByStatus(String status) {
        return customerRepository.findByStatusIgnoreCase(status);
    }

    // 3️⃣ Update Customer Account Status
    @Transactional
    public boolean updateStatus(Long accno, String newStatus) {
        Optional<Customer> custOpt = customerRepository.findById(accno);
        if (custOpt.isPresent()) {
            Customer cust = custOpt.get();
            cust.setStatus(newStatus.toUpperCase());
            customerRepository.save(cust);
            return true;
        }
        return false;
    }

    @Transactional
    public boolean updateAccount(Customer updatedCust) {
        Optional<Customer> op = customerRepository.findById(updatedCust.getAccno());
        if (op.isPresent()) {
            Customer existing = op.get();
            existing.setCustname(updatedCust.getCustname());
            existing.setAcctype(updatedCust.getAcctype());
            existing.setEmail(updatedCust.getEmail());
            customerRepository.save(existing);
            return true;
        }
        return false;
    }

    

    @Transactional
    public boolean deleteAccount(Long accno) {
        if (customerRepository.existsById(accno)) {
            customerRepository.deleteById(accno);
            return true;
        }
        return false;
    }

    public List<Customer> getAllAccounts() {
        return customerRepository.findAll();
    }

    public List<Customer> getPendingAccounts() {
        return customerRepository.findByStatus("PENDING");
    }

    public List<Customer> getBlockedAccounts() {
        return customerRepository.findByStatus("BLOCKED");
    }
    
    @Transactional
    public boolean deleteAccountAndTransferBalanceToAdmin(Long custAccno, Long adminAccno) {
        Optional<Customer> custOpt = customerRepository.findById(custAccno);
        Optional<Customer> adminOpt = customerRepository.findById(adminAccno);

        if (custOpt.isPresent() && adminOpt.isPresent()) {
            Customer cust = custOpt.get();
            Customer admin = adminOpt.get();

            double remainingBalance = cust.getBalance();
            if (remainingBalance > 0) {
                admin.setBalance(admin.getBalance() + remainingBalance);
                customerRepository.save(admin);

                // Record Transfer Transaction to Admin
                Transaction txn = new Transaction();
                txn.setSenderAccno(custAccno);
                txn.setReceiverAccno(adminAccno);
                txn.setAmount(remainingBalance);
                txn.setType("DELETION_SWEEP");
                txn.setDateTime(LocalDateTime.now());
                transactionRepository.save(txn);
            }

            // Delete customer record
            transactionRepository.deleteBySenderAccnoOrReceiverAccno(custAccno, custAccno);
            customerRepository.deleteById(custAccno);
            return true;
        }
        return false;
    }

	

	
}