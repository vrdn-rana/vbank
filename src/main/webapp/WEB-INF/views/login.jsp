<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank | Sign In</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f4f8; display: flex; flex-direction: column; min-height: 100vh; justify-content: center; align-items: center; }
        .login-card { background: #ffffff; padding: 2.5rem; border-radius: 10px; box-shadow: 0 6px 20px rgba(0,0,0,0.08); width: 100%; max-width: 400px; }
        .brand-header { text-align: center; color: #004085; font-size: 1.8rem; font-weight: bold; margin-bottom: 1.5rem; }
        .form-group { margin-bottom: 1.2rem; }
        label { display: block; font-size: 0.875rem; font-weight: 600; margin-bottom: 0.4rem; color: #495057; }
        input[type="email"], input[type="password"] { width: 100%; padding: 0.75rem; border: 1px solid #ced4da; border-radius: 5px; font-size: 0.95rem; }
        .btn-submit { width: 100%; padding: 0.75rem; background: #004085; color: white; border: none; border-radius: 5px; font-weight: 600; font-size: 1rem; cursor: pointer; margin-top: 0.5rem; }
        .btn-submit:hover { background: #002752; }
        .msg { text-align: center; color: #dc3545; font-weight: bold; margin-bottom: 1rem; font-size: 0.9rem; }
        .back-link { display: block; text-align: center; margin-top: 1rem; color: #6c757d; text-decoration: none; font-size: 0.875rem; }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="brand-header">🏦 V-Bank Login</div>

        <% if (request.getAttribute("msg") != null) { %>
            <div class="msg"><%= request.getAttribute("msg") %></div>
        <% } %>

        <form action="login" method="post">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="Enter your email" />
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter your password" />
            </div>

            <button type="submit" class="btn-submit">Log In</button>
        </form>

        <a href="index" class="back-link">← Back to Home</a>
    </div>
</body>
</html>