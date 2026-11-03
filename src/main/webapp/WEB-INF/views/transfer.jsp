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
    <title>V-Bank | Fund Transfer</title>
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
            margin-bottom: 1.2rem;
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

        .btn-transfer {
            width: 100%;
            padding: 0.75rem;
            background: #004085;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            margin-top: 0.5rem;
            transition: background 0.2s;
        }
        .btn-transfer:hover { background: #002752; }

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
            transition: background 0.2s;
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
        <%@ include file="customerheader.jsp" %>

        <div class="content-area">
            <div class="card">
                <div class="card-title">💸 Send Money</div>

                <div class="balance-info">
                    Available Balance: <strong>₹<%= String.format("%.2f", user.getBalance()) %></strong>
                </div>

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

                <!-- Step 1: Input Receiver Acc and Amount -->
                <form id="transferForm">
                    <div class="form-group">
                        <label for="receiverAccno">Receiver Account Number</label>
                        <input type="number" id="receiverAccno" name="receiverAccno" placeholder="Enter Receiver Acc No" required autofocus />
                    </div>

                    <div class="form-group">
                        <label for="amount">Transfer Amount (₹)</label>
                        <input type="number" step="0.01" id="amount" name="amount" placeholder="e.g. 500.00" required />
                    </div>

                    <button type="button" class="btn-transfer" onclick="initiateTransfer()">Send OTP & Proceed</button>
                </form>

                <!-- Step 2: Hidden OTP Form -->
                <form id="otpForm" action="processCustomerTransfer" method="post" style="display: none; margin-top: 1rem;">
                    <div class="form-group">
                        <label for="otp">Enter 6-Digit Verification OTP</label>
                        <input type="number" id="otp" name="otp" placeholder="123456" required style="text-align: center; letter-spacing: 4px;" autofocus />
                    </div>
                    <button type="submit" class="btn-verify">Confirm & Complete Transfer</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function initiateTransfer() {
            const receiverAccno = document.getElementById("receiverAccno").value;
            const amount = document.getElementById("amount").value;

            if (!receiverAccno) {
                showMsg("Please enter a receiver account number.", false);
                return;
            }

            if (!amount || amount <= 0) {
                showMsg("Please enter a valid transfer amount.", false);
                return;
            }

            const formData = new URLSearchParams();
            formData.append("receiverAccno", receiverAccno);
            formData.append("amount", amount);

            fetch('initiateCustomerTransferOtp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                if (data.status === "SUCCESS") {
                    showMsg(data.msg, true);
                    document.getElementById("receiverAccno").disabled = true;
                    document.getElementById("amount").disabled = true;
                    document.getElementById("transferForm").querySelector("button").style.display = "none";
                    document.getElementById("otpForm").style.display = "block";
                } else {
                    showMsg(data.msg, false);
                }
            })
            .catch(err => {
                showMsg("Failed to connect to transfer server.", false);
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