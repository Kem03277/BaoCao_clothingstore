package com.tranminhduong.clothingstore.service.Impl;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.tranminhduong.clothingstore.dto.UserOrderRequest;
import com.tranminhduong.clothingstore.dto.VnpayCreateResponse;
import com.tranminhduong.clothingstore.dto.VnpayPaymentStatusResponse;
import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.entity.OrderItem;
import com.tranminhduong.clothingstore.entity.Payment;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.exception.ServiceUnavailableException;
import com.tranminhduong.clothingstore.repository.OrderRepository;
import com.tranminhduong.clothingstore.repository.PaymentRepository;
import com.tranminhduong.clothingstore.service.EmailService;
import com.tranminhduong.clothingstore.service.InventoryService;
import com.tranminhduong.clothingstore.service.OrderService;
import com.tranminhduong.clothingstore.service.VnpayPaymentService;
import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Base64;
import java.util.EnumMap;
import java.util.Map;
import java.util.TreeMap;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.DependsOn;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@DependsOn("paymentSchemaMigration")
public class VnpayPaymentServiceImpl implements VnpayPaymentService {
    private static final DateTimeFormatter VNPAY_DATE = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
    private static final ZoneId VIETNAM_ZONE = ZoneId.of("Asia/Ho_Chi_Minh");
    private static final int PAYMENT_TTL_MINUTES = 15;

    // Cấu hình tài khoản ngân hàng MBBank VietQR
    public static final String MB_BANK_BIN = "970422";
    public static final String MB_ACCOUNT_NO = "0377974947";
    public static final String MB_ACCOUNT_NAME = "PHAM DONG";

    private final OrderService orderService;
    private final OrderRepository orderRepository;
    private final PaymentRepository paymentRepository;
    private final InventoryService inventoryService;
    private final EmailService emailService;
    private final String terminalCode;
    private final String hashSecret;
    private final String paymentUrl;
    private final String backendBaseUrl;
    private final String frontendReturnUrl;

    public VnpayPaymentServiceImpl(
            OrderService orderService,
            OrderRepository orderRepository,
            PaymentRepository paymentRepository,
            InventoryService inventoryService,
            EmailService emailService,
            @Value("${vnpay.tmn-code:}") String terminalCode,
            @Value("${vnpay.hash-secret:}") String hashSecret,
            @Value("${vnpay.payment-url:https://sandbox.vnpayment.vn/paymentv2/vpcpay.html}") String paymentUrl,
            @Value("${vnpay.backend-base-url:http://localhost:8080}") String backendBaseUrl,
            @Value("${vnpay.frontend-return-url:http://localhost:5173/}") String frontendReturnUrl) {
        this.orderService = orderService;
        this.orderRepository = orderRepository;
        this.paymentRepository = paymentRepository;
        this.inventoryService = inventoryService;
        this.emailService = emailService;
        this.terminalCode = terminalCode;
        this.hashSecret = hashSecret;
        this.paymentUrl = paymentUrl;
        this.backendBaseUrl = backendBaseUrl;
        this.frontendReturnUrl = frontendReturnUrl;
    }

    @Override
    @Transactional
    public VnpayCreateResponse createPayment(Long userId, UserOrderRequest request, String clientIp) {
        requireConfiguration();
        UserOrderRequest vnpayRequest = new UserOrderRequest(
                request.addressId(), request.couponCode(), request.note(), request.items(), "VNPAY");
        Order order = orderService.placeOrder(userId, vnpayRequest);
        Payment payment = paymentRepository.findByTransactionCodeForUpdate(order.getOrderCode())
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy giao dịch VNPay vừa tạo"));
        if (payment.getAmount().compareTo(BigDecimal.valueOf(5_000)) < 0
                || payment.getAmount().compareTo(BigDecimal.valueOf(1_000_000_000)) > 0) {
            throw new BadRequestException("VNPay chỉ hỗ trợ giao dịch từ 5.000 đến 1.000.000.000 VND.");
        }
        LocalDateTime createdAt = LocalDateTime.now(VIETNAM_ZONE);
        payment.setCreatedAt(createdAt);
        paymentRepository.save(payment);
        LocalDateTime expiresAt = createdAt.plusMinutes(PAYMENT_TTL_MINUTES);

        return createPaymentResponse(order, payment, clientIp, createdAt, expiresAt);
    }

