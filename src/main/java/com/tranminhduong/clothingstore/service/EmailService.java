package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.entity.Order;

public interface EmailService {
    /**
     * Gửi email xác nhận thanh toán và thông tin chi tiết đơn hàng đến khách hàng
     * và quản trị viên cửa hàng.
     */
    void sendOrderPaymentConfirmation(Order order);
}

