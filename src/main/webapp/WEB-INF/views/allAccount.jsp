<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bank.pojo.Customer, java.util.List"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank Admin | All Accounts</title>
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
            max-width: 950px;
        }

        .table-header {
            color: #004085;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.2rem;
            text-align: center;
        }

        .table-scroll-container {
            max-height: 380px;
            overflow-y: auto;
            border: 1px solid #dee2e6;
            border-radius: 6px;
        }

        .directory-table {
            width: 100%;
            border-collapse: collapse;
        }

        .directory-table th, .directory-table td {
            padding: 0.85rem 1rem;
            border-bottom: 1px solid #e9ecef;
            text-align: center;
            font-size: 0.9rem;
        }

        .directory-table th {
            position: sticky;
            top: 0;
            background: #004085;
            color: #ffffff;
            font-weight: 600;
            z-index: 10;
        }

        .directory-table tr:hover { background-color: #f1f3f5; }

        .status-active { color: #28a745; font-weight: bold; }
        .status-pending { color: #dc3545; font-weight: bold; }

        .btn-approve {
            padding: 0.45rem 0.9rem;
            background: #28a745;
            color: #ffffff;
            border: none;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-approve:hover { background: #218838; }

        .btn-block {
            padding: 0.45rem 0.9rem;
            background: #ffc107;
            color: #212529;
            border: none;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-block:hover { background: #e0a800; }
    </style>
</head>
<body>

    <div class="page-wrapper">
        <%@ include file="adminheader.jsp" %>

        <div class="content-area">
            <div class="table-card">
                <div class="table-header">📁 All Registered Accounts</div>

                <div class="table-scroll-container">
                    <table class="directory-table">
                        <thead>
                            <tr>
                                <th>Account No</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Account Type</th>
                                <th>Balance</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<Customer> accounts = (List<Customer>) request.getAttribute("accounts");
                                if (accounts != null && !accounts.isEmpty()) {
                                    for (Customer c : accounts) {
                                        boolean isActive = "ACTIVE".equalsIgnoreCase(c.getStatus());
                            %>
                                <tr>
                                    <td><strong><%= c.getAccno() %></strong></td>
                                    <td><%= c.getCustname() %></td>
                                    <td><%= c.getEmail() %></td>
                                    <td><%= c.getAcctype() %></td>
                                    <td><strong>₹<%= String.format("%.2f", c.getBalance()) %></strong></td>
                                    <td><span class="<%= isActive ? "status-active" : "status-pending" %>"><%= c.getStatus() %></span></td>
                                    <td>
                                        <% if (isActive) { %>
                                            <form action="updateAccountStatus" method="post" style="display:inline;">
                                                <input type="hidden" name="accno" value="<%= c.getAccno() %>" />
                                                <input type="hidden" name="status" value="PENDING" />
                                                <input type="hidden" name="redirectPage" value="allAccount" />
                                                <button type="submit" class="btn-block">Block</button>
                                            </form>
                                        <% } else { %>
                                            <form action="updateAccountStatus" method="post" style="display:inline;">
                                                <input type="hidden" name="accno" value="<%= c.getAccno() %>" />
                                                <input type="hidden" name="status" value="ACTIVE" />
                                                <input type="hidden" name="redirectPage" value="allAccount" />
                                                <button type="submit" class="btn-approve">Approve</button>
                                            </form>
                                        <% } %>
                                    </td>
                                </tr>
                            <%     } 
                               } else { %>
                                <tr>
                                    <td colspan="7" style="padding: 1.5rem; color: #6c757d;">No customer accounts found.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

</body>
</html>