    @Override
    @Transactional
    public VnpayCreateResponse retryPayment(Long userId, String orderCode, String clientIp) {
        requireConfiguration();
        Order order = orderService.getMyOrderByCode(userId, orderCode);
        Payment payment = paymentRepository.findByTransactionCodeForUpdate(order.getOrderCode())
                .filter(item -> "VNPAY".equals(item.getMethod()))
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy giao dịch VNPay"));

        boolean retryingFailedPayment = "CANCELLED".equals(order.getStatus())
                && "FAILED".equals(payment.getStatus());
        if (retryingFailedPayment) {
            for (OrderItem item : order.getOrderItems()) {
                inventoryService.recordOrderSale(
                        item.getProduct().getId(), item.getQuantity(), order, order.getUser());
            }
            order.setStatus("PENDING");
            order.setUpdatedAt(LocalDateTime.now(VIETNAM_ZONE));
        } else if (!"PENDING".equals(order.getStatus()) || !"PENDING".equals(payment.getStatus())) {
            throw new BadRequestException("Đơn hàng không còn ở trạng thái chờ thanh toán.");
        }
        if (payment.getAmount().compareTo(BigDecimal.valueOf(5_000)) < 0
                || payment.getAmount().compareTo(BigDecimal.valueOf(1_000_000_000)) > 0) {
            throw new BadRequestException("VNPay chỉ hỗ trợ giao dịch từ 5.000 đến 1.000.000.000 VND.");
        }

        LocalDateTime createdAt = LocalDateTime.now(VIETNAM_ZONE);
        LocalDateTime expiresAt = createdAt.plusMinutes(PAYMENT_TTL_MINUTES);
        payment.setStatus("PENDING");
        payment.setCreatedAt(createdAt);
        paymentRepository.save(payment);
        return createPaymentResponse(order, payment, clientIp, createdAt, expiresAt);
    }

    private VnpayCreateResponse createPaymentResponse(
            Order order, Payment payment, String clientIp, LocalDateTime createdAt, LocalDateTime expiresAt) {
        Map<String, String> parameters = new TreeMap<>();
        parameters.put("vnp_Version", "2.1.0");
        parameters.put("vnp_Command", "pay");
        parameters.put("vnp_TmnCode", terminalCode);
        parameters.put("vnp_Amount", payment.getAmount().movePointRight(2).longValueExact() + "");
        parameters.put("vnp_CurrCode", "VND");
        parameters.put("vnp_TxnRef", order.getOrderCode());
        parameters.put("vnp_OrderInfo", "Thanh toan don hang " + order.getOrderCode());
        parameters.put("vnp_OrderType", "other");
        parameters.put("vnp_Locale", "vn");
        parameters.put("vnp_ReturnUrl", backendBaseUrl.replaceAll("/+$", "") + "/api/payments/vnpay/return");
        parameters.put("vnp_IpAddr", normalizeIp(clientIp));
        parameters.put("vnp_CreateDate", createdAt.format(VNPAY_DATE));
        parameters.put("vnp_ExpireDate", expiresAt.format(VNPAY_DATE));

        String signedQuery = encodeParameters(parameters);
        String secureHash = hmacSha512(hashSecret, signedQuery);
        String signedPaymentUrl = paymentUrl + "?" + signedQuery + "&vnp_SecureHash=" + secureHash;

        // Sinh mã VietQR chuẩn Napas cho MBBank 0377974947 - PHAM DONG
        String vietQrPayload = generateVietQrPayload(MB_BANK_BIN, MB_ACCOUNT_NO, payment.getAmount().longValue(), order.getOrderCode());

        return new VnpayCreateResponse(
                order.getOrderCode(), payment.getAmount(), signedPaymentUrl, createQrDataUrl(vietQrPayload), expiresAt);
    }

    @Override
    @Transactional(readOnly = true)
    public VnpayPaymentStatusResponse getPaymentStatus(Long userId, String orderCode) {
        Order order = orderService.getMyOrderByCode(userId, orderCode);
        Payment payment = paymentRepository.findByOrderId(order.getId()).stream()
                .filter(item -> "VNPAY".equals(item.getMethod()))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy giao dịch VNPay"));
        return new VnpayPaymentStatusResponse(
                order.getOrderCode(),
                order.getStatus(),
                payment.getStatus(),
                payment.getAmount(),
                payment.getCreatedAt().plusMinutes(PAYMENT_TTL_MINUTES));
    }

