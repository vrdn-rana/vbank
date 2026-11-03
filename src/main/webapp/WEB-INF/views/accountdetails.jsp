<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bank.pojo.Customer"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>V-Bank Admin | Search Account</title>
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
            margin-bottom: 1.5rem;
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
            padding: 1.5rem 0;
        }

        .error-msg {
            color: #dc3545;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        /* Account Details Card Layout */
        .account-card {
            position: relative;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            padding: 2rem;
            width: 100%;
            max-width: 600px;
            margin-top: 1.5rem;
        }

        .card-header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 1rem;
        }

        /* Upper Left Corner DP */
        .profile-dp {
            width: 75px;
            height: 75px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #004085;
        }

        .avatar-placeholder {
            width: 75px;
            height: 75px;
            border-radius: 50%;
            background: #004085;
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: bold;
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

        /* Detail Table Styles */
        .details-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 1.5rem;
        }

        .details-table th, .details-table td {
            padding: 0.85rem 1rem;
            border-bottom: 1px solid #e9ecef;
            text-align: left;
            font-size: 0.95rem;
        }

        .details-table th {
            width: 35%;
            color: #495057;
            background: #f8f9fa;
            font-weight: 600;
        }

        /* Action Buttons */
        .action-container {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
        }

        .btn-delete {
            padding: 0.65rem 1.25rem;
            background: #dc3545;
            color: #ffffff;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-delete:hover { background: #bd2130; }

        .btn-block {
            padding: 0.65rem 1.25rem;
            background: #ffc107;
            color: #212529;
            border: none;
            border-radius: 5px;
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

            <!-- Tabular Account Details View -->
            <% 
                Customer acc = (Customer) request.getAttribute("account");
                if (acc != null) { 
                    String dpName = acc.getDp();
                    String dpPath = (dpName != null && !dpName.trim().isEmpty()) 
                                    ? request.getContextPath() + "/dp/" + dpName 
                                    : null;
                    String custName = acc.getCustname() != null ? acc.getCustname() : "User";
            %>
                <div class="account-card">
                    <!-- Header Bar: Upper Left DP & Upper Right Back Button -->
                    <div class="card-header-bar">
                        <div class="dp-wrapper">
                            <% if (dpPath != null) { %>
                                <img src="<%= dpPath %>" alt="Profile Picture" class="profile-dp" />
                            <% } else { %>
                                <div class="avatar-placeholder"><%= custName.substring(0, 1).toUpperCase() %></div>
                            <% } %>
                        </div>
                        <a href="searchaccount" class="btn-back">← Back</a>
                    </div>

                    <!-- Details Table -->
                    <table class="details-table">
                        <tr>
                            <th>Account No</th>
                            <td><strong><%= acc.getAccno() %></strong></td>
                        </tr>
                        <tr>
                            <th>Account Name</th>
                            <td><%= acc.getCustname() %></td>
                        </tr>
                        <tr>
                            <th>Account Type</th>
                            <td><%= acc.getAcctype() %></td>
                        </tr>
                        <tr>
                            <th>Email</th>
                            <td><%= acc.getEmail() %></td>
                        </tr>
                        <tr>
                            <th>Balance</th>
                            <td><strong>₹<%= String.format("%.2f", acc.getBalance()) %></strong></td>
                        </tr>
                        <tr>
                            <th>Status</th>
                            <td><span style="font-weight: bold; color: <%= "ACTIVE".equalsIgnoreCase(acc.getStatus()) ? "#28a745" : "#dc3545" %>;"><%= acc.getStatus() %></span></td>
                        </tr>
                    </table>

					<div class="action-container">
					    <form action="adminBlockAccount" method="post" style="display:inline;">
					        <input type="hidden" name="accno" value="<%= acc.getAccno() %>" />
					        <button type="submit" class="btn-block">Block Account</button>
					    </form>

					    <form action="initiateAdminDeleteOtp" method="post" style="display:inline;">
					        <input type="hidden" name="accno" value="<%= acc.getAccno() %>" />
					        <button type="submit" class="btn-delete">Delete Account</button>
					    </form>
					</div>

                </div>
            <% } %>
        </div>
    </div>
    <%@ include file="footer.jsp" %>

</body>
</html>