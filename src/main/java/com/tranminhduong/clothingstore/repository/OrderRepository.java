package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, Long> {

    @EntityGraph(attributePaths = {"user", "orderItems", "coupon"})
    @Query(
            value = """
                    SELECT o FROM StoreOrder o
                    WHERE (:status IS NULL OR UPPER(o.status) = UPPER(:status))
                      AND (:from IS NULL OR o.createdAt >= :from)
                      AND (:until IS NULL OR o.createdAt < :until)
                    """,
            countQuery = """
                    SELECT COUNT(o) FROM StoreOrder o
                    WHERE (:status IS NULL OR UPPER(o.status) = UPPER(:status))
                      AND (:from IS NULL OR o.createdAt >= :from)
                      AND (:until IS NULL OR o.createdAt < :until)
                    """)
    Page<Order> searchOrdersPage(
            @Param("status") String status,
            @Param("from") LocalDateTime from,
            @Param("until") LocalDateTime until,
            Pageable pageable);

    @Query("""
            SELECT DISTINCT o FROM StoreOrder o
            LEFT JOIN FETCH o.user
            LEFT JOIN FETCH o.coupon
            LEFT JOIN FETCH o.orderItems oi
            LEFT JOIN FETCH oi.product
            WHERE (:status IS NULL OR UPPER(o.status) = UPPER(:status))
              AND (:from IS NULL OR o.createdAt >= :from)
              AND (:until IS NULL OR o.createdAt < :until)
            ORDER BY o.createdAt DESC
            """)
    List<Order> searchOrders(
            @Param("status") String status,
            @Param("from") LocalDateTime from,
            @Param("until") LocalDateTime until);

    @Query("""
            SELECT DISTINCT o FROM StoreOrder o
            LEFT JOIN FETCH o.user
            LEFT JOIN FETCH o.coupon
            LEFT JOIN FETCH o.orderItems oi
            LEFT JOIN FETCH oi.product
            WHERE o.id = :id
            """)
    Optional<Order> findDetailsById(@Param("id") Long id);

    @Query("""
            SELECT DISTINCT o FROM StoreOrder o
            LEFT JOIN FETCH o.user
            LEFT JOIN FETCH o.coupon
            LEFT JOIN FETCH o.orderItems oi
            LEFT JOIN FETCH oi.product
            WHERE o.user.id = :userId
            ORDER BY o.createdAt DESC
            """)
    List<Order> findByUserId(@Param("userId") Long userId);

    @Query("""
            SELECT DISTINCT o FROM StoreOrder o
            LEFT JOIN FETCH o.user
            LEFT JOIN FETCH o.coupon
            LEFT JOIN FETCH o.orderItems oi
            LEFT JOIN FETCH oi.product
            WHERE o.id = :id AND o.user.id = :userId
            """)
    Optional<Order> findDetailsByIdAndUserId(@Param("id") Long id, @Param("userId") Long userId);

    @Query("""
            SELECT DISTINCT o FROM StoreOrder o
            LEFT JOIN FETCH o.user
            LEFT JOIN FETCH o.coupon
            LEFT JOIN FETCH o.orderItems oi
            LEFT JOIN FETCH oi.product
            WHERE o.orderCode = :orderCode AND o.user.id = :userId
            """)
    Optional<Order> findDetailsByOrderCodeAndUserId(
            @Param("orderCode") String orderCode,
            @Param("userId") Long userId);
}
