package com.bank.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bank.pojo.Customer;
import com.bank.pojo.Transaction;
import com.bank.service.CustomerService;
import com.bank.service.TransactionService;
import com.bank.util.MailSender;
import com.bank.util.OtpGenerator;

import jakarta.servlet.http.HttpSession;

@Controller
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private TransactionService transactionService;
    
    @Autowired
    private OtpGenerator otpGenerator;

    @Autowired
    private MailSender mailSender;

    @GetMapping("/homecustomer")
    public String customerHome(HttpSession session, Model model) {
        Customer sessionUser = (Customer) session.getAttribute("user");
        if (sessionUser != null) {
            Customer updatedUser = customerService.searchAccountByAccNo(sessionUser.getAccno());
            session.setAttribute("user", updatedUser); // Refresh real-time balance in session
            model.addAttribute("account", updatedUser);
        }
        return "homecustomer";
    }

 // Display Customer Deposit Page
    @GetMapping("/deposit")
    public String showCustomerDepositPage(HttpSession session, Model model) {
        Customer user = (Customer) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        return "deposit";
    }

    // Process Post-Payment Account Balance Update
    @PostMapping("/processCustomerDeposit")
    public String processCustomerDeposit(@RequestParam("amount") double amount,
                                         @RequestParam("razorpayPaymentId") String paymentId,
                                         HttpSession session,
                                         Model model) {
        Customer user = (Customer) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        if (paymentId == null || paymentId.isEmpty()) {
            model.addAttribute("msg", "Transaction failed or cancelled.");
            return "deposit";
        }

        // Execute deposit logic
        String result = transactionService.deposit(user.getAccno(), amount);

        // Refresh user object in session with updated balance
        Customer updatedUser = customerService.searchAccountByAccNo(user.getAccno());
        if (updatedUser != null) {
            session.setAttribute("user", updatedUser);
        }

        model.addAttribute("msg", result);
        return "deposit";
    }
    
    
    @PostMapping("/transfer")
    public String selfTransfer(@RequestParam("receiverAccno") Long receiverAccno,
                               @RequestParam("amount") double amount,
                               HttpSession session,
                               Model model) {
        Customer user = (Customer) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        String result = transactionService.transfer(user.getAccno(), receiverAccno, amount);
        model.addAttribute("msg", result);
        return "transfer";
    }

    // 1️⃣ Display All Customer Transactions
    @GetMapping("/transactions")
    public String showCustomerTransactions(HttpSession session, Model model) {
        Customer user = (Customer) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Transaction> list = transactionService.getTransactionsByAccno(user.getAccno());
        model.addAttribute("transactions", list);
        return "transactions";
    }

    // 2️⃣ Display Mini Statement (Top 5 Transactions)
    @GetMapping("/ministatement")
    public String showMiniStatement(HttpSession session, Model model) {
        Customer user = (Customer) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Transaction> list = transactionService.getTop5TransactionsByAccno(user.getAccno());
        model.addAttribute("transactions", list);
        return "ministatement";
    }
    
 // 1️⃣ Display Transfer Page
    @GetMapping("/transfer")
    public String showTransferPage(HttpSession session) {
        Customer user = (Customer) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        return "transfer";
    }

    // 2️⃣ Validate Receiver & Balance, Send OTP via AJAX
    @PostMapping("/initiateCustomerTransferOtp")
    @ResponseBody
    public Map<String, Object> initiateCustomerTransferOtp(@RequestParam("receiverAccno") Long receiverAccno,
                                                           @RequestParam("amount") double amount,
                                                           HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Customer sender = (Customer) session.getAttribute("user");

        if (sender == null) {
            response.put("status", "ERROR");
            response.put("msg", "Session expired. Please log in again.");
            return response;
        }

        if (amount <= 0) {
            response.put("status", "ERROR");
            response.put("msg", "Please enter a valid transfer amount.");
            return response;
        }

        if (sender.getAccno().equals(receiverAccno)) {
            response.put("status", "ERROR");
            response.put("msg", "Cannot transfer money to your own account.");
            return response;
        }

        // Check Receiver Existence
        Customer receiver = customerService.searchAccountByAccNo(receiverAccno);
        if (receiver == null) {
            response.put("status", "ERROR");
            response.put("msg", "Receiver account not found.");
            return response;
        }

        // Refresh Sender Balance Check
        Customer freshSender = customerService.searchAccountByAccNo(sender.getAccno());
        if (freshSender.getBalance() < amount) {
            response.put("status", "ERROR");
            response.put("msg", "Insufficient balance.");
            return response;
        }

        // Generate & Dispatch OTP
        int transferOtp = otpGenerator.generateOtp();
        session.setAttribute("transferOtp", String.valueOf(transferOtp));
        session.setAttribute("transferReceiverAccno", receiverAccno);
        session.setAttribute("transferAmount", amount);

        mailSender.sendMail(freshSender.getEmail(), transferOtp);

        response.put("status", "SUCCESS");
        response.put("msg", "OTP sent to your registered email (" + freshSender.getEmail() + ")");
        return response;
    }

    // 3️⃣ Verify OTP & Process Money Transfer
    @PostMapping("/processCustomerTransfer")
    public String processCustomerTransfer(@RequestParam("otp") String userOtpStr,
                                           HttpSession session,
                                           Model model) {
        Customer sender = (Customer) session.getAttribute("user");
        Object sessionOtpObj = session.getAttribute("transferOtp");
        Long receiverAccno = (Long) session.getAttribute("transferReceiverAccno");
        Double amount = (Double) session.getAttribute("transferAmount");

        if (sender == null || sessionOtpObj == null || receiverAccno == null || amount == null) {
            model.addAttribute("msg", "Session expired or invalid transaction request.");
            return "transfer";
        }

        String sessionOtpStr = String.valueOf(sessionOtpObj).trim();
        String inputOtpStr = userOtpStr != null ? userOtpStr.trim() : "";

        if (sessionOtpStr.equals(inputOtpStr)) {
            String result = transactionService.transfer(sender.getAccno(), receiverAccno, amount);

            // Refresh session sender data with updated balance
            Customer updatedSender = customerService.searchAccountByAccNo(sender.getAccno());
            if (updatedSender != null) {
                session.setAttribute("user", updatedSender);
            }

            // Clean transfer session context
            session.removeAttribute("transferOtp");
            session.removeAttribute("transferReceiverAccno");
            session.removeAttribute("transferAmount");

            model.addAttribute("msg", result);
            return "transfer";
        } else {
            model.addAttribute("msg", "Transfer failed — Invalid OTP.");
            return "transfer";
        }
    }
    
  
    
    
    
    
    
    
    
}