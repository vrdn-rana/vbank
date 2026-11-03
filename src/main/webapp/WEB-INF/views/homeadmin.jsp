<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>V-Bank | Admin Console</title>
    <style>
        * { 
            box-sizing: border-box; 
            margin: 0; 
            padding: 0; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        
        /* 1. Force full viewport height layout */
        html, body {
            height: 100%;
            display: flex;
            flex-direction: column;
            background: #f8f9fa;
            color: #333;
        }

        /* 2. Main content takes all remaining vertical space */
        .page-wrapper {
            flex: 1 0 auto;
            display: flex;
            flex-direction: column;
        }
        
		.navbar { 
		    background: #004085; 
		    display: flex; 
		    justify-content: space-between; 
		    align-items: center; 
		    padding: 0 2rem; 
		    height: 65px; 
		    box-shadow: 0 2px 10px rgba(0,0,0,0.15); 
		}
		.navbar-brand { 
		    color: #ffffff; 
		    font-size: 1.5rem; 
		    font-weight: 700; 
		    text-decoration: none; 
		    letter-spacing: 0.5px; 
		}

		.nav-menu { 
		    display: flex; 
		    height: 100%; 
		    align-items: center; 
		}
		.nav-item { 
		    position: relative; 
		    height: 100%; 
		    display: flex; 
		    align-items: center; 
		}
		.nav-link {
		    color: #e9ecef;
		    text-decoration: none;
		    font-weight: 500;
		    font-size: 0.95rem;
		    padding: 0.5rem 0.8rem;
		    border-radius: 4px;
		    transition: background 0.2s, color 0.2s;
		}
		.nav-link:hover { 
		    background: #002752; 
		    color: #ffffff; 
		}
        /* Dropdown Menu */
        .dropdown-menu { 
            display: none; 
            position: absolute; 
            top: 65px; 
            left: 0; 
            background: #ffffff; 
            min-width: 190px; 
            box-shadow: 0 6px 18px rgba(0,0,0,0.15); 
            border-radius: 0 0 6px 6px; 
            list-style: none; 
            overflow: hidden; 
            z-index: 1000; 
        }
        .dropdown-menu a { 
            color: #333; 
            padding: 0.75rem 1.2rem; 
            text-decoration: none; 
            display: block; 
            font-size: 0.9rem; 
            font-weight: 500; 
        }
        .dropdown-menu a:hover { 
            background: #f1f3f5; 
            color: #004085; 
        }
        .nav-item:hover .dropdown-menu { 
            display: block; 
        }
        
        /* Far Right Logout Button */
        .logout-btn { 
            background: #dc3545; 
            color: white; 
            border: none; 
            padding: 0.5rem 1rem; 
            border-radius: 4px; 
            font-weight: 600; 
            cursor: pointer; 
            transition: background 0.2s; 
        }
        .logout-btn:hover { 
            background: #bd2130; 
        }

        /* Content Area */
		/* Centered Content Area */
		.content-area { 
		    flex: 1; 
		    display: flex;
		    flex-direction: column;
		    justify-content: center; /* Vertically center content */
		    align-items: center;     /* Horizontally center content */
		    padding: 2rem; 
		    text-align: center; 
		}
    </style>
</head>
<body>

    <div class="page-wrapper">
        <!-- Admin Navbar -->
        <nav class="navbar">
            <a href="homeadmin" class="navbar-brand">🏦 V-Bank</a>

            <ul class="nav-menu">
                <li class="nav-item"><a href="searchaccount" class="nav-link">Search Account</a></li>
                <li class="nav-item"><a href="createaccount" class="nav-link">Create Account</a></li>
                <li class="nav-item"><a href="adminTransactions" class="nav-link">Transaction History</a></li>
                <li class="nav-item"><a href="admindeposit" class="nav-link">Deposit</a></li>
                <li class="nav-item"><a href="adminwithdraw" class="nav-link">Withdraw</a></li>
                
                <li class="nav-item">
                    <a href="#" class="nav-link">Accounts ▾</a>
                    <ul class="dropdown-menu">
                        <li><a href="allAccount">1. All Accounts</a></li>
                        <li><a href="active">2. Active Accounts</a></li>
                        <li><a href="pending">3. Pending Accounts</a></li>
                    </ul>
                </li>
            </ul>

            <form action="logout" method="post" style="margin: 0;">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </nav>

        <!-- Main Content Area -->
        <div class="content-area">
            <h2>V-Bank Administrative Operations Console</h2>
            <p style="color: #6c757d; margin-top: 0.5rem;">Select an action from the top menu bar to manage customer accounts and monitor activity.</p>
        </div>
    </div>

    <!-- Reusable Sticky Footer -->
    <%@ include file="footer.jsp" %>

</body>
</html>