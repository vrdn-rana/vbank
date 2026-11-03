<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bank.pojo.Customer, com.bank.pojo.Transaction, java.util.List"%>
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
    <title>V-Bank | Mini Statement</title>
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

        .table-card {
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            padding: 2rem;
            width: 100%;
            max-width: 850px;
        }

        .table-title {
            color: #004085;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.3rem;
            text-align: center;
        }

        .table-subtitle {
            text-align: center;
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }

        .txn-table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            overflow: hidden;
        }

        .txn-table th, .txn-table td {
            padding: 0.85rem 1rem;
            border-bottom: 1px solid #e9ecef;
            text-align: center;
            font-size: 0.9rem;
        }

        .txn-table th {
            background: #004085;
            color: #ffffff;
            font-weight: 600;
        }

        .txn-table tr:hover { background-color: #f1f3f5; }

        .badge-deposit { color: #28a745; font-weight: bold; }
        .badge-withdraw { color: #dc3545; font-weight: bold; }
        .badge-transfer { color: #0056b3; font-weight: bold; }
    </style>
</head>
<body>

    <div class="page-wrapper">
        <%@ include file="customerheader.jsp" %>

        <div class="content-area">
            <div class="table-card">
                <div class="table-title">📄 Mini Statement</div>
                <div class="table-subtitle">Showing your 5 most recent account transactions</div>

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
                        <% 
                            List<Transaction> transactions = (List<Transaction>) request.getAttribute("transactions");
                            if (transactions != null && !transactions.isEmpty()) {
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
                                <td colspan="6" style="padding: 1.5rem; color: #6c757d;">No recent transactions found.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

</body>
</html>