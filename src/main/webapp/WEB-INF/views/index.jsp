<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>V-Bank | Welcome</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f4f8; color: #333; display: flex; flex-direction: column; min-height: 100vh; justify-content: center; align-items: center; }
        .hero-card { background: #ffffff; padding: 3rem 2.5rem; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); text-align: center; max-width: 420px; width: 90%; }
        .brand-title { font-size: 2.5rem; color: #004085; font-weight: 700; margin-bottom: 0.5rem; letter-spacing: 1px; }
        .brand-tagline { font-size: 0.95rem; color: #6c757d; margin-bottom: 2rem; }
        .btn-group { display: flex; flex-direction: column; gap: 1rem; }
        .btn { display: block; padding: 0.85rem; border-radius: 6px; font-size: 1rem; font-weight: 600; text-decoration: none; transition: all 0.2s ease; cursor: pointer; border: none; }
        .btn-primary { background: #004085; color: #ffffff; }
        .btn-primary:hover { background: #002752; }
        .btn-outline { background: transparent; color: #004085; border: 2px solid #004085; }
        .btn-outline:hover { background: #e7f1ff; }
        .msg { margin-bottom: 1rem; color: #d9534f; font-weight: bold; font-size: 0.9rem; }
    </style>
</head>
<body>

    <div class="hero-card">
        <h1 class="brand-title">🏦 V-Bank</h1>
        <p class="brand-tagline">Secure & Modern Digital Banking Solution</p>

        <% if (request.getAttribute("msg") != null) { %>
            <div class="msg"><%= request.getAttribute("msg") %></div>
        <% } %>

        <div class="btn-group">
            <a href="login" class="btn btn-primary">Login</a>
            <a href="signin" class="btn btn-outline">Sign Up</a>
        </div>
    </div>

</body>
</html>