package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.Lock;
import jakarta.persistence.LockModeType;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
    @Query("SELECT DISTINCT p.method FROM Payment p WHERE p.method IS NOT NULL AND p.method <> '' ORDER BY p.method")
    List<String> findDistinctMethods();

    @Query("SELECT DISTINCT p.status FROM Payment p WHERE p.status IS NOT NULL AND p.status <> '' ORDER BY p.status")
    List<String> findDistinctStatuses();

    @Query("SELECT p FROM Payment p JOIN FETCH p.order WHERE p.order.id = :orderId ORDER BY p.id")
    List<Payment> findByOrderId(@Param("orderId") Long orderId);

    @Query("SELECT p FROM Payment p JOIN FETCH p.order WHERE p.id = :id")
    Optional<Payment> findDetailsById(@Param("id") Long id);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT p FROM Payment p JOIN FETCH p.order WHERE p.transactionCode = :transactionCode")
    Optional<Payment> findByTransactionCodeForUpdate(@Param("transactionCode") String transactionCode);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT p FROM Payment p JOIN FETCH p.order WHERE p.method = 'VNPAY' AND p.status = 'PENDING' AND p.createdAt <= :expiredBefore")
    List<Payment> findExpiredVnpayPayments(@Param("expiredBefore") LocalDateTime expiredBefore);
}
