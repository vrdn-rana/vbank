<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    /* Common Reusable Footer Styles */
    .footer { 
        background: #002752; 
        color: #ced4da; 
        padding: 2rem 0 1rem 0; 
        margin-top: auto; 
        font-size: 0.9rem; 
        width: 100%;
    }
    .footer-container { 
        max-width: 1100px; 
        margin: 0 auto; 
        padding: 0 2rem; 
        display: flex; 
        justify-content: space-between; 
        flex-wrap: wrap; 
        gap: 1.5rem; 
        text-align: left; 
    }
    .footer-col { 
        flex: 1; 
        min-width: 220px; 
    }
    .footer-col h4 { 
        color: #ffffff; 
        margin-bottom: 0.8rem; 
        font-size: 1rem; 
        border-bottom: 2px solid #004085; 
        padding-bottom: 0.3rem; 
        display: inline-block; 
    }
    .footer-col p { 
        line-height: 1.5; 
        color: #adb5bd; 
        font-size: 0.85rem; 
    }
    .footer-links { 
        list-style: none; 
        padding: 0;
    }
    .footer-links li { 
        margin-bottom: 0.4rem; 
    }
    .footer-links a { 
        color: #ced4da; 
        text-decoration: none; 
        transition: color 0.2s; 
        font-size: 0.85rem; 
    }
    .footer-links a:hover { 
        color: #ffffff; 
        text-decoration: underline; 
    }
    .footer-bottom { 
        text-align: center; 
        border-top: 1px solid #003366; 
        margin-top: 1.5rem; 
        padding-top: 1rem; 
        font-size: 0.8rem; 
        color: #868e96; 
    }
</style>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-col">
            <h4>🏦 V-Bank</h4>
            <p>Your trusted digital banking partner. Experience fast, transparent, and secure multi-factor financial services anytime, anywhere.</p>
        </div>
        <div class="footer-col">
            <h4>Quick Links</h4>
            <ul class="footer-links">
                <li><a href="index">Home</a></li>
                <li><a href="createaccount">Apply for Account</a></li>
                <li><a href="login">Portal Sign In</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>Security & Support</h4>
            <p>🔒 256-Bit SSL Encryption Active</p>
            <p>📧 Support: support@vbank.com</p>
            <p>📞 Helpline: 1800-123-VBANK</p>
        </div>
    </div>
    <div class="footer-bottom">
        &copy; 2026 V-Bank Application. All Rights Reserved.
    </div>
</footer>