<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank Admin | Verify Account Deletion</title>
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
            text-align: center;
        }

        .card-title {
            color: #dc3545;
            font-size: 1.5rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .subtitle {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.2rem;
        }

        input[type="number"] {
            width: 100%;
            padding: 0.75rem;
            font-size: 1.2rem;
            text-align: center;
            letter-spacing: 5px;
            border: 1px solid #ced4da;
            border-radius: 5px;
        }

        .btn-submit {
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
        }
        .btn-submit:hover { background: #bd2130; }

        .btn-back {
            display: inline-block;
            margin-top: 1.2rem;
            padding: 0.6rem 1.2rem;
            background: #6c757d;
            color: #ffffff;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
            font-size: 0.9rem;
        }
        .btn-back:hover { background: #5a6268; }

        .msg-error {
            color: #dc3545;
            font-weight: 600;
            font-size: 0.95rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

    <div class="page-wrapper">
        <%@ include file="adminheader.jsp" %>

        <div class="content-area">
            <div class="card">
                <div class="card-title">⚠️ Confirm Permanent Deletion</div>
                <p class="subtitle">Enter the 6-digit OTP sent to the account holder's registered email.</p>

                <% if (request.getAttribute("msg") != null) { %>
                    <div class="msg-error"><%= request.getAttribute("msg") %></div>
                <% } %>

                <form action="processAdminDeleteAccount" method="post">
                    <div class="form-group">
                        <input type="number" name="otp" placeholder="Enter OTP" required autofocus />
                    </div>

                    <button type="submit" class="btn-submit">Verify & Delete Account</button>
                </form>

                <a href="searchaccount" class="btn-back">← Back to Search Account</a>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

</body>
</html>