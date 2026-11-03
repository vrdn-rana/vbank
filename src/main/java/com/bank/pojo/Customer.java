package com.bank.pojo;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "customer")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long accno; // Auto-increment Primary Key

    private String custname;

    @Column(unique = true, nullable = false)
    private String email;

    private String password;

    private double balance;

    private String role; // "ADMIN" or "CUSTOMER"

    private String status; // "PENDING", "ACTIVE", "BLOCKED", "REJECTED"

    private String acctype; // "SAVINGS", "CURRENT"

    private String dp; // Filename of profile picture

    // Constructors
    public Customer() {}

    public Customer(String custname, String email, String password, double balance, String role, String status, String acctype, String dp) {
        this.custname = custname;
        this.email = email;
        this.password = password;
        this.balance = balance;
        this.role = role;
        this.status = status;
        this.acctype = acctype;
        this.dp = dp;
    }

    // Getters and Setters
    public Long getAccno() {
        return accno;
    }

    public void setAccno(Long accno) {
        this.accno = accno;
    }

    public String getCustname() {
        return custname;
    }

    public void setCustname(String custname) {
        this.custname = custname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAcctype() {
        return acctype;
    }

    public void setAcctype(String acctype) {
        this.acctype = acctype;
    }

    public String getDp() {
        return dp;
    }

    public void setDp(String dp) {
        this.dp = dp;
    }

    @Override
    public String toString() {
        return "Customer [accno=" + accno + ", custname=" + custname + ", email=" + email + ", balance=" + balance 
                + ", role=" + role + ", status=" + status + ", acctype=" + acctype + "]";
    }
}