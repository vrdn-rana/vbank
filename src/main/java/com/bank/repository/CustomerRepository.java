package com.bank.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bank.pojo.Customer;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {

    // Find customer profile by email address
    Optional<Customer> findByEmail(String email);

    // Authentication lookup by email and password
    Optional<Customer> findByEmailAndPassword(String email, String password);

    // Filter customer accounts by status ("PENDING", "ACTIVE", "BLOCKED", "REJECTED")
    List<Customer> findByStatus(String status);

    // Check if email already exists during registration
    boolean existsByEmail(String email);
    
    List<Customer> findByStatusIgnoreCase(String status);
}