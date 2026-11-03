package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.dto.UserOrderRequest;
import com.tranminhduong.clothingstore.dto.CouponCartItem;
import com.tranminhduong.clothingstore.dto.CouponValidationRequest;
import com.tranminhduong.clothingstore.dto.CouponValidationResponse;
import com.tranminhduong.clothingstore.entity.Address;
import com.tranminhduong.clothingstore.entity.Coupon;
import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.entity.OrderItem;
import com.tranminhduong.clothingstore.entity.Payment;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.repository.AddressRepository;
import com.tranminhduong.clothingstore.repository.CouponRepository;
import com.tranminhduong.clothingstore.repository.CustomerRepository;
import com.tranminhduong.clothingstore.repository.OrderRepository;
import com.tranminhduong.clothingstore.repository.PaymentRepository;
import com.tranminhduong.clothingstore.repository.ProductRepository;
import com.tranminhduong.clothingstore.service.OrderService;
import com.tranminhduong.clothingstore.service.CouponService;
import com.tranminhduong.clothingstore.service.EmailService;
import com.tranminhduong.clothingstore.service.InventoryService;
import com.tranminhduong.clothingstore.service.StoreInformationService;
import org.springframework.stereotype.Service;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.UUID;

@Service
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;
    private final CustomerRepository customerRepository;
    private final AddressRepository addressRepository;
    private final ProductRepository productRepository;
    private final CouponRepository couponRepository;
    private final CouponService couponService;
    private final StoreInformationService storeInformationService;
    private final InventoryService inventoryService;
    private final PaymentRepository paymentRepository;
    private final EmailService emailService;

    public OrderServiceImpl(
            OrderRepository orderRepository,
            CustomerRepository customerRepository,
            AddressRepository addressRepository,
            ProductRepository productRepository,
            CouponRepository couponRepository,
            CouponService couponService,
            StoreInformationService storeInformationService,
            InventoryService inventoryService,
            PaymentRepository paymentRepository,
            EmailService emailService) {
        this.orderRepository = orderRepository;
        this.customerRepository = customerRepository;
        this.addressRepository = addressRepository;
        this.productRepository = productRepository;
        this.couponRepository = couponRepository;
        this.couponService = couponService;
        this.storeInformationService = storeInformationService;
        this.inventoryService = inventoryService;
        this.paymentRepository = paymentRepository;
        this.emailService = emailService;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> getOrders(String status, LocalDate from, LocalDate to) {
        validateDateRange(from, to);
        LocalDateTime start = from == null ? null : from.atStartOfDay();
        LocalDateTime until = to == null ? null : to.plusDays(1).atStartOfDay();
        String filterStatus = normalizeStatus(status);
        return orderRepository.searchOrders(filterStatus, start, until);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Order> getOrders(String status, LocalDate from, LocalDate to, Pageable pageable) {
        validateDateRange(from, to);
        LocalDateTime start = from == null ? null : from.atStartOfDay();
        LocalDateTime until = to == null ? null : to.plusDays(1).atStartOfDay();
        String filterStatus = normalizeStatus(status);
        return orderRepository.searchOrdersPage(filterStatus, start, until, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public Order getOrderById(Long id) {
        return orderRepository.findDetailsById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy đơn hàng có id = " + id));
    }

    @Override
    @Transactional
    public Order updateOrderStatus(Long id, String status) {
        String normalizedStatus = normalizeStatus(status);
        validateStatus(normalizedStatus);
        Order order = getOrderById(id);
        order.setStatus(normalizedStatus);
        order.setUpdatedAt(LocalDateTime.now());
        return order;
    }

    @Override
    @Transactional
    public Order cancelOrder(Long id) {
        Order order = getOrderById(id);
        String status = normalizeStatus(order.getStatus());
        if (!Set.of("NEW", "PENDING", "CONFIRMED").contains(status)) {
            throw new BadRequestException("Chỉ có thể hủy đơn hàng ở trạng thái NEW, PENDING hoặc CONFIRMED");
        }
        order.setStatus("CANCELLED");
        order.setUpdatedAt(LocalDateTime.now());
        return order;
    }

    // ── User-facing ──

    @Override
    @Transactional
    public Order placeOrder(Long userId, UserOrderRequest request) {
        if (request == null || request.items() == null || request.items().isEmpty()) {
            throw new BadRequestException("Giỏ hàng không được trống");
        }

        User user = customerRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy người dùng"));

        Address address = addressRepository.findById(request.addressId())
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy địa chỉ giao hàng"));

        // Build order
        Order order = new Order();
        order.setUser(user);
        order.setOrderCode("ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        order.setRecipientName(address.getRecipientName());
        order.setRecipientPhone(address.getPhone());
        order.setShippingAddress(address.getAddressLine() + ", " + address.getProvince());
        String paymentMethod = request.paymentMethod() == null ? "COD"
                : request.paymentMethod().trim().toUpperCase(Locale.ROOT);
        if (!Set.of("COD", "VNPAY").contains(paymentMethod)) {
            throw new BadRequestException("Phương thức thanh toán không hợp lệ");
        }
        order.setStatus("VNPAY".equals(paymentMethod) ? "PENDING" : "NEW");
        order.setNote(request.note());
        order.setCreatedAt(LocalDateTime.now());
        order.setUpdatedAt(LocalDateTime.now());

        BigDecimal subtotal = BigDecimal.ZERO;
        Map<Long, Long> quantitiesToReserve = new TreeMap<>();

        // Order items
        for (UserOrderRequest.OrderItemRequest item : request.items()) {
            if (item.quantity() <= 0) {
                throw new BadRequestException("Số lượng sản phẩm phải lớn hơn 0");
            }
            Product product = productRepository.findById(item.productId())
                    .orElseThrow(() -> new ResourceNotFoundException("Sản phẩm không tồn tại: " + item.productId()));
            long totalQuantity = quantitiesToReserve.getOrDefault(product.getId(), 0L) + item.quantity();
            if (totalQuantity > Integer.MAX_VALUE) {
                throw new BadRequestException("Tổng số lượng sản phẩm vượt quá giới hạn cho phép");
            }
            quantitiesToReserve.put(product.getId(), totalQuantity);

            BigDecimal unitPrice = BigDecimal.valueOf(product.getPrice());
            BigDecimal lineTotal = unitPrice.multiply(BigDecimal.valueOf(item.quantity()));
            subtotal = subtotal.add(lineTotal);

            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setProduct(product);
            orderItem.setProductName(product.getName());
            orderItem.setSizeName(item.size());
            orderItem.setQuantity(item.quantity());
            orderItem.setUnitPrice(unitPrice);
            orderItem.setLineTotal(lineTotal);
            order.getOrderItems().add(orderItem);
        }

        // Coupon discount
        BigDecimal discountAmount = BigDecimal.ZERO;
        if (request.couponCode() != null && !request.couponCode().isBlank()) {
            CouponValidationResponse validation = couponService.validateForCart(
                    new CouponValidationRequest(
                            request.couponCode(),
                            request.items().stream()
                                    .map(item -> new CouponCartItem(item.productId(), item.quantity()))
                                    .toList()));
            Coupon coupon = couponRepository.findById(validation.coupon().id())
                    .orElseThrow(() -> new ResourceNotFoundException("Mã giảm giá không tồn tại"));
            discountAmount = validation.discountAmount();
            order.setCoupon(coupon);
        }

        BigDecimal shippingFee = storeInformationService.calculateShippingFee(subtotal);
        BigDecimal totalAmount = subtotal.subtract(discountAmount).add(shippingFee);
        if (totalAmount.compareTo(BigDecimal.ZERO) < 0)
            totalAmount = BigDecimal.ZERO;

        order.setSubtotal(subtotal);
        order.setDiscountAmount(discountAmount);
        order.setShippingFee(shippingFee);
        order.setTotalAmount(totalAmount);

        Order savedOrder = orderRepository.save(order);
        if ("VNPAY".equals(paymentMethod)) {
            Payment payment = new Payment();
            payment.setOrder(savedOrder);
            payment.setMethod("VNPAY");
            payment.setAmount(totalAmount);
            payment.setTransactionCode(savedOrder.getOrderCode());
            payment.setStatus("PENDING");
            payment.setCreatedAt(LocalDateTime.now());
            paymentRepository.save(payment);
        } else {
            // Đơn hàng COD: Gửi thông báo đơn hàng mới qua email ngay khi tạo thành công
            emailService.sendOrderPaymentConfirmation(savedOrder);
        }
        for (Map.Entry<Long, Long> entry : quantitiesToReserve.entrySet()) {
            inventoryService.recordOrderSale(
                    entry.getKey(), entry.getValue().intValue(), savedOrder, user);
        }
        return savedOrder;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Order> getMyOrders(Long userId) {
        return orderRepository.findByUserId(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public Order getMyOrderById(Long userId, Long orderId) {
        return orderRepository.findDetailsByIdAndUserId(orderId, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy đơn hàng"));
    }

    @Override
    @Transactional(readOnly = true)
    public Order getMyOrderByCode(Long userId, String orderCode) {
        return orderRepository.findDetailsByOrderCodeAndUserId(orderCode, userId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy đơn hàng"));
    }

    @Override
    @Transactional
    public Order cancelMyOrder(Long userId, Long orderId) {
        Order order = getMyOrderById(userId, orderId);
        String status = normalizeStatus(order.getStatus());
        if (!Set.of("NEW", "CONFIRMED").contains(status)) {
            throw new BadRequestException("Chỉ có thể hủy đơn hàng ở trạng thái chờ xác nhận hoặc đã xác nhận");
        }
        order.setStatus("CANCELLED");
        order.setUpdatedAt(LocalDateTime.now());
        return orderRepository.save(order);
    }

    // ── helpers ──

    private void validateDateRange(LocalDate from, LocalDate to) {
        if (from != null && to != null && from.isAfter(to)) {
            throw new BadRequestException("Ngày bắt đầu không được sau ngày kết thúc");
        }
    }

    private String normalizeStatus(String status) {
        if (status == null)
            return null;
        String normalized = status.trim();
        if (normalized.isBlank())
            return null;
        return normalized.toUpperCase(Locale.ROOT);
    }

    private void validateStatus(String status) {
        if (status == null || !Set.of(
                "NEW", "PENDING", "CONFIRMED", "PROCESSING",
                "SHIPPING", "SHIPPED", "DELIVERED", "CANCELLED").contains(status)) {
            throw new BadRequestException("Trạng thái đơn hàng không hợp lệ");
        }
    }
}
