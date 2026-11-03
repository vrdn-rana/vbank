package com.bank.pojo;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "transaction")
public class Transaction {

	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long transactionId;

    private Long senderAccno;
    private Long receiverAccno;
    private double amount;
    private String type;
    private LocalDateTime dateTime;

    public Transaction() {}

    public Transaction(Long senderAccno, Long receiverAccno, double amount, LocalDateTime localDateTime, String type) {
        this.senderAccno = senderAccno;
        this.receiverAccno = receiverAccno;
        this.amount = amount;
        this.dateTime = localDateTime;
        this.type = type;
    }

   

	// Getters and Setters
    public Long getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Long transactionId) {
        this.transactionId = transactionId;
    }

    public Long getSenderAccno() {
        return senderAccno;
    }

    public void setSenderAccno(Long senderAccno) {
        this.senderAccno = senderAccno;
    }

    public Long getReceiverAccno() {
        return receiverAccno;
    }

    public void setReceiverAccno(Long receiverAccno) {
        this.receiverAccno = receiverAccno;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public LocalDateTime getDateTime() {
        return dateTime;
    }

    public void setDateTime(LocalDateTime dateTime) {
        this.dateTime = dateTime;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "Transaction [transactionId=" + transactionId + ", senderAccno=" + senderAccno 
                + ", receiverAccno=" + receiverAccno + ", amount=" + amount + ", dateTime=" + dateTime + ", type=" + type + "]";
    }
}