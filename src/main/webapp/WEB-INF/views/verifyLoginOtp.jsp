<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>V-Bank | OTP Verification</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f4f8; display: flex; flex-direction: column; min-height: 100vh; justify-content: center; align-items: center; }
        .card { background: #fff; padding: 2.5rem; max-width: 400px; width: 90%; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); text-align: center; }
        h2 { color: #004085; margin-bottom: 1rem; }
        p { font-size: 0.9rem; color: #6c757d; margin-bottom: 1.5rem; }
        input[type="number"] { width: 100%; padding: 0.75rem; font-size: 1.2rem; text-align: center; letter-spacing: 5px; border: 1px solid #ced4da; border-radius: 4px; margin-bottom: 1rem; }
        .btn { width: 100%; padding: 0.75rem; background: #004085; color: #fff; border: none; border-radius: 4px; font-weight: 600; cursor: pointer; }
        .btn:hover { background: #002752; }
        .msg { color: #dc3545; margin-bottom: 1rem; font-weight: 600; font-size: 0.9rem; }
    </style>
</head>
<body>

    <div class="card">
        <h2>🔑 OTP Verification</h2>
        <p>Enter the 6-digit verification code sent to your email.</p>

        <% if (request.getAttribute("msg") != null) { %>
            <div class="msg"><%= request.getAttribute("msg") %></div>
        <% } %>

        <form action="verifyLoginOtp" method="post">
            <input type="number" name="otp" required placeholder="Enter OTP" autofocus />
            <button type="submit" class="btn">Verify & Sign In</button>
        </form>
    </div>

</body>
</html>