package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.OrderResponse;
import com.tranminhduong.clothingstore.dto.UserOrderRequest;
import com.tranminhduong.clothingstore.mapper.OrderMapper;
import com.tranminhduong.clothingstore.security.AuthenticatedUser;
import com.tranminhduong.clothingstore.service.OrderService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Các endpoint đặt hàng và quản lý đơn hàng phía khách hàng.
 * Base URL: /api/orders
 */
@RestController
@RequestMapping("/api/orders")
@Transactional(readOnly = true)
public class UserOrderController {

    private final OrderService orderService;
    private final OrderMapper orderMapper;

    public UserOrderController(OrderService orderService, OrderMapper orderMapper) {
        this.orderService = orderService;
        this.orderMapper = orderMapper;
    }

    /** POST /api/orders – Đặt hàng mới */
    @PostMapping
    @Transactional
    public ResponseEntity<OrderResponse> placeOrder(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @RequestBody UserOrderRequest request) {
        return ResponseEntity.status(201).body(
                orderMapper.toResponse(orderService.placeOrder(currentUser.id(), request)));
    }

    /** GET /api/orders/my – Lấy danh sách đơn hàng của user hiện tại */
    @GetMapping("/my")
    public ResponseEntity<List<OrderResponse>> getMyOrders(
            @AuthenticationPrincipal AuthenticatedUser currentUser) {
        return ResponseEntity.ok(
                orderService.getMyOrders(currentUser.id()).stream()
                        .map(orderMapper::toResponse)
                        .toList());
    }

    /** GET /api/orders/my/{id} – Chi tiết một đơn hàng của user hiện tại */
    @GetMapping("/my/{id}")
    public ResponseEntity<OrderResponse> getMyOrderById(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @PathVariable("id") Long orderId) {
        return ResponseEntity.ok(
                orderMapper.toResponse(orderService.getMyOrderById(currentUser.id(), orderId)));
    }

    /** PUT /api/orders/my/{id}/cancel – Hủy đơn hàng (nếu đủ điều kiện) */
    @PutMapping("/my/{id}/cancel")
    @Transactional
    public ResponseEntity<OrderResponse> cancelMyOrder(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @PathVariable("id") Long orderId) {
        return ResponseEntity.ok(
                orderMapper.toResponse(orderService.cancelMyOrder(currentUser.id(), orderId)));
    }
}
