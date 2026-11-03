<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank Admin | Cashier Deposit</title>
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

        /* Centered Content Area */
        .content-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center; /* Vertically center card */
            align-items: center;     /* Horizontally center card */
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
        <%@ include file="adminheader.jsp" %>

        <div class="content-area">
            <div class="card">
                <div class="card-title">💵 Cashier Deposit</div>

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

                <form id="depositForm" action="processAdminDeposit" method="post">
                    <input type="hidden" id="razorpayPaymentId" name="razorpayPaymentId" />

                    <div class="form-group">
                        <label for="accno">Receiver Account Number</label>
                        <input type="number" id="accno" name="accno" placeholder="Enter Receiver Acc No" required autofocus />
                    </div>

                    <div class="form-group">
                        <label for="amount">Deposit Amount (₹)</label>
                        <input type="number" step="0.01" id="amount" name="amount" placeholder="e.g. 1000.00" required />
                    </div>

                    <button type="button" class="btn-deposit" onclick="initiateAdminDeposit()">Process Deposit</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function initiateAdminDeposit() {
            const accno = document.getElementById("accno").value;
            const amount = document.getElementById("amount").value;
            const msgBox = document.getElementById("msgBox");

            if (!accno) {
                showError("Please enter a receiver account number.");
                return;
            }

            if (!amount || amount <= 0) {
                showError("Please enter a valid deposit amount.");
                return;
            }

            // 1. Verify if Receiver Account Exists
            fetch('checkAccountExists?accno=' + accno)
                .then(res => res.json())
                .then(data => {
                    if (!data.exists) {
                        showError("Account not found");
                        return;
                    }

                    // 2. Account Exists -> Create Razorpay Order
                    return fetch('createRazorpayOrder?amount=' + amount)
                        .then(res => res.json())
                        .then(orderData => {
                            if (orderData.error) {
                                showError("Transaction initialization failed.");
                                return;
                            }

                            // 3. Launch Razorpay Gateway Modal
                            var options = {
                                "key": orderData.keyId,
                                "amount": orderData.amount,
                                "currency": "INR",
                                "name": "V-Bank",
                                "description": "Cash Deposit to Acc #" + accno,
                                "order_id": orderData.orderId,
                                "handler": function (response) {
                                    document.getElementById("razorpayPaymentId").value = response.razorpay_payment_id;
                                    document.getElementById("depositForm").submit();
                                },
                                "prefill": {
                                    "name": data.name || "Customer"
                                },
                                "theme": { "color": "#004085" }
                            };

                            var rzp = new Razorpay(options);
                            rzp.on('payment.failed', function (response) {
                                showError("Transaction failure! " + response.error.description);
                            });
                            rzp.open();
                        });
                })
                .catch(err => {
                    showError("Unable to verify account details.");
                });
        }

        function showError(msg) {
            const msgBox = document.getElementById("msgBox");
            msgBox.className = "msg-box msg-error";
            msgBox.innerText = msg;
            msgBox.style.display = "block";
        }
    </script>

    <%@ include file="footer.jsp" %>

</body>
</html>