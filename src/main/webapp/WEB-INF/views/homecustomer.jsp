<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bank.pojo.Customer"%>
<%
    Customer user = (Customer) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    String dpName = user.getDp();
    String dpPath = (dpName != null && !dpName.trim().isEmpty()) 
                    ? request.getContextPath() + "/dp/" + dpName 
                    : null;
    String custName = user.getCustname() != null ? user.getCustname() : "Customer";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>V-Bank | Customer Dashboard</title>
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
            justify-content: center; /* Vertically center dashboard card */
            align-items: center;     /* Horizontally center dashboard card */
            padding: 2.5rem 1.5rem;
        }

        .dashboard-card {
            background: #ffffff;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 600px;
            text-align: center;
        }

        .user-avatar-wrapper {
            display: flex;
            justify-content: center;
            margin-bottom: 1.2rem;
        }

        .profile-dp {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #004085;
        }

        .avatar-placeholder {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: #004085;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: bold;
        }

        .welcome-title {
            color: #004085;
            font-size: 1.6rem;
            font-weight: 700;
            margin-bottom: 0.3rem;
        }

        .account-meta {
            color: #6c757d;
            font-size: 0.95rem;
            margin-bottom: 1.8rem;
        }

        .balance-card {
            background: #e9f5ff;
            border: 1px solid #b8daff;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .balance-label {
            font-size: 0.9rem;
            color: #004085;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .balance-amount {
            font-size: 2.2rem;
            color: #28a745;
            font-weight: 700;
            margin-top: 0.3rem;
        }

        
    </style>
</head>
<body>

    <div class="page-wrapper">
        <!-- Reusable Customer Header -->
        <%@ include file="customerheader.jsp" %>

        <!-- Centered Dashboard Card -->
        <div class="content-area">
            <div class="dashboard-card">
                <div class="user-avatar-wrapper">
                    <% if (dpPath != null) { %>
                        <img src="<%= dpPath %>" alt="Profile Picture" class="profile-dp" />
                    <% } else { %>
                        <div class="avatar-placeholder"><%= custName.substring(0, 1).toUpperCase() %></div>
                    <% } %>
                </div>

                <div class="welcome-title">Welcome, <%= custName %>!</div>
                <div class="account-meta">
                    Account No: <strong><%= user.getAccno() %></strong> | Type: <strong><%= user.getAcctype() %></strong>
                </div>

                <!-- Current Balance Display -->
                <div class="balance-card">
                    <div class="balance-label">Available Account Balance</div>
                    <div class="balance-amount">₹<%= String.format("%.2f", user.getBalance()) %></div>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

</body>
</html>