package com.bank.controller;

import java.io.File;
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
import org.springframework.web.multipart.MultipartFile;

import com.bank.pojo.Customer;
import com.bank.pojo.Transaction;
import com.bank.service.CustomerService;
import com.bank.service.TransactionService;
import com.bank.util.MailSender;
import com.bank.util.OtpGenerator;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private TransactionService transactionService;
    
    @Autowired
    private OtpGenerator otpGenerator;

    @Autowired
    private MailSender mailSender;


    @GetMapping("/homeadmin")
    public String adminHome() {
        return "homeadmin";
    }

    // Account Search
    @GetMapping("/searchaccount")
    public String searchAccountPage() {
        return "searchaccount";
    }
    
   
    
    @GetMapping("/createaccount")
    public String createAccountPage() {
        return "createaccount";
    }
    
    @GetMapping("/admindeposit")
    public String admindepositPage() {
        return "admindeposit";
    }
    

    @PostMapping("/searchaccount")
    public String performSearch(@RequestParam("accno") Long accno, Model model) {
        Customer cust = customerService.searchAccountByAccNo(accno);
        if (cust != null) {
            model.addAttribute("account", cust);
            return "accountdetails";
        } else {
            model.addAttribute("msg", "No account found");
        }
        return "searchaccount";
    }

    @GetMapping("/adminwithdraw")
    public String adminWithdrawPage() {
        return "adminwithdraw";
    }

    @PostMapping("/adminwithdraw")
    public String processAdminWithdraw(@RequestParam("accno") Long accno,
                                      @RequestParam("amount") double amount,
                                      Model model) {
        String msg = transactionService.withdraw(accno, amount);
        model.addAttribute("msg", msg);
        return "adminwithdraw";
    }

    @GetMapping("/allAccount")
    public String showAllAccounts(Model model) {
        List<Customer> list = customerService.getAllCustomers();
        model.addAttribute("accounts", list);
        model.addAttribute("pageTitle", "📁 All Customer Accounts");
        model.addAttribute("currentTab", "allAccount");
        return "allAccount";
    }

    // 2️⃣ Active Accounts Directory
    @GetMapping("/active")
    public String showActiveAccounts(Model model) {
        List<Customer> list = customerService.getCustomersByStatus("ACTIVE");
        model.addAttribute("accounts", list);
        model.addAttribute("pageTitle", "✅ Active Customer Accounts");
        model.addAttribute("currentTab", "active");
        return "active";
    }

    // 3️⃣ Pending Accounts Directory
    @GetMapping("/pending")
    public String showPendingAccounts(Model model) {
        List<Customer> list = customerService.getCustomersByStatus("PENDING");
        model.addAttribute("accounts", list);
        model.addAttribute("pageTitle", "⏳ Pending Account Approvals");
        model.addAttribute("currentTab", "pending");
        return "pending";
    }

    // 4️⃣ Action Status Toggle Handler
    @PostMapping("/updateAccountStatus")
    public String updateAccountStatus(@RequestParam("accno") Long accno,
                                      @RequestParam("status") String status,
                                      @RequestParam("redirectPage") String redirectPage) {
        customerService.updateStatus(accno, status);
        return "redirect:/" + redirectPage;
    }

    // Block Account Handler (Sets status to PENDING)
    @PostMapping("/adminBlockAccount")
    public String blockAccount(@RequestParam("accno") Long accno, Model model) {
        boolean updated = customerService.updateStatus(accno, "PENDING");
        if (updated) {
            model.addAttribute("msg", "Account #" + accno + " has been blocked (Status set to PENDING).");
        } else {
            model.addAttribute("msg", "Failed to update account status.");
        }
        return "searchaccount";
    }

 // 1️⃣ Initiate Deletion OTP & Redirect to verifyDeleteOtp.jsp
    @PostMapping("/initiateAdminDeleteOtp")
    public String initiateAdminDeleteOtp(@RequestParam("accno") Long accno, HttpSession session, Model model) {
        Customer cust = customerService.searchAccountByAccNo(accno);

        if (cust == null) {
            model.addAttribute("msg", "Account not found");
            return "searchaccount";
        }

        int generatedOtp = otpGenerator.generateOtp();
        
        // Save as String to eliminate Integer vs String mismatch during session retrieval
        session.setAttribute("deleteOtp", String.valueOf(generatedOtp));
        session.setAttribute("deleteAccNo", accno);

        mailSender.sendMail(cust.getEmail(), generatedOtp);
        return "verifyDeleteOtp";
    }

    @PostMapping("/processAdminDeleteAccount")
    public String processAdminDeleteAccount(@RequestParam("otp") String userOtpStr, 
                                             HttpSession session, 
                                             Model model) {
        Object sessionOtpObj = session.getAttribute("deleteOtp");
        Long accno = (Long) session.getAttribute("deleteAccNo");
        Customer admin = (Customer) session.getAttribute("user");

        // Debugging verification
        if (sessionOtpObj == null || accno == null) {
            model.addAttribute("msg", "Session expired. Please search account and try again.");
            return "searchaccount";
        }

        String sessionOtpStr = String.valueOf(sessionOtpObj).trim();
        String inputOtpStr = userOtpStr != null ? userOtpStr.trim() : "";

        // 1. Strict OTP String Comparison
        if (sessionOtpStr.equals(inputOtpStr)) {

            // Fallback for Admin Account Number if session admin is null
            Long adminAccNo = (admin != null) ? admin.getAccno() : 1L; // default admin accno

            // 2. Execute Balance Sweep and Account Deletion
            boolean success = customerService.deleteAccountAndTransferBalanceToAdmin(accno, adminAccNo);

            // Clear deletion session data
            session.removeAttribute("deleteOtp");
            session.removeAttribute("deleteAccNo");

            if (success) {
                model.addAttribute("msg", "Account #" + accno + " deleted successfully. Remaining balance transferred to Admin.");
                return "searchaccount";
            } else {
                model.addAttribute("msg", "Failed to delete account. Try again.");
                return "searchaccount";
            }
        } else {
            // Invalid OTP -> Remain on verifyDeleteOtp page
            model.addAttribute("msg", "Invalid OTP. Please try again.");
            return "verifyDeleteOtp";
        }
    }
    
    
    @GetMapping("/adminCreateAccount")
    public String adminCreateAccount(@RequestParam("custname") String custname,
                                     @RequestParam("acctype") String acctype,
                                     @RequestParam("email") String email,
                                     @RequestParam("password") String password,
                                     @RequestParam("balance") double balance,
                                     @RequestParam(value = "dp", required = false) MultipartFile file,
                                     Model model) throws Exception {

        Customer cust = new Customer();
        cust.setCustname(custname);
        cust.setAcctype(acctype);
        cust.setEmail(email);
        cust.setPassword(password);
        cust.setBalance(balance);
        cust.setRole("CUSTOMER");
        cust.setStatus("ACTIVE");
        // Handle Profile Picture (DP) Upload
        if (file != null && !file.isEmpty()) {
            cust.setDp(file.getOriginalFilename());
            String uploadDir = System.getProperty("user.dir") + File.separator + "src" 
                               + File.separator + "main" + File.separator + "resources" 
                               + File.separator + "static" + File.separator + "dp" + File.separator;

            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            file.transferTo(new File(uploadDir + file.getOriginalFilename()));
        }

        boolean success = customerService.createAccount(cust);

        if (success) {
            model.addAttribute("successMsg", "Account created successfully with ACTIVE status!");
        } else {
            model.addAttribute("errorMsg", "Email address is already registered!");
        }
        return "createaccount";
    }
    
    // Display Transaction History Search Page
    @GetMapping("/adminTransactions")
    public String adminTransactionsPage() {
        return "admintransactions";
    }
    
    @GetMapping("/accounttransactions")
    public String accounttransactionsPage() {
        return "accounttransactions";
    }

    // Perform Account Search & Fetch Scrollable Transactions
    @PostMapping("/adminTransactions")
    public String searchAdminTransactions(@RequestParam("accno") Long accno, Model model) {
        Customer cust = customerService.searchAccountByAccNo(accno);
        if (cust != null) {
            List<Transaction> list = transactionService.getAllTransactions(accno);
            model.addAttribute("account", cust);
            model.addAttribute("transactions", list);
            return "accounttransactions";
        } else {
            model.addAttribute("msg", "No account found");
        }
        return "admintransactions";
    }
    
    // 1️⃣ Validate Receiver Account Endpoint
    @GetMapping("/checkAccountExists")
    @ResponseBody
    public Map<String, Object> checkAccountExists(@RequestParam("accno") Long accno) {
        Map<String, Object> res = new HashMap<>();
        Customer cust = customerService.searchAccountByAccNo(accno);
        if (cust != null) {
            res.put("exists", true);
            res.put("name", cust.getCustname());
        } else {
            res.put("exists", false);
        }
        return res;
    }

    // 2️⃣ Handle Post-Payment Admin Deposit
    @PostMapping("/processAdminDeposit")
    public String processAdminDeposit(@RequestParam("accno") Long accno,
                                     @RequestParam("amount") double amount,
                                     @RequestParam("razorpayPaymentId") String paymentId,
                                     Model model) {
        if (paymentId == null || paymentId.isEmpty()) {
            model.addAttribute("msg", "Transaction failure! Deposit was not processed.");
            return "admindeposit";
        }

        String result = transactionService.deposit(accno, amount);
        model.addAttribute("msg", result);
        return "admindeposit";
    }
    
    
    // 1️⃣ Validate Account, Check Balance & Send OTP
    @PostMapping("/initiateAdminWithdrawOtp")
    @ResponseBody
    public Map<String, Object> initiateAdminWithdrawOtp(@RequestParam("accno") Long accno,
                                                        @RequestParam("amount") double amount,
                                                        HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        if (amount <= 0) {
            response.put("status", "ERROR");
            response.put("msg", "Please enter a valid amount.");
            return response;
        }

        Customer cust = customerService.searchAccountByAccNo(accno);

        // 1. Account Existence Check
        if (cust == null) {
            response.put("status", "ERROR");
            response.put("msg", "Account not found");
            return response;
        }

        // 2. Balance Validation Check
        if (cust.getBalance() < amount) {
            response.put("status", "ERROR");
            response.put("msg", "Insufficient balance");
            return response;
        }

        // 3. Generate and Send OTP to Customer's Registered Email
        int withdrawOtp = otpGenerator.generateOtp();
        session.setAttribute("withdrawOtp", withdrawOtp);
        session.setAttribute("withdrawAccNo", accno);
        session.setAttribute("withdrawAmount", amount);

        mailSender.sendMail(cust.getEmail(), withdrawOtp);

        response.put("status", "SUCCESS");
        response.put("msg", "OTP sent to customer's registered email (" + cust.getEmail() + ")");
        return response;
    }

    // 2️⃣ Verify OTP and Process Money Deduction
    @PostMapping("/processAdminWithdrawal")
    public String processAdminWithdrawal(@RequestParam("otp") int userOtp,
                                        HttpSession session,
                                        Model model) {

        Integer sessionOtp = (Integer) session.getAttribute("withdrawOtp");
        Long accno = (Long) session.getAttribute("withdrawAccNo");
        Double amount = (Double) session.getAttribute("withdrawAmount");

        // 4. Validate OTP Matching
        if (sessionOtp != null && sessionOtp.equals(userOtp) && accno != null && amount != null) {
            String result = transactionService.withdraw(accno, amount);
            
            // Clean up session attributes
            session.removeAttribute("withdrawOtp");
            session.removeAttribute("withdrawAccNo");
            session.removeAttribute("withdrawAmount");

            model.addAttribute("msg", result);
            return "adminwithdraw";
        } else {
            model.addAttribute("msg", "Transaction failed - Invalid OTP");
            return "adminwithdraw";
        }
    }
    
    
 // 1️⃣ All Accounts Directory
    
    
    
    
    
}





















