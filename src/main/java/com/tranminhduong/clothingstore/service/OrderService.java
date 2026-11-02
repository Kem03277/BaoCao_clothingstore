package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.dto.UserOrderRequest;
import com.tranminhduong.clothingstore.entity.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.util.List;

public interface OrderService {
    List<Order> getOrders(String status, LocalDate from, LocalDate to);
    Page<Order> getOrders(String status, LocalDate from, LocalDate to, Pageable pageable);
    Order getOrderById(Long id);
    Order updateOrderStatus(Long id, String status);
    Order cancelOrder(Long id);

    // User-facing
    Order placeOrder(Long userId, UserOrderRequest request);
    Order getMyOrderByCode(Long userId, String orderCode);
    List<Order> getMyOrders(Long userId);
    Order getMyOrderById(Long userId, Long orderId);
    Order cancelMyOrder(Long userId, Long orderId);
}
