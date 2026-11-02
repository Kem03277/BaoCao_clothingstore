package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.dto.OrderStatusCountResponse;
import com.tranminhduong.clothingstore.dto.TopProductResponse;
import com.tranminhduong.clothingstore.entity.Order;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public interface DashboardRepository extends JpaRepository<Order, Long> {

    @Query("""
            SELECT COALESCE(SUM(o.totalAmount), 0) FROM StoreOrder o
            WHERE o.createdAt >= :from AND o.createdAt < :until
              AND (o.status IS NULL OR UPPER(o.status) <> 'CANCELLED')
            """)
    BigDecimal sumRevenue(
            @Param("from") LocalDateTime from,
            @Param("until") LocalDateTime until);

    @Query("""
            SELECT o FROM StoreOrder o
            WHERE o.createdAt >= :from AND o.createdAt < :until
              AND (o.status IS NULL OR UPPER(o.status) <> 'CANCELLED')
            ORDER BY o.createdAt
            """)
    List<Order> findOrdersForDailyRevenue(
            @Param("from") LocalDateTime from,
            @Param("until") LocalDateTime until);

    @Query("""
            SELECT new com.tranminhduong.clothingstore.dto.OrderStatusCountResponse(
                UPPER(o.status), COUNT(o))
            FROM StoreOrder o
            GROUP BY UPPER(o.status)
            ORDER BY UPPER(o.status)
            """)
    List<OrderStatusCountResponse> countOrdersByStatus();

    @Query("""
            SELECT new com.tranminhduong.clothingstore.dto.TopProductResponse(
                oi.product.id, oi.productName, SUM(oi.quantity))
            FROM OrderItem oi JOIN oi.order o
            WHERE o.status IS NULL OR UPPER(o.status) <> 'CANCELLED'
            GROUP BY oi.product.id, oi.productName
            ORDER BY SUM(oi.quantity) DESC
            """)
    List<TopProductResponse> findTopSellingProducts(Pageable pageable);
}
