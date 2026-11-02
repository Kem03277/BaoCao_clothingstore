package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.OrderResponse;
import com.tranminhduong.clothingstore.dto.OrderStatusRequest;
import com.tranminhduong.clothingstore.dto.PageResponse;
import com.tranminhduong.clothingstore.mapper.OrderMapper;
import com.tranminhduong.clothingstore.service.OrderService;
import com.tranminhduong.clothingstore.util.PageRequestFactory;
import org.springframework.data.domain.Sort;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/admin/orders")
@Transactional(readOnly = true)
public class OrderController {

    private final OrderService orderService;
    private final OrderMapper orderMapper;

    public OrderController(OrderService orderService, OrderMapper orderMapper) {
        this.orderService = orderService;
        this.orderMapper = orderMapper;
    }

    // Chức năng: lọc danh sách đơn hàng. Ví dụ: GET /api/admin/orders?status=NEW&from=2026-01-01
    @GetMapping
    public ResponseEntity<List<OrderResponse>> getOrders(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        return ResponseEntity.ok(orderService.getOrders(status, from, to).stream()
                .map(orderMapper::toResponse)
                .toList());
    }

    @GetMapping("/page")
    public ResponseEntity<PageResponse<OrderResponse>> getOrdersPage(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        var orders = orderService.getOrders(
                status,
                from,
                to,
                PageRequestFactory.create(
                        page,
                        size,
                        Sort.by(Sort.Order.desc("createdAt"), Sort.Order.desc("id"))));
        return ResponseEntity.ok(PageResponse.from(orders.map(orderMapper::toResponse)));
    }

    // Chức năng: chi tiết đơn hàng và sản phẩm. Ví dụ: GET /api/admin/orders/1
    @GetMapping("/{id}")
    public ResponseEntity<OrderResponse> getOrder(@PathVariable("id") Long id) {
        return ResponseEntity.ok(orderMapper.toResponse(orderService.getOrderById(id)));
    }

    // Chức năng: đổi trạng thái đơn hàng. Ví dụ: PUT /api/admin/orders/1/status
    @PutMapping("/{id}/status")
    @Transactional
    public ResponseEntity<OrderResponse> updateStatus(
            @PathVariable("id") Long id,
            @RequestBody(required = false) OrderStatusRequest request) {
        return ResponseEntity.ok(orderMapper.toResponse(
                orderService.updateOrderStatus(id, request == null ? null : request.status())));
    }

    // Chức năng: hủy đơn hàng, chỉ đổi trạng thái. Ví dụ: PUT /api/admin/orders/1/cancel
    @PutMapping("/{id}/cancel")
    @Transactional
    public ResponseEntity<OrderResponse> cancelOrder(@PathVariable("id") Long id) {
        return ResponseEntity.ok(orderMapper.toResponse(orderService.cancelOrder(id)));
    }
}
