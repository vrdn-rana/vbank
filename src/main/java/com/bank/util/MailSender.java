package com.bank.util;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service("otpMailService")
public class MailSender {
	
	@Value("${mail.sender.email:default@gmail.com}")
    private String fromEmail;

    @Value("${mail.sender.password:default_password}")
    private String password;

    public void sendMail(String toEmail, int otp) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("V-Bank - OTP Verification");

            String htmlMsg = "<div style='font-family:Arial,sans-serif; padding:20px; border:1px solid #004085; border-radius:8px;'>"
                    + "<h2 style='color:#004085;'>🏦 V-Bank Verification</h2>"
                    + "<p>Dear Customer,</p>"
                    + "<p>Your One-Time Password (OTP) for V-Bank authentication is:</p>"
                    + "<h1 style='color:#dc3545; letter-spacing:4px;'>" + otp + "</h1>"
                    + "<p>This OTP is valid for <strong>5 minutes</strong>. Do not share it with anyone.</p>"
                    + "<br><p>Regards,<br><strong>V-Bank Security Team</strong></p>"
                    + "</div>";

            message.setContent(htmlMsg, "text/html");
            Transport.send(message);

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to send OTP email: " + e.getMessage());
        }
    }
}