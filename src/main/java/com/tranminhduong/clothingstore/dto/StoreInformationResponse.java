package com.tranminhduong.clothingstore.dto;

import java.math.BigDecimal;
import java.util.List;

public record StoreInformationResponse(
        List<String> paymentMethods,
        List<String> paymentStatuses,
        List<String> shippingCarriers,
        List<String> shippingStatuses,
        BigDecimal shippingFee,
        BigDecimal freeShippingThreshold) {
}
