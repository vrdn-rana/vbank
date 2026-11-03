<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bank.pojo.Customer"%>
<%
    Customer sessionUser = (Customer) session.getAttribute("user");
    boolean isAdmin = (sessionUser != null && "ADMIN".equalsIgnoreCase(sessionUser.getRole()));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank | <%= isAdmin ? "Admin - Create Account" : "Apply for Account" %></title>
    <% if (!isAdmin) { %>
        <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <% } %>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        html, body {
            height: 100%;
            display: flex;
            flex-direction: column;
            background: #f8f9fa;
            color: #333;
        }

        .page-wrapper {
            flex: 1 0 auto;
            display: flex;
            flex-direction: column;
        }

        .content-area {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2.5rem 1.5rem;
        }

        .form-card { 
            background: #ffffff; 
            padding: 2.5rem; 
            max-width: 500px; 
            width: 100%;
            border-radius: 10px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.08); 
        }

        h2 { color: #004085; text-align: center; margin-bottom: 1.5rem; }
        .form-group { margin-bottom: 1rem; }
        label { display: block; font-weight: 600; font-size: 0.85rem; margin-bottom: 0.3rem; color: #495057; }
        input, select { width: 100%; padding: 0.65rem; border: 1px solid #ced4da; border-radius: 4px; font-size: 0.95rem; }
        .btn { width: 100%; padding: 0.75rem; background: #004085; color: #fff; border: none; border-radius: 4px; font-weight: 600; cursor: pointer; margin-top: 1rem; font-size: 1rem; }
        .btn:hover { background: #002752; }
        .msg-error { color: #dc3545; text-align: center; margin-bottom: 1rem; font-weight: 600; }
        .msg-success { color: #28a745; text-align: center; margin-bottom: 1rem; font-weight: 600; }
        .back-link { display: block; text-align: center; margin-top: 1rem; color: #6c757d; text-decoration: none; font-size: 0.85rem; }
    </style>
</head>
<body>

    <div class="page-wrapper">
       
            <%@ include file="adminheader.jsp" %>
       

        <div class="content-area">
            <div class="form-card">
                <h2>🏦 <%=  "Apply for V-Bank Account" %></h2>

                <div id="errorMsg" class="msg-error">
                    <% if (request.getAttribute("errorMsg") != null) { %>
                        <%= request.getAttribute("errorMsg") %>
                    <% } %>
                    <% if (request.getAttribute("msg") != null) { %>
                        <%= request.getAttribute("msg") %>
                    <% } %>
                </div>

                <% if (request.getAttribute("successMsg") != null) { %>
                    <div class="msg-success"><%= request.getAttribute("successMsg") %></div>
                <% } %>

                <form id="signupForm" action="adminCreateAccount" >
                    <input type="hidden" id="razorpayPaymentId" name="razorpayPaymentId" />
                    <input type="hidden" id="razorpayOrderId" name="razorpayOrderId" />

                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" id="custname" name="custname" required placeholder="John Doe" />
                    </div>

                    <div class="form-group">
                        <label>Account Type</label>
                        <select id="acctype" name="acctype" required>
                            <option value="SAVINGS">SAVINGS</option>
                            <option value="CURRENT">CURRENT</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" id="email" name="email" required placeholder="name@example.com" />
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" id="password" name="password" required placeholder="Create password" />
                    </div>

                    <div class="form-group">
                        <label>Re-Enter Password</label>
                        <input type="password" id="rePassword" required placeholder="Re-enter password" />
                    </div>

                    <div class="form-group">
                        <label>Opening Deposit Amount (₹)</label>
                        <input type="number" step="0.01" id="balance" name="balance" required placeholder="500.00" />
                    </div>

                    <div class="form-group">
                        <label>Profile Picture (dp)</label>
                        <input type="file" id="dp" name="dp" accept="image/*" />
                    </div>

                    <% if (isAdmin) { %>
                        <button type="submit" class="btn" onclick="return validateAdminForm()">Create Active Account</button>
                    <% } else { %>
                        <button type="button" class="btn" onclick="initiateRegistration()">Create Account</button>
                    <% } %>
                </form>

               
                    <a href="homeadmin" class="back-link">← Back</a>
                
            </div>
        </div>
    </div>

    <script>
        function validateAdminForm() {
            const pwd = document.getElementById("password").value;
            const rePwd = document.getElementById("rePassword").value;
            const errorDiv = document.getElementById("errorMsg");

            if (pwd !== rePwd) {
                errorDiv.innerText = "Passwords do not match!";
                return false;
            }
            return true;
        }

        <% if (!isAdmin) { %>
        function initiateRegistration() {
            const pwd = document.getElementById("password").value;
            const rePwd = document.getElementById("rePassword").value;
            const amount = document.getElementById("balance").value;
            const email = document.getElementById("email").value;
            const name = document.getElementById("custname").value;
            const errorDiv = document.getElementById("errorMsg");

            if (pwd !== rePwd) {
                errorDiv.innerText = "Passwords do not match!";
                return;
            }

            if (!amount || amount <= 0) {
                errorDiv.innerText = "Please enter a valid initial balance amount.";
                return;
            }

            fetch('createRazorpayOrder?amount=' + amount)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        errorDiv.innerText = "Transaction initialization failed.";
                        return;
                    }

                    var options = {
                        "key": data.keyId,
                        "amount": data.amount,
                        "currency": "INR",
                        "name": "V-Bank",
                        "description": "Initial Account Deposit",
                        "order_id": data.orderId,
                        "handler": function (response) {
                            document.getElementById("razorpayPaymentId").value = response.razorpay_payment_id;
                            document.getElementById("razorpayOrderId").value = response.razorpay_order_id;
                            document.getElementById("signupForm").submit();
                        },
                        "prefill": { "name": name, "email": email },
                        "theme": { "color": "#004085" }
                    };

                    var rzp1 = new Razorpay(options);
                    rzp1.on('payment.failed', function (response) {
                        errorDiv.innerText = "Transaction failed! " + response.error.description;
                    });
                    rzp1.open();
                })
                .catch(err => {
                    errorDiv.innerText = "Transaction Failure. Unable to connect to Gateway.";
                });
        }
        <% } %>
    </script>

    <%@ include file="footer.jsp" %>
</body>
</html>