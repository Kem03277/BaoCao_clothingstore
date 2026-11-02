package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.dto.CouponApplyResponse;
import com.tranminhduong.clothingstore.dto.CouponCartItem;
import com.tranminhduong.clothingstore.dto.CouponValidationRequest;
import com.tranminhduong.clothingstore.dto.CouponValidationResponse;
import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.entity.Coupon;
import com.tranminhduong.clothingstore.entity.CouponCategory;
import com.tranminhduong.clothingstore.entity.CouponCategoryId;
import com.tranminhduong.clothingstore.entity.CouponProduct;
import com.tranminhduong.clothingstore.entity.CouponProductId;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.mapper.CouponMapper;
import com.tranminhduong.clothingstore.repository.CategoryRepository;
import com.tranminhduong.clothingstore.repository.CouponCategoryRepository;
import com.tranminhduong.clothingstore.repository.CouponProductRepository;
import com.tranminhduong.clothingstore.repository.CouponRepository;
import com.tranminhduong.clothingstore.repository.ProductRepository;
import com.tranminhduong.clothingstore.service.CouponService;
import jakarta.persistence.EntityManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class CouponServiceImpl implements CouponService {

    private final CouponRepository couponRepository;
    private final CouponCategoryRepository couponCategoryRepository;
    private final CouponProductRepository couponProductRepository;
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final EntityManager entityManager;
    private final CouponMapper couponMapper;

    public CouponServiceImpl(
            CouponRepository couponRepository,
            CouponCategoryRepository couponCategoryRepository,
            CouponProductRepository couponProductRepository,
            CategoryRepository categoryRepository,
            ProductRepository productRepository,
            EntityManager entityManager,
            CouponMapper couponMapper) {
        this.couponRepository = couponRepository;
        this.couponCategoryRepository = couponCategoryRepository;
        this.couponProductRepository = couponProductRepository;
        this.categoryRepository = categoryRepository;
        this.productRepository = productRepository;
        this.entityManager = entityManager;
        this.couponMapper = couponMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Coupon> getAllCoupons() {
        return couponRepository.findAllNotDeleted();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Coupon> getDeletedCoupons() {
        return couponRepository.findDeletedCoupons();
    }

    @Override
    @Transactional(readOnly = true)
    public Coupon getCouponById(Long id) {
        return couponRepository.findActiveById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy mã giảm giá có id = " + id));
    }

    @Override
    @Transactional
    public Coupon createCoupon(Coupon coupon) {
        validateCoupon(coupon);
        if (couponRepository.existsByCodeIgnoreCase(coupon.getCode().trim())) {
            throw new BadRequestException("Mã giảm giá đã tồn tại");
        }
        coupon.setId(null);
        coupon.setCode(coupon.getCode().trim());
        coupon.setDiscountType("PERCENTAGE");
        return couponRepository.save(coupon);
    }

    @Override
    @Transactional
    public Coupon updateCoupon(Long id, Coupon updatedCoupon) {
        validateCoupon(updatedCoupon);
        Coupon coupon = getCouponById(id);
        if (couponRepository.existsByCodeIgnoreCaseAndIdNot(updatedCoupon.getCode().trim(), id)) {
            throw new BadRequestException("Mã giảm giá đã tồn tại");
        }
        coupon.setCode(updatedCoupon.getCode().trim());
        coupon.setName(updatedCoupon.getName().trim());
        coupon.setDiscountType("PERCENTAGE");
        coupon.setDiscountValue(updatedCoupon.getDiscountValue());
        coupon.setApplyScope(updatedCoupon.getApplyScope());
        coupon.setMinOrderAmount(updatedCoupon.getMinOrderAmount());
        coupon.setMaxDiscount(updatedCoupon.getMaxDiscount());
        coupon.setStartAt(updatedCoupon.getStartAt());
        coupon.setEndAt(updatedCoupon.getEndAt());
        coupon.setStatus(updatedCoupon.getStatus());
        return coupon;
    }

    @Override
    @Transactional
    public Coupon updateStatus(Long id, Boolean status) {
        if (status == null) {
            throw new BadRequestException("Trạng thái mã giảm giá không được để trống");
        }
        Coupon coupon = getCouponById(id);
        if (status && coupon.getEndAt() != null && !coupon.getEndAt().isAfter(LocalDateTime.now())) {
            throw new BadRequestException("Không thể kích hoạt mã giảm giá đã hết hạn");
        }
        coupon.setStatus(status);
        return coupon;
    }

    @Override
    @Transactional(readOnly = true)
    public CouponValidationResponse validateForCart(CouponValidationRequest request) {
        if (request == null || request.code() == null || request.code().isBlank()) {
            throw new BadRequestException("Vui lòng nhập mã giảm giá");
        }
        if (request.items() == null || request.items().isEmpty()
                || request.items().stream().anyMatch(item -> item == null
                        || item.productId() == null || item.quantity() <= 0)) {
            throw new BadRequestException("Giỏ hàng không hợp lệ");
        }

        String normalizedCode = request.code().trim();
        if ("WELCOM10".equalsIgnoreCase(normalizedCode)) {
            normalizedCode = "WELCOME10";
        }
        Coupon coupon = couponRepository.findByCodeIgnoreCaseAndDeletedFalse(normalizedCode)
                .orElseThrow(() -> new BadRequestException("Mã không hợp lệ hoặc đã hết hạn"));
        LocalDateTime now = LocalDateTime.now();
        if (!Boolean.TRUE.equals(coupon.getStatus())
                || (coupon.getStartAt() != null && now.isBefore(coupon.getStartAt()))
                || (coupon.getEndAt() != null && !now.isBefore(coupon.getEndAt()))) {
            throw new BadRequestException("Mã không hợp lệ hoặc đã hết hạn");
        }
        if (!"PERCENT".equalsIgnoreCase(coupon.getDiscountType())
                && !"PERCENTAGE".equalsIgnoreCase(coupon.getDiscountType())) {
            throw new BadRequestException("Mã giảm giá này không hỗ trợ giảm theo phần trăm");
        }
        if (coupon.getDiscountValue() == null
                || coupon.getDiscountValue().signum() <= 0
                || coupon.getDiscountValue().compareTo(new BigDecimal("100")) > 0) {
            throw new BadRequestException("Mức giảm phần trăm của mã không hợp lệ");
        }

        Map<Long, Product> productsById = productRepository.findAllById(
                        request.items().stream().map(CouponCartItem::productId).distinct().toList())
                .stream()
                .collect(Collectors.toMap(Product::getId, product -> product));
        if (request.items().stream().anyMatch(item -> !productsById.containsKey(item.productId()))) {
            throw new BadRequestException("Một hoặc nhiều sản phẩm trong giỏ không còn tồn tại");
        }

        BigDecimal orderSubtotal = BigDecimal.ZERO;
        for (CouponCartItem item : request.items()) {
            orderSubtotal = orderSubtotal.add(
                    BigDecimal.valueOf(productsById.get(item.productId()).getPrice())
                            .multiply(BigDecimal.valueOf(item.quantity())));
        }
        if (coupon.getMinOrderAmount() != null && orderSubtotal.compareTo(coupon.getMinOrderAmount()) < 0) {
            throw new BadRequestException(
                    "Đơn hàng tối thiểu từ " + coupon.getMinOrderAmount().stripTrailingZeros().toPlainString() + " ₫");
        }

        Set<Long> eligibleIds = switch (coupon.getApplyScope() == null
                ? "" : coupon.getApplyScope().trim().toUpperCase()) {
            case "ALL" -> productsById.keySet();
            case "PRODUCT" -> couponProductRepository.findByCoupon_IdOrderByProduct_IdAsc(coupon.getId()).stream()
                    .map(link -> link.getProduct().getId())
                    .collect(Collectors.toSet());
            case "CATEGORY" -> {
                Set<Long> categoryIds = couponCategoryRepository
                        .findByCoupon_IdOrderByCategory_IdAsc(coupon.getId()).stream()
                        .map(link -> link.getCategory().getId())
                        .collect(Collectors.toSet());
                yield productsById.values().stream()
                        .filter(product -> product.getCategory() != null
                                && categoryIds.contains(product.getCategory().getId()))
                        .map(Product::getId)
                        .collect(Collectors.toSet());
            }
            default -> throw new BadRequestException("Phạm vi áp dụng mã giảm giá không hợp lệ");
        };

        BigDecimal eligibleSubtotal = BigDecimal.ZERO;
        for (CouponCartItem item : request.items()) {
            if (eligibleIds.contains(item.productId())) {
                eligibleSubtotal = eligibleSubtotal.add(
                        BigDecimal.valueOf(productsById.get(item.productId()).getPrice())
                                .multiply(BigDecimal.valueOf(item.quantity())));
            }
        }
        if (eligibleSubtotal.signum() == 0) {
            throw new BadRequestException("Mã giảm giá không áp dụng cho sản phẩm trong giỏ hàng");
        }

        BigDecimal discountAmount = eligibleSubtotal
                .multiply(coupon.getDiscountValue())
                .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);
        if (coupon.getMaxDiscount() != null) {
            discountAmount = discountAmount.min(coupon.getMaxDiscount());
        }
        return new CouponValidationResponse(
                couponMapper.toResponse(coupon),
                eligibleSubtotal,
                discountAmount,
                eligibleIds.stream().sorted().toList());
    }

    @Override
    @Transactional
    public void deleteCoupon(Long id) {
        Coupon coupon = getCouponById(id);
        coupon.setDeleted(true);
    }

    @Override
    @Transactional
    public void restoreDeletedCoupon(Long id) {
        Coupon coupon = couponRepository.findDeletedById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy mã giảm giá trong thùng rác có id = " + id));
        coupon.setDeleted(false);
    }

    @Override
    @Transactional
    public void restoreAllDeletedCoupons() {
        couponRepository.findDeletedCoupons().forEach(coupon -> coupon.setDeleted(false));
    }

    @Override
    @Transactional
    public void deleteCouponPermanently(Long id) {
        Coupon coupon = couponRepository.findDeletedById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy mã giảm giá trong thùng rác có id = " + id));
        if (!coupon.getOrders().isEmpty()) {
            throw new BadRequestException("Không thể xóa vĩnh viễn mã giảm giá đã được sử dụng cho đơn hàng");
        }
        couponCategoryRepository.deleteByCoupon_Id(id);
        couponProductRepository.deleteByCoupon_Id(id);
        couponRepository.delete(coupon);
    }

    @Override
    @Transactional
    public void addCategory(Long couponId, Long categoryId) {
        Coupon coupon = getCouponById(couponId);
        if (categoryId == null || !categoryRepository.existsById(categoryId)) {
            throw new ResourceNotFoundException("Không tìm thấy danh mục có id = " + categoryId);
        }
        if (couponCategoryRepository.existsByCoupon_IdAndCategory_Id(couponId, categoryId)) {
            throw new BadRequestException("Danh mục đã được áp dụng cho mã giảm giá");
        }
        CouponCategory link = new CouponCategory();
        link.setId(new CouponCategoryId(couponId, categoryId));
        link.setCoupon(coupon);
        link.setCategory(entityManager.getReference(Category.class, categoryId));
        couponCategoryRepository.save(link);
    }

    @Override
    @Transactional
    public void removeCategory(Long couponId, Long categoryId) {
        getCouponById(couponId);
        if (!couponCategoryRepository.existsByCoupon_IdAndCategory_Id(couponId, categoryId)) {
            throw new ResourceNotFoundException("Không tìm thấy danh mục áp dụng cho mã giảm giá");
        }
        couponCategoryRepository.deleteByCoupon_IdAndCategory_Id(couponId, categoryId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CouponApplyResponse> getCategories(Long couponId) {
        getCouponById(couponId);
        return couponCategoryRepository.findByCoupon_IdOrderByCategory_IdAsc(couponId).stream()
                .map(link -> new CouponApplyResponse(
                        link.getCategory().getId(), link.getCategory().getName()))
                .toList();
    }

    @Override
    @Transactional
    public void addProduct(Long couponId, Long productId) {
        Coupon coupon = getCouponById(couponId);
        if (productId == null || !productRepository.existsById(productId)) {
            throw new ResourceNotFoundException("Không tìm thấy sản phẩm có id = " + productId);
        }
        if (couponProductRepository.existsByCoupon_IdAndProduct_Id(couponId, productId)) {
            throw new BadRequestException("Sản phẩm đã được áp dụng cho mã giảm giá");
        }
        CouponProduct link = new CouponProduct();
        link.setId(new CouponProductId(couponId, productId));
        link.setCoupon(coupon);
        link.setProduct(entityManager.getReference(Product.class, productId));
        couponProductRepository.save(link);
    }

    @Override
    @Transactional
    public void removeProduct(Long couponId, Long productId) {
        getCouponById(couponId);
        if (!couponProductRepository.existsByCoupon_IdAndProduct_Id(couponId, productId)) {
            throw new ResourceNotFoundException("Không tìm thấy sản phẩm áp dụng cho mã giảm giá");
        }
        couponProductRepository.deleteByCoupon_IdAndProduct_Id(couponId, productId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CouponApplyResponse> getProducts(Long couponId) {
        getCouponById(couponId);
        return couponProductRepository.findByCoupon_IdOrderByProduct_IdAsc(couponId).stream()
                .map(link -> new CouponApplyResponse(
                        link.getProduct().getId(), link.getProduct().getName()))
                .toList();
    }

    private void validateCoupon(Coupon coupon) {
        if (coupon == null || coupon.getCode() == null || coupon.getCode().isBlank()) {
            throw new BadRequestException("Mã giảm giá không được để trống");
        }
        if (coupon.getName() == null || coupon.getName().isBlank()) {
            throw new BadRequestException("Tên mã giảm giá không được để trống");
        }
        if (coupon.getDiscountType() == null
                || !(coupon.getDiscountType().equalsIgnoreCase("PERCENT")
                        || coupon.getDiscountType().equalsIgnoreCase("PERCENTAGE"))) {
            throw new BadRequestException("Mã giảm giá chỉ hỗ trợ giảm theo phần trăm");
        }
        if (coupon.getApplyScope() == null || coupon.getApplyScope().isBlank()) {
            throw new BadRequestException("Phạm vi áp dụng không được để trống");
        }
        if (coupon.getDiscountValue() == null || coupon.getDiscountValue().signum() < 0
                || coupon.getDiscountValue().signum() == 0
                || coupon.getDiscountValue().compareTo(new java.math.BigDecimal("100")) > 0
                || (coupon.getMinOrderAmount() != null && coupon.getMinOrderAmount().signum() < 0)
                || (coupon.getMaxDiscount() != null && coupon.getMaxDiscount().signum() < 0)) {
            throw new BadRequestException("Giá trị giảm giá không hợp lệ");
        }
        if (coupon.getStartAt() != null && coupon.getEndAt() != null
                && coupon.getStartAt().isAfter(coupon.getEndAt())) {
            throw new BadRequestException("Thời điểm bắt đầu không được sau thời điểm kết thúc");
        }
    }
}
