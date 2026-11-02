package com.tranminhduong.clothingstore.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record VnpayCreateResponse(
        String orderCode,
        BigDecimal amount,
        String paymentUrl,
        String qrCodeDataUrl,
        LocalDateTime expiresAt) {
}
