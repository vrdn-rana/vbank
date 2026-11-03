<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank Admin | Cashier Withdraw</title>
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

        .btn-withdraw {
            width: 100%;
            padding: 0.75rem;
            background: #dc3545;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            margin-top: 0.5rem;
            transition: background 0.2s;
        }
        .btn-withdraw:hover { background: #bd2130; }

        .btn-verify {
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
        }
        .btn-verify:hover { background: #218838; }

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
                <div class="card-title">💸 Cashier Withdrawal</div>

                <div id="clientMsgBox" class="msg-box" style="display: none;"></div>

                <% 
                    String msg = (String) request.getAttribute("msg");
                    if (msg != null) { 
                        boolean isSuccess = msg.toLowerCase().contains("successful");
                %>
                    <div class="msg-box <%= isSuccess ? "msg-success" : "msg-error" %>">
                        <%= msg %>
                    </div>
                <% } %>

                <!-- Step 1: Account Number & Amount Entry Form -->
                <form id="withdrawRequestForm">
                    <div class="form-group">
                        <label for="accno">Account Number</label>
                        <input type="number" id="accno" name="accno" placeholder="Enter Account Number" required autofocus />
                    </div>

                    <div class="form-group">
                        <label for="amount">Withdrawal Amount (₹)</label>
                        <input type="number" step="0.01" id="amount" name="amount" placeholder="e.g. 500.00" required />
                    </div>

                    <button type="button" class="btn-withdraw" onclick="initiateWithdrawal()">Send Verification OTP</button>
                </form>

                <!-- Step 2: Hidden OTP Verification Form -->
                <form id="otpForm" action="processAdminWithdrawal" method="post" style="display: none; margin-top: 1rem;">
                    <div class="form-group">
                        <label for="otp">Enter 6-Digit OTP</label>
                        <input type="number" id="otp" name="otp" placeholder="123456" required style="text-align: center; letter-spacing: 4px;" />
                    </div>
                    <button type="submit" class="btn-verify">Confirm & Deduct Money</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function initiateWithdrawal() {
            const accno = document.getElementById("accno").value;
            const amount = document.getElementById("amount").value;
            const clientMsgBox = document.getElementById("clientMsgBox");

            if (!accno) {
                showMsg("Please enter an account number.", false);
                return;
            }

            if (!amount || amount <= 0) {
                showMsg("Please enter a valid amount.", false);
                return;
            }

            // AJAX Call to Validate Account, Check Balance, and Send Email OTP
            const formData = new FormData();
            formData.append("accno", accno);
            formData.append("amount", amount);

            fetch('initiateAdminWithdrawOtp', {
                method: 'POST',
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === "SUCCESS") {
                    showMsg(data.msg, true);
                    // Disable inputs and reveal OTP field
                    document.getElementById("accno").disabled = true;
                    document.getElementById("amount").disabled = true;
                    document.getElementById("withdrawRequestForm").querySelector("button").style.display = "none";
                    document.getElementById("otpForm").style.display = "block";
                } else {
                    showMsg(data.msg, false);
                }
            })
            .catch(err => {
                showMsg("Unable to process request. Try again.", false);
            });
        }

        function showMsg(text, isSuccess) {
            const msgBox = document.getElementById("clientMsgBox");
            msgBox.className = "msg-box " + (isSuccess ? "msg-success" : "msg-error");
            msgBox.innerText = text;
            msgBox.style.display = "block";
        }
    </script>

    <%@ include file="footer.jsp" %>

</body>
</html>