package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.OrderStatusCountResponse;
import com.tranminhduong.clothingstore.dto.RevenueResponse;
import com.tranminhduong.clothingstore.dto.DailyRevenueResponse;
import com.tranminhduong.clothingstore.dto.TopProductResponse;
import com.tranminhduong.clothingstore.service.DashboardService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/admin/dashboard")
public class AdminDashboardController {

    private final DashboardService dashboardService;

    public AdminDashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    // Chức năng: doanh thu theo khoảng ngày. Ví dụ: GET /api/admin/dashboard/revenue?from=2026-01-01&to=2026-01-31
    @GetMapping("/revenue")
    public ResponseEntity<RevenueResponse> getRevenue(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        return ResponseEntity.ok(new RevenueResponse(dashboardService.getRevenue(from, to)));
    }

    @GetMapping("/revenue/by-day")
    public ResponseEntity<List<DailyRevenueResponse>> getDailyRevenue(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate from,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate to) {
        return ResponseEntity.ok(dashboardService.getDailyRevenue(from, to));
    }

    // Chức năng: số đơn theo trạng thái. Ví dụ: GET /api/admin/dashboard/orders-by-status
    @GetMapping("/orders-by-status")
    public ResponseEntity<List<OrderStatusCountResponse>> getOrderCounts() {
        return ResponseEntity.ok(dashboardService.getOrderCounts());
    }

    // Chức năng: sản phẩm bán chạy. Ví dụ: GET /api/admin/dashboard/top-products?limit=10
    @GetMapping("/top-products")
    public ResponseEntity<List<TopProductResponse>> getTopProducts(@RequestParam Integer limit) {
        return ResponseEntity.ok(dashboardService.getTopProducts(limit));
    }
}
