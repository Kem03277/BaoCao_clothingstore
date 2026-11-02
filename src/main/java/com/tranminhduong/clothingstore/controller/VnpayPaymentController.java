package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.UserOrderRequest;
import com.tranminhduong.clothingstore.dto.VnpayCreateResponse;
import com.tranminhduong.clothingstore.dto.VnpayPaymentStatusResponse;
import com.tranminhduong.clothingstore.security.AuthenticatedUser;
import com.tranminhduong.clothingstore.service.VnpayPaymentService;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.view.RedirectView;
import org.springframework.web.util.UriComponentsBuilder;
import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/api/payments/vnpay")
public class VnpayPaymentController {
    private final VnpayPaymentService vnpayPaymentService;
    private final String frontendReturnUrl;

    public VnpayPaymentController(
            VnpayPaymentService vnpayPaymentService,
            @Value("${vnpay.frontend-return-url:http://localhost:5173/}") String frontendReturnUrl) {
        this.vnpayPaymentService = vnpayPaymentService;
        this.frontendReturnUrl = frontendReturnUrl;
    }

    @PostMapping("/create")
    public ResponseEntity<VnpayCreateResponse> createPayment(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @RequestBody UserOrderRequest request,
            HttpServletRequest servletRequest) {
        return ResponseEntity.status(HttpStatus.CREATED).body(
                vnpayPaymentService.createPayment(currentUser.id(), request, servletRequest.getRemoteAddr()));
    }

    @PostMapping("/retry")
    public ResponseEntity<VnpayCreateResponse> retryPayment(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @RequestParam String orderCode,
            HttpServletRequest servletRequest) {
        return ResponseEntity.ok(
                vnpayPaymentService.retryPayment(currentUser.id(), orderCode, servletRequest.getRemoteAddr()));
    }

    @GetMapping("/status")
    public ResponseEntity<VnpayPaymentStatusResponse> getStatus(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @RequestParam String orderCode) {
        return ResponseEntity.ok(vnpayPaymentService.getPaymentStatus(currentUser.id(), orderCode));
    }

    @PostMapping("/confirm-transfer")
    public ResponseEntity<VnpayPaymentStatusResponse> confirmTransfer(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @RequestParam String orderCode) {
        return ResponseEntity.ok(vnpayPaymentService.confirmTransfer(currentUser.id(), orderCode));
    }

    @GetMapping("/ipn")
    public ResponseEntity<Map<String, String>> ipnGet(@RequestParam Map<String, String> parameters) {
        return ipnResponse(parameters);
    }

    @PostMapping("/ipn")
    public ResponseEntity<Map<String, String>> ipnPost(@RequestParam Map<String, String> parameters) {
        return ipnResponse(parameters);
    }

    @GetMapping("/return")
    public RedirectView returnFromVnpay(@RequestParam Map<String, String> parameters) {
        String orderCode = parameters.get("vnp_TxnRef");
        if (orderCode == null || orderCode.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Thiếu mã đơn hàng VNPay.");
        }
        vnpayPaymentService.handleIpn(parameters);
        String redirectUrl = UriComponentsBuilder.fromUriString(frontendReturnUrl)
                .replaceQueryParam("vnp_order")
                .queryParam("vnp_order", orderCode)
                .build()
                .encode()
                .toUriString();
        return new RedirectView(redirectUrl);
    }

    private ResponseEntity<Map<String, String>> ipnResponse(Map<String, String> parameters) {
        String result = vnpayPaymentService.handleIpn(parameters);
        String message = switch (result) {
            case "00" -> "Confirm Success";
            case "01" -> "Order not found";
            case "02" -> "Order already confirmed";
            case "04" -> "Invalid amount or transaction";
            default -> "Invalid signature";
        };
        return ResponseEntity.ok(Map.of("RspCode", result, "Message", message));
    }
}