    @Override
    @Transactional
    public VnpayPaymentStatusResponse confirmTransfer(Long userId, String orderCode) {
        Order order = orderService.getMyOrderByCode(userId, orderCode);
        Payment payment = paymentRepository.findByOrderId(order.getId()).stream()
                .filter(item -> "VNPAY".equals(item.getMethod()))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy giao dịch thanh toán"));

        payment.setStatus("PAID");
        payment.setGatewayTransactionNo("MBBANK-" + System.currentTimeMillis());
        payment.setPaidAt(LocalDateTime.now(VIETNAM_ZONE));
        paymentRepository.save(payment);

        order.setStatus("CONFIRMED");
        order.setUpdatedAt(LocalDateTime.now(VIETNAM_ZONE));
        orderRepository.save(order);

        // Gửi email xác nhận thanh toán và chi tiết hóa đơn đến Gmail thật
        emailService.sendOrderPaymentConfirmation(order);

        return new VnpayPaymentStatusResponse(
                order.getOrderCode(),
                order.getStatus(),
                payment.getStatus(),
                payment.getAmount(),
                payment.getCreatedAt().plusMinutes(PAYMENT_TTL_MINUTES));
    }

    @Override
    @Transactional
    public String handleIpn(Map<String, String> parameters) {
        String transactionCode = parameters.get("vnp_TxnRef");
        String secureHash = parameters.get("vnp_SecureHash");
        if (transactionCode == null || secureHash == null || !isValidSignature(parameters, secureHash)) {
            return "97";
        }

        Payment payment = paymentRepository.findByTransactionCodeForUpdate(transactionCode).orElse(null);
        if (payment == null || !"VNPAY".equals(payment.getMethod())) {
            return "01";
        }
        if (!"PENDING".equals(payment.getStatus())) {
            return "02";
        }
        if (payment.getAmount().movePointRight(2).longValueExact() != parseLong(parameters.get("vnp_Amount"))) {
            return "04";
        }
        if (!transactionCode.equals(payment.getOrder().getOrderCode())
                || !"PENDING".equals(payment.getOrder().getStatus())) {
            return "02";
        }

        String responseCode = parameters.get("vnp_ResponseCode");
        String transactionStatus = parameters.get("vnp_TransactionStatus");
        LocalDateTime now = LocalDateTime.now(VIETNAM_ZONE);
        if ("00".equals(responseCode) && "00".equals(transactionStatus)) {
            String gatewayTransactionNo = parameters.get("vnp_TransactionNo");
            if (gatewayTransactionNo == null || gatewayTransactionNo.isBlank()) {
                return "04";
            }
            payment.setStatus("PAID");
            payment.setGatewayTransactionNo(gatewayTransactionNo);
            payment.setPaidAt(now);
            payment.getOrder().setStatus("CONFIRMED");

            // Gửi email xác nhận thanh toán đến Gmail khách hàng
            emailService.sendOrderPaymentConfirmation(payment.getOrder());
        } else {
            // Keep the order payable after a canceled or declined gateway attempt.
            payment.setStatus("PENDING");
            payment.setGatewayTransactionNo(parameters.get("vnp_TransactionNo"));
            payment.setCreatedAt(now);
        }
        payment.getOrder().setUpdatedAt(now);
        paymentRepository.save(payment);
        orderRepository.save(payment.getOrder());
        return "00";
    }

    @Scheduled(fixedDelayString = "${vnpay.expiration-scan-ms:60000}")
    @Transactional
    public void expirePendingPayments() {
        LocalDateTime expiredBefore = LocalDateTime.now(VIETNAM_ZONE).minusMinutes(PAYMENT_TTL_MINUTES);
        for (Payment payment : paymentRepository.findExpiredVnpayPayments(expiredBefore)) {
            if (!"PENDING".equals(payment.getStatus()) || !"PENDING".equals(payment.getOrder().getStatus())) {
                continue;
            }
            payment.setStatus("EXPIRED");
            payment.getOrder().setStatus("CANCELLED");
            payment.getOrder().setUpdatedAt(LocalDateTime.now());
            inventoryService.restoreOrderStock(payment.getOrder());
            paymentRepository.save(payment);
            orderRepository.save(payment.getOrder());
        }
    }

    private void requireConfiguration() {
        if (terminalCode.isBlank() || hashSecret.isBlank()) {
            throw new ServiceUnavailableException(
                    "VNPay chưa sẵn sàng: hãy cấu hình VNPAY_TMN_CODE và VNPAY_HASH_SECRET trong file .env.");
        }
    }

