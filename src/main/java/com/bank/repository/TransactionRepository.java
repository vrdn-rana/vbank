package com.bank.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.bank.pojo.Transaction;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {

    // Fetch all transactions where the account is either sender or receiver, sorted by date (newest first)
    @Query("SELECT t FROM Transaction t WHERE t.senderAccno = :accno1 OR t.receiverAccno = :accno2 ORDER BY t.dateTime DESC")
    List<Transaction> findAccnoOrderByDateTime(@Param("accno1") Long accno1, @Param("accno2") Long accno2);

    // Fetch all master transaction records for admin audit
    List<Transaction> findAllByOrderByDateTimeDesc();

    // 1️⃣ Find all transactions where account is sender OR receiver (ordered newest first)
    List<Transaction> findBySenderAccnoOrReceiverAccnoOrderByDateTimeDesc(Long senderAccno, Long receiverAccno);

    // 2️⃣ Find top 5 recent transactions for mini statement
    List<Transaction> findTop5BySenderAccnoOrReceiverAccnoOrderByDateTimeDesc(Long senderAccno, Long receiverAccno);

    // 3️⃣ Delete transactions during account deletion sweep
    void deleteBySenderAccnoOrReceiverAccno(Long senderAccno, Long receiverAccno);
}