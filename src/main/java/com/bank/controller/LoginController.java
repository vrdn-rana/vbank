package com.bank.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.bank.pojo.Customer;
import com.bank.service.CustomerService;
import com.bank.util.MailSender;
import com.bank.util.OtpGenerator;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    private CustomerService customerService;

    @Autowired
    private OtpGenerator otpGenerator;

    @Autowired
    private MailSender mailSender;

    @GetMapping("/")
    public String rootPage() {
        return "index";
    }

    @GetMapping("/index")
    public String indexPage() {
        return "index";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @GetMapping("/signin")
    public String openCreateAccount() {
        return "signin";
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam("email") String email,
                            @RequestParam("password") String password,
                            HttpServletRequest request,
                            Model model) {
        
        Customer cust = customerService.checkAccount(email, password);

        if (cust != null) {
            // Account Status Checks
            if ("PENDING".equalsIgnoreCase(cust.getStatus())) {
                model.addAttribute("msg", "Your account registration is pending admin approval.");
                return "login";
            }
            if ("REJECTED".equalsIgnoreCase(cust.getStatus())) {
                model.addAttribute("msg", "Your account registration request was rejected.");
                return "login";
            }
            if ("BLOCKED".equalsIgnoreCase(cust.getStatus())) {
                model.addAttribute("msg", "Your account is currently blocked. Contact support.");
                return "login";
            }

            HttpSession session = request.getSession(true);

            // Role 1: ADMIN -> Direct Dashboard Access
            if ("ADMIN".equalsIgnoreCase(cust.getRole())) {
                session.setAttribute("user", cust);
                return "homeadmin";
            } 
            // Role 2: CUSTOMER -> Send OTP and forward to verification page
            else if ("CUSTOMER".equalsIgnoreCase(cust.getRole())) {
                int loginOtp = otpGenerator.generateOtp();
                session.setAttribute("loginOtp", loginOtp);
                session.setAttribute("tempLoginUser", cust);
                
                mailSender.sendMail(cust.getEmail(), loginOtp);
                model.addAttribute("msg", "OTP sent to your registered email.");
                return "verifyLoginOtp";
            }
        }

        // Invalid Credentials -> Show message and remain on login page
        model.addAttribute("msg", "Invalid Email or Password");
        return "login";
        
    }
    
    
    @PostMapping("/verifyLoginOtp")
    public String verifyLoginOtp(@RequestParam("otp") int userOtp, HttpSession session, Model model) {
        Integer sessionOtp = (Integer) session.getAttribute("loginOtp");
        Customer tempUser = (Customer) session.getAttribute("tempLoginUser");

        // Validate OTP
        if (sessionOtp != null && sessionOtp.equals(userOtp) && tempUser != null) {
            session.setAttribute("user", tempUser);
            session.setAttribute("accno", tempUser.getAccno());
            session.removeAttribute("loginOtp");
            session.removeAttribute("tempLoginUser");
            return "redirect:/homecustomer";
        } else {
            // Incorrect OTP -> Display error message and include verifyLoginOtp page again
            model.addAttribute("msg", "Invalid OTP. Please try again.");
            return "verifyLoginOtp";
        }
    }
    @Value("${razorpay.key.id}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret}")
    private String razorpayKeySecret;

    // 1️⃣ Create Order Endpoint for Razorpay
    @GetMapping("/createRazorpayOrder")
    @ResponseBody
    public Map<String, Object> createRazorpayOrder(@RequestParam("amount") double amount) {
        Map<String, Object> response = new HashMap<>();
        try {
            RazorpayClient client = new RazorpayClient(razorpayKeyId, razorpayKeySecret);
            
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", (int) (amount * 100)); // Amount in paise
            orderRequest.put("currency", "INR");
            orderRequest.put("receipt", "txn_" + System.currentTimeMillis());

            Order order = client.orders.create(orderRequest);

            response.put("orderId", order.get("id"));
            response.put("keyId", razorpayKeyId);
            response.put("amount", order.get("amount"));
            return response;
        } catch (Exception e) {
            e.printStackTrace();
            response.put("error", "Failed to create order");
            return response;
        }
    }

    // 2️⃣ Save Registration with Initial Deposit & Pending Status
    @PostMapping("/savecustomer")
    public String savecustomer(@RequestParam("custname") String custname,
                               @RequestParam("acctype") String acctype,
                               @RequestParam("email") String email,
                               @RequestParam("password") String password,
                               @RequestParam("balance") double balance,
                               @RequestParam("dp") MultipartFile file,
                               @RequestParam("razorpayPaymentId") String paymentId,
                               Model model) throws Exception {

        // Verify Payment ID Presence
        if (paymentId == null || paymentId.isEmpty()) {
            model.addAttribute("msg", "Transaction failure! Initial deposit was not processed.");
            return "createaccount";
        }

        Customer cust = new Customer();
        cust.setCustname(custname);
        cust.setAcctype(acctype);
        cust.setEmail(email);
        cust.setPassword(password);
        cust.setBalance(balance);
        cust.setRole("CUSTOMER");
        cust.setStatus("PENDING");

        // Dynamic DP Profile Upload
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
            model.addAttribute("msg", "Account registered wait for Admin approval");
            return "login";
        } else {
            model.addAttribute("msg", "Email already registered!");
            return "signin";
        }
    }

    @PostMapping("/verifyRegOtp")
    public String verifyRegOtp(@RequestParam("otp") int userOtp, HttpSession session, Model model) {
        Integer sessionOtp = (Integer) session.getAttribute("regOtp");
        Customer tempCust = (Customer) session.getAttribute("tempCustomer");

        if (sessionOtp != null && sessionOtp.equals(userOtp) && tempCust != null) {
            boolean success = customerService.createAccount(tempCust);
            session.removeAttribute("regOtp");
            session.removeAttribute("tempCustomer");

            if (success) {
                model.addAttribute("msg", "Registration successful! Pending admin approval.");
                return "login";
            } else {
                model.addAttribute("msg", "Email already registered!");
                return "createaccount";
            }
        } else {
            model.addAttribute("msg", "Invalid OTP. Verification failed.");
            return "verotp";
        }
    }

    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/index";
    }
}