    private boolean isValidSignature(Map<String, String> parameters, String providedHash) {
        Map<String, String> signedParameters = new TreeMap<>(parameters);
        signedParameters.remove("vnp_SecureHash");
        signedParameters.remove("vnp_SecureHashType");
        String expectedHash = hmacSha512(hashSecret, encodeParameters(signedParameters));
        return MessageDigest.isEqual(
                expectedHash.getBytes(StandardCharsets.US_ASCII),
                providedHash.toLowerCase(java.util.Locale.ROOT).getBytes(StandardCharsets.US_ASCII));
    }

    private String encodeParameters(Map<String, String> parameters) {
        StringBuilder query = new StringBuilder();
        parameters.forEach((key, value) -> {
            if (value == null || value.isBlank()) return;
            if (query.length() > 0) query.append('&');
            query.append(URLEncoder.encode(key, StandardCharsets.UTF_8))
                    .append('=')
                    .append(URLEncoder.encode(value, StandardCharsets.UTF_8));
        });
        return query.toString();
    }

    private String hmacSha512(String key, String data) {
        try {
            Mac mac = Mac.getInstance("HmacSHA512");
            mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
            byte[] digest = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder(digest.length * 2);
            for (byte value : digest) hex.append(String.format("%02x", value));
            return hex.toString();
        } catch (java.security.GeneralSecurityException exception) {
            throw new IllegalStateException("Không thể ký yêu cầu VNPay.", exception);
        }
    }

    private String generateVietQrPayload(String bankBin, String accountNumber, long amount, String message) {
        // Tag 38: Merchant Account Information
        String guid = "0010A000000727";
        String benInfo = "0006" + bankBin + String.format("01%02d%s", accountNumber.length(), accountNumber);
        String benTag = String.format("01%02d%s", benInfo.length(), benInfo);
        String serviceCode = "0208QRIBFTTA";
        String tag38Content = guid + benTag + serviceCode;
        String tag38 = String.format("38%02d%s", tag38Content.length(), tag38Content);

        String tag00 = "000201";
        String tag01 = "010212";
        String tag53 = "5303704";
        String tag54 = amount > 0 ? String.format("54%02d%d", String.valueOf(amount).length(), amount) : "";
        String tag58 = "5802VN";
        String cleanMsg = (message != null ? message.replaceAll("[^a-zA-Z0-9-]", "") : "");
        String tag62 = !cleanMsg.isEmpty()
                ? String.format("62%02d08%02d%s", cleanMsg.length() + 4, cleanMsg.length(), cleanMsg)
                : "";

        String raw = tag00 + tag01 + tag38 + tag53 + tag54 + tag58 + tag62 + "6304";
        int crc = calculateCrc16(raw.getBytes(StandardCharsets.US_ASCII));
        return raw + String.format("%04X", crc);
    }

    private int calculateCrc16(byte[] bytes) {
        int crc = 0xFFFF;
        for (byte b : bytes) {
            crc ^= (b & 0xFF) << 8;
            for (int i = 0; i < 8; i++) {
                if ((crc & 0x8000) != 0) {
                    crc = (crc << 1) ^ 0x1021;
                } else {
                    crc <<= 1;
                }
                crc &= 0xFFFF;
            }
        }
        return crc;
    }

    private String createQrDataUrl(String content) {
        try {
            Map<EncodeHintType, Object> hints = new EnumMap<>(EncodeHintType.class);
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            hints.put(EncodeHintType.MARGIN, 2);
            BitMatrix matrix = new MultiFormatWriter().encode(content, BarcodeFormat.QR_CODE, 360, 360, hints);
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            MatrixToImageWriter.writeToStream(matrix, "PNG", output);
            return "data:image/png;base64," + Base64.getEncoder().encodeToString(output.toByteArray());
        } catch (Exception exception) {
            throw new IllegalStateException("Không thể tạo mã QR cho giao dịch.", exception);
        }
    }

    private long parseLong(String value) {
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException exception) {
            return -1;
        }
    }

    private String normalizeIp(String ip) {
        if (ip == null || ip.isBlank()) return "127.0.0.1";
        if ("0:0:0:0:0:0:0:1".equals(ip)) return "127.0.0.1";
        return ip.length() > 45 ? ip.substring(0, 45) : ip;
    }
}
