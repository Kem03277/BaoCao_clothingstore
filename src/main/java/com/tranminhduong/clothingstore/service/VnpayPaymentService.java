package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.dto.UserOrderRequest;
import com.tranminhduong.clothingstore.dto.VnpayCreateResponse;
import com.tranminhduong.clothingstore.dto.VnpayPaymentStatusResponse;
import java.util.Map;

public interface VnpayPaymentService {
    VnpayCreateResponse createPayment(Long userId, UserOrderRequest request, String clientIp);
    VnpayCreateResponse retryPayment(Long userId, String orderCode, String clientIp);
    VnpayPaymentStatusResponse getPaymentStatus(Long userId, String orderCode);
    String handleIpn(Map<String, String> parameters);
    VnpayPaymentStatusResponse confirmTransfer(Long userId, String orderCode);
}
