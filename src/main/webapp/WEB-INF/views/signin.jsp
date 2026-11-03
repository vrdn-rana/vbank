<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank | Account Registration</title>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f4f8; display: flex; flex-direction: column; min-height: 100vh; }
        .form-card { background: #fff; padding: 2.5rem; max-width: 500px; margin: 2rem auto; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 90%; }
        h2 { color: #004085; text-align: center; margin-bottom: 1.5rem; }
        .form-group { margin-bottom: 1rem; }
        label { display: block; font-weight: 600; font-size: 0.85rem; margin-bottom: 0.3rem; }
        input, select { width: 100%; padding: 0.65rem; border: 1px solid #ced4da; border-radius: 4px; font-size: 0.95rem; }
        .btn { width: 100%; padding: 0.75rem; background: #004085; color: #fff; border: none; border-radius: 4px; font-weight: 600; cursor: pointer; margin-top: 1rem; }
        .btn:hover { background: #002752; }
        .msg { color: #dc3545; text-align: center; margin-bottom: 1rem; font-weight: 600; }
        .back-link { display: block; text-align: center; margin-top: 1rem; color: #6c757d; text-decoration: none; font-size: 0.85rem; }
    </style>
</head>
<body>

    <div class="form-card">
        <h2>🏦 Apply for V-Bank Account</h2>

        <div id="errorMsg" class="msg">
            <% if (request.getAttribute("msg") != null) { %>
                <%= request.getAttribute("msg") %>
            <% } %>
        </div>

        <form id="signupForm" action="savecustomer" method="post" enctype="multipart/form-data">
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
					<option value="SALARY">SALARY</option>
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
                <label>Initial Opening Balance (₹)</label>
                <input type="number" step="0.01" id="balance" name="balance" required placeholder="500.00" />
            </div>

            <div class="form-group">
                <label>Profile Picture (dp)</label>
                <input type="file" id="dp" name="dp" accept="image/*" />
            </div>

            <button type="button" class="btn" onclick="initiateRegistration()">Create Account</button>
        </form>

        <a href="index" class="back-link">← Back to Home</a>
    </div>

    <script>
        function initiateRegistration() {
            const pwd = document.getElementById("password").value;
            const rePwd = document.getElementById("rePassword").value;
            const amount = document.getElementById("balance").value;
            const email = document.getElementById("email").value;
            const name = document.getElementById("custname").value;
            const errorDiv = document.getElementById("errorMsg");

            // 1. Password Match Check
            if (pwd !== rePwd) {
                errorDiv.innerText = "Passwords do not match!";
                return;
            }

            if (!amount || amount <= 0) {
                errorDiv.innerText = "Please enter a valid initial balance amount.";
                return;
            }

            // 2. Fetch Razorpay Order from Backend
            fetch('createRazorpayOrder?amount=' + amount)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        errorDiv.innerText = "Transaction initialization failed.";
                        return;
                    }

                    // 3. Open Razorpay Checkout Modal
                    var options = {
                        "key": data.keyId,
                        "amount": data.amount,
                        "currency": "INR",
                        "name": "V-Bank",
                        "description": "Initial Account Deposit",
                        "order_id": data.orderId,
                        "handler": function (response) {
                            // Payment Success Handler
                            document.getElementById("razorpayPaymentId").value = response.razorpay_payment_id;
                            document.getElementById("razorpayOrderId").value = response.razorpay_order_id;
                            document.getElementById("signupForm").submit();
                        },
                        "prefill": {
                            "name": name,
                            "email": email
                        },
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
    </script>
</body>
</html>