<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bank.pojo.Customer, com.bank.pojo.Transaction, java.util.List"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank Admin | Transaction History Search</title>
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

        .search-card {
            background: #ffffff;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 550px;
        }

        .form-title {
            color: #004085;
            font-size: 1.4rem;
            margin-bottom: 1.2rem;
            text-align: center;
        }

        .search-form {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .search-input {
            flex: 1;
            padding: 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 5px;
            font-size: 1rem;
        }

        .btn-search {
            padding: 0.75rem 1.5rem;
            background: #004085;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-search:hover { background: #002752; }

        .not-found-container {
            text-align: center;
            padding: 1rem 0;
        }

        .error-msg {
            color: #dc3545;
            font-size: 1.1rem;
            font-weight: 600;
        }

        /* Account & Scrollable Transactions Card Layout */
        .account-card {
            position: relative;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            padding: 2rem;
            width: 100%;
            max-width: 850px;
            margin-top: 1.5rem;
        }

        .card-header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.2rem;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 1rem;
        }

        .user-info-header {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        /* Upper Left Corner DP */
        .profile-dp {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #004085;
        }

        .avatar-placeholder {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #004085;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            font-weight: bold;
        }

        .header-title-text {
            color: #004085;
            font-weight: 700;
            font-size: 1.2rem;
        }

        /* Upper Right Corner Back Button */
        .btn-back {
            display: inline-block;
            padding: 0.5rem 1.2rem;
            background: #6c757d;
            color: #ffffff;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: background 0.2s;
        }
        .btn-back:hover { background: #5a6268; }

        /* Scrollable Transactions Window */
        .table-scroll-container {
            max-height: 350px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 6px;
        }

        .txn-table {
            width: 100%;
            border-collapse: collapse;
        }

        .txn-table th, .txn-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e9ecef;
            text-align: center;
            font-size: 0.9rem;
        }

        .txn-table th {
            position: sticky;
            top: 0;
            background: #004085;
            color: #ffffff;
            font-weight: 600;
            z-index: 10;
        }

        .txn-table tr:hover {
            background-color: #f1f3f5;
        }

        .badge-deposit { color: #28a745; font-weight: bold; }
        .badge-withdraw { color: #dc3545; font-weight: bold; }
        .badge-transfer { color: #0056b3; font-weight: bold; }
    </style>
</head>
<body>

    <div class="page-wrapper">
        <%@ include file="adminheader.jsp" %>

        <div class="content-area">
            <!-- Search Form Card -->
            <div class="search-card">
                <div class="form-title">📜 Search Transaction History</div>
                <% if (request.getAttribute("msg") != null) { %>
                    <div class="not-found-container">
                        <div class="error-msg"><%= request.getAttribute("msg") %></div>
                    </div>
                <% } %>
                <form action="adminTransactions" method="post" class="search-form">
                    <input type="number" name="accno" class="search-input" placeholder="Enter Account Number" required autofocus />
                    <button type="submit" class="btn-search">Search</button>
                </form>
            </div>

            <!-- Scrollable Transaction Results View -->
            <% 
                Customer acc = (Customer) request.getAttribute("account");
                List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
                
                if (acc != null) { 
                    String dpName = acc.getDp();
                    String dpPath = (dpName != null && !dpName.trim().isEmpty()) 
                                    ? request.getContextPath() + "/dp/" + dpName 
                                    : null;
                    String custName = acc.getCustname() != null ? acc.getCustname() : "User";
            %>
                <div class="account-card">
                    <!-- Header Bar: Upper Left DP & Details, Upper Right Back Button -->
                    <div class="card-header-bar">
                        <div class="user-info-header">
                            <div class="dp-wrapper">
                                <% if (dpPath != null) { %>
                                    <img src="<%= dpPath %>" alt="Profile Picture" class="profile-dp" />
                                <% } else { %>
                                    <div class="avatar-placeholder"><%= custName.substring(0, 1).toUpperCase() %></div>
                                <% } %>
                            </div>
                            <div>
                                <div class="header-title-text"><%= custName %></div>
                                <div style="font-size: 0.9rem; color: #6c757d;">Acc No: <strong><%= acc.getAccno() %></strong> | Type: <strong><%= acc.getAcctype() %></strong></div>
                            </div>
                        </div>
                        <a href="adminTransactions" class="btn-back">← Back</a>
                    </div>

                    <!-- Scrollable Window Panel for All Transactions -->
                    <div class="table-scroll-container">
                        <table class="txn-table">
                            <thead>
                                <tr>
                                    <th>Txn ID</th>
                                    <th>Sender Acc</th>
                                    <th>Receiver Acc</th>
                                    <th>Amount</th>
                                    <th>Type</th>
                                    <th>Date & Time</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (transactions != null && !transactions.isEmpty()) { 
                                       for (Transaction t : transactions) { 
                                           String typeClass = "badge-transfer";
                                           if ("DEPOSIT".equalsIgnoreCase(t.getType())) typeClass = "badge-deposit";
                                           else if ("WITHDRAW".equalsIgnoreCase(t.getType())) typeClass = "badge-withdraw";
                                %>
                                    <tr>
                                        <td>#<%= t.getTransactionId() %></td>
                                        <td><%= t.getSenderAccno() %></td>
                                        <td><%= t.getReceiverAccno() %></td>
                                        <td><strong>₹<%= String.format("%.2f", t.getAmount()) %></strong></td>
                                        <td><span class="<%= typeClass %>"><%= t.getType() %></span></td>
                                        <td><%= t.getDateTime() %></td>
                                    </tr>
                                <%     } 
                                   } else { %>
                                    <tr>
                                        <td colspan="6" style="padding: 1.5rem; color: #6c757d;">No transactions recorded for this account.</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

</body>
</html>