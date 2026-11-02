package com.tranminhduong.clothingstore.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record VnpayPaymentStatusResponse(
        String orderCode,
        String orderStatus,
        String paymentStatus,
        BigDecimal amount,
        LocalDateTime expiresAt) {
}
