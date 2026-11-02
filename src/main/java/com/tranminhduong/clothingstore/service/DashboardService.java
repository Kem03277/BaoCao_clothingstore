package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.dto.OrderStatusCountResponse;
import com.tranminhduong.clothingstore.dto.DailyRevenueResponse;
import com.tranminhduong.clothingstore.dto.TopProductResponse;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface DashboardService {
    BigDecimal getRevenue(LocalDate from, LocalDate to);
    List<DailyRevenueResponse> getDailyRevenue(LocalDate from, LocalDate to);
    List<OrderStatusCountResponse> getOrderCounts();
    List<TopProductResponse> getTopProducts(Integer limit);
}
