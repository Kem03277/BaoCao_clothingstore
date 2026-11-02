package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.dto.OrderStatusCountResponse;
import com.tranminhduong.clothingstore.dto.DailyRevenueResponse;
import com.tranminhduong.clothingstore.dto.TopProductResponse;
import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.repository.DashboardRepository;
import com.tranminhduong.clothingstore.service.DashboardService;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DashboardServiceImpl implements DashboardService {

    private final DashboardRepository dashboardRepository;

    public DashboardServiceImpl(DashboardRepository dashboardRepository) {
        this.dashboardRepository = dashboardRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public BigDecimal getRevenue(LocalDate from, LocalDate to) {
        validateDateRange(from, to);
        if (from == null || to == null) {
            throw new BadRequestException("Ngày bắt đầu và ngày kết thúc không được để trống");
        }
        return dashboardRepository.sumRevenue(from.atStartOfDay(), to.plusDays(1).atStartOfDay());
    }

    @Override
    @Transactional(readOnly = true)
    public List<DailyRevenueResponse> getDailyRevenue(LocalDate from, LocalDate to) {
        validateDateRange(from, to);
        if (from == null || to == null) {
            throw new BadRequestException("Ngày bắt đầu và ngày kết thúc không được để trống");
        }

        Map<LocalDate, BigDecimal> revenueByDate = new HashMap<>();
        List<Order> orders = dashboardRepository.findOrdersForDailyRevenue(
                from.atStartOfDay(), to.plusDays(1).atStartOfDay());
        for (Order order : orders) {
            LocalDate orderDate = order.getCreatedAt().toLocalDate();
            BigDecimal amount = order.getTotalAmount() == null ? BigDecimal.ZERO : order.getTotalAmount();
            revenueByDate.merge(orderDate, amount, BigDecimal::add);
        }

        List<DailyRevenueResponse> dailyRevenue = new ArrayList<>();
        for (LocalDate date = from; !date.isAfter(to); date = date.plusDays(1)) {
            dailyRevenue.add(new DailyRevenueResponse(date, revenueByDate.getOrDefault(date, BigDecimal.ZERO)));
        }
        return dailyRevenue;
    }

    @Override
    @Transactional(readOnly = true)
    public List<OrderStatusCountResponse> getOrderCounts() {
        return dashboardRepository.countOrdersByStatus();
    }

    @Override
    @Transactional(readOnly = true)
    public List<TopProductResponse> getTopProducts(Integer limit) {
        if (limit == null || limit < 1) {
            throw new BadRequestException("Giới hạn sản phẩm phải lớn hơn 0");
        }
        return dashboardRepository.findTopSellingProducts(PageRequest.of(0, limit));
    }

    private void validateDateRange(LocalDate from, LocalDate to) {
        if (from != null && to != null && from.isAfter(to)) {
            throw new BadRequestException("Ngày bắt đầu không được sau ngày kết thúc");
        }
    }
}
