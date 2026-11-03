<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bank.pojo.Customer"%>
<%
    Customer headerUser = (Customer) session.getAttribute("user");
    String displayName = (headerUser != null && headerUser.getCustname() != null) ? headerUser.getCustname() : "Customer";
%>
<style>
    .customer-header {
        background: #004085;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 2rem;
        height: 65px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.15);
        position: relative;
        z-index: 1000;
    }

    .brand-logo {
        color: #ffffff;
        font-size: 1.5rem;
        font-weight: 700;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
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
    .header-right {
        display: flex;
        align-items: center;
        gap: 1.2rem;
    }

    .user-greeting {
        color: #d1ecf1;
        font-size: 0.9rem;
        font-weight: 500;
    }

    .logout-btn {
        background: #dc3545;
        color: #ffffff;
        border: none;
        padding: 0.5rem 1rem;
        border-radius: 4px;
        font-weight: 600;
        font-size: 0.9rem;
        cursor: pointer;
        transition: background 0.2s;
    }

    .logout-btn:hover {
        background: #bd2130;
    }
</style>

<header class="customer-header">
    <a href="homecustomer" class="brand-logo">🏦 V-Bank</a>

    <ul class="nav-menu">
        <li class="nav-item"><a href="homecustomer" class="nav-link">Home</a></li>
        <li class="nav-item"><a href="deposit" class="nav-link">Deposit</a></li>
        <li class="nav-item"><a href="transfer" class="nav-link">Transfer</a></li>
        <li class="nav-item"><a href="transactions" class="nav-link">All Transactions</a></li>
        <li class="nav-item"><a href="ministatement" class="nav-link">Mini Statement</a></li>
    </ul>

    <div class="header-right">
        <form action="logout" method="post" style="margin: 0;">
            <button type="submit" class="logout-btn">Logout</button>
        </form>
    </div>
</header>