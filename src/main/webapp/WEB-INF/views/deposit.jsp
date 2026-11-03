<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bank.pojo.Customer"%>
<%
    Customer user = (Customer) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank | Deposit Funds</title>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
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
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 2.5rem 1.5rem;
        }

        .card {
            background: #ffffff;
            padding: 2.5rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 450px;
        }

        .card-title {
            color: #004085;
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            text-align: center;
            font-weight: 700;
        }

        .balance-info {
            background: #e9f5ff;
            border: 1px solid #b8daff;
            padding: 0.85rem;
            border-radius: 6px;
            margin-bottom: 1.5rem;
            text-align: center;
            font-size: 0.95rem;
            color: #004085;
        }

        .form-group {
            margin-bottom: 1.2rem;
        }

        label {
            display: block;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 0.4rem;
            color: #495057;
        }

        input[type="number"] {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 1rem;
        }

        .btn-deposit {
            width: 100%;
            padding: 0.75rem;
            background: #28a745;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            margin-top: 0.5rem;
            transition: background 0.2s;
        }
        .btn-deposit:hover { background: #218838; }

        .msg-box {
            text-align: center;
            font-weight: 600;
            margin-bottom: 1.2rem;
            padding: 0.65rem;
            border-radius: 5px;
            font-size: 0.95rem;
        }
        .msg-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .msg-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

    <div class="page-wrapper">
        <%@ include file="customerheader.jsp" %>

        <div class="content-area">
            <div class="card">
                <div class="card-title">💵 Online Self Deposit</div>

                <div class="balance-info">
                    Current Balance: <strong>₹<%= String.format("%.2f", user.getBalance()) %></strong>
                </div>

                <div id="msgBox" class="msg-box" style="display: none;"></div>

                <% 
                    String msg = (String) request.getAttribute("msg");
                    if (msg != null) { 
                        boolean isSuccess = msg.toLowerCase().contains("successful");
                %>
                    <div class="msg-box <%= isSuccess ? "msg-success" : "msg-error" %>">
                        <%= msg %>
                    </div>
                <% } %>

                <form id="depositForm" action="processCustomerDeposit" method="post">
                    <input type="hidden" id="razorpayPaymentId" name="razorpayPaymentId" />

                    <div class="form-group">
                        <label for="amount">Deposit Amount (₹)</label>
                        <input type="number" step="0.01" id="amount" name="amount" placeholder="e.g. 1000.00" required autofocus />
                    </div>

                    <button type="button" class="btn-deposit" onclick="startDepositPayment()">Pay & Deposit</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function startDepositPayment() {
            const amount = document.getElementById("amount").value;

            if (!amount || amount <= 0) {
                showMsg("Please enter a valid deposit amount.", false);
                return;
            }

            // 1. Fetch Razorpay Order
            fetch('createRazorpayOrder?amount=' + amount)
                .then(res => res.json())
                .then(data => {
                    if (data.error) {
                        showMsg("Failed to generate order ID.", false);
                        return;
                    }

                    // 2. Open Payment Gateway Modal
                    var options = {
                        "key": data.keyId,
                        "amount": data.amount,
                        "currency": "INR",
                        "name": "V-Bank",
                        "description": "Self Deposit to Acc #<%= user.getAccno() %>",
                        "order_id": data.orderId,
                        "handler": function (response) {
                            document.getElementById("razorpayPaymentId").value = response.razorpay_payment_id;
                            document.getElementById("depositForm").submit();
                        },
                        "prefill": {
                            "name": "<%= user.getCustname() %>",
                            "email": "<%= user.getEmail() %>"
                        },
                        "theme": { "color": "#004085" }
                    };

                    var rzp = new Razorpay(options);
                    rzp.on('payment.failed', function (response) {
                        showMsg("Payment failed: " + response.error.description, false);
                    });
                    rzp.open();
                })
                .catch(err => {
                    showMsg("Error initializing payment gateway.", false);
                });
        }

        function showMsg(text, isSuccess) {
            const msgBox = document.getElementById("msgBox");
            msgBox.className = "msg-box " + (isSuccess ? "msg-success" : "msg-error");
            msgBox.innerText = text;
            msgBox.style.display = "block";
        }
    </script>

    <%@ include file="footer.jsp" %>

</body>
</html>