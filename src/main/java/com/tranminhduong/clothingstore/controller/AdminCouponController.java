package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.CouponApplyResponse;
import com.tranminhduong.clothingstore.dto.CouponRequest;
import com.tranminhduong.clothingstore.dto.CouponResponse;
import com.tranminhduong.clothingstore.dto.CouponStatusRequest;
import com.tranminhduong.clothingstore.dto.CouponTargetRequest;
import com.tranminhduong.clothingstore.mapper.CouponMapper;
import com.tranminhduong.clothingstore.service.CouponService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/coupons")
public class AdminCouponController {

    private final CouponService couponService;
    private final CouponMapper couponMapper;

    public AdminCouponController(CouponService couponService, CouponMapper couponMapper) {
        this.couponService = couponService;
        this.couponMapper = couponMapper;
    }

    // Chức năng: danh sách mã giảm giá. Ví dụ: GET /api/admin/coupons
    @GetMapping
    public ResponseEntity<List<CouponResponse>> getCoupons() {
        return ResponseEntity.ok(couponService.getAllCoupons().stream()
                .map(couponMapper::toResponse)
                .toList());
    }

    @GetMapping("/trash")
    public ResponseEntity<List<CouponResponse>> getDeletedCoupons() {
        return ResponseEntity.ok(couponService.getDeletedCoupons().stream()
                .map(couponMapper::toResponse)
                .toList());
    }

    @PostMapping("/trash/{id}/restore")
    public ResponseEntity<Void> restoreDeletedCoupon(@PathVariable("id") Long id) {
        couponService.restoreDeletedCoupon(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/trash/restore-all")
    public ResponseEntity<Void> restoreAllDeletedCoupons() {
        couponService.restoreAllDeletedCoupons();
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/trash/{id}")
    public ResponseEntity<Void> deleteCouponPermanently(@PathVariable("id") Long id) {
        couponService.deleteCouponPermanently(id);
        return ResponseEntity.noContent().build();
    }

    // Chức năng: chi tiết mã giảm giá. Ví dụ: GET /api/admin/coupons/1
    @GetMapping("/{id}")
    public ResponseEntity<CouponResponse> getCoupon(@PathVariable("id") Long id) {
        return ResponseEntity.ok(couponMapper.toResponse(couponService.getCouponById(id)));
    }

    // Chức năng: tạo mã giảm giá. Ví dụ: POST /api/admin/coupons
    @PostMapping
    public ResponseEntity<CouponResponse> createCoupon(
            @RequestBody(required = false) CouponRequest request) {
        return ResponseEntity.ok(couponMapper.toResponse(
                couponService.createCoupon(couponMapper.toEntity(request))));
    }

    // Chức năng: sửa mã giảm giá. Ví dụ: PUT /api/admin/coupons/1
    @PutMapping("/{id}")
    public ResponseEntity<CouponResponse> updateCoupon(
            @PathVariable("id") Long id,
            @RequestBody(required = false) CouponRequest request) {
        return ResponseEntity.ok(couponMapper.toResponse(
                couponService.updateCoupon(id, couponMapper.toEntity(request))));
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<CouponResponse> updateCouponStatus(
            @PathVariable("id") Long id,
            @RequestBody(required = false) CouponStatusRequest request) {
        return ResponseEntity.ok(couponMapper.toResponse(
                couponService.updateStatus(id, request == null ? null : request.status())));
    }

    // Chức năng: xóa mã giảm giá. Ví dụ: DELETE /api/admin/coupons/1
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCoupon(@PathVariable("id") Long id) {
        couponService.deleteCoupon(id);
        return ResponseEntity.noContent().build();
    }

    // Chức năng: danh mục áp dụng. Ví dụ: GET /api/admin/coupons/1/categories
    @GetMapping("/{id}/categories")
    public ResponseEntity<List<CouponApplyResponse>> getCategories(@PathVariable("id") Long id) {
        return ResponseEntity.ok(couponService.getCategories(id));
    }

    // Chức năng: thêm danh mục áp dụng. Ví dụ: POST /api/admin/coupons/1/categories
    @PostMapping("/{id}/categories")
    public ResponseEntity<Void> addCategory(
            @PathVariable("id") Long id,
            @RequestBody(required = false) CouponTargetRequest request) {
        couponService.addCategory(id, request == null ? null : request.targetId());
        return ResponseEntity.noContent().build();
    }

    // Chức năng: xóa danh mục áp dụng. Ví dụ: DELETE /api/admin/coupons/1/categories/2
    @DeleteMapping("/{id}/categories/{categoryId}")
    public ResponseEntity<Void> removeCategory(
            @PathVariable("id") Long id,
            @PathVariable("categoryId") Long categoryId) {
        couponService.removeCategory(id, categoryId);
        return ResponseEntity.noContent().build();
    }

    // Chức năng: sản phẩm áp dụng. Ví dụ: GET /api/admin/coupons/1/products
    @GetMapping("/{id}/products")
    public ResponseEntity<List<CouponApplyResponse>> getProducts(@PathVariable("id") Long id) {
        return ResponseEntity.ok(couponService.getProducts(id));
    }

    // Chức năng: thêm sản phẩm áp dụng. Ví dụ: POST /api/admin/coupons/1/products
    @PostMapping("/{id}/products")
    public ResponseEntity<Void> addProduct(
            @PathVariable("id") Long id,
            @RequestBody(required = false) CouponTargetRequest request) {
        couponService.addProduct(id, request == null ? null : request.targetId());
        return ResponseEntity.noContent().build();
    }

    // Chức năng: xóa sản phẩm áp dụng. Ví dụ: DELETE /api/admin/coupons/1/products/2
    @DeleteMapping("/{id}/products/{productId}")
    public ResponseEntity<Void> removeProduct(
            @PathVariable("id") Long id,
            @PathVariable("productId") Long productId) {
        couponService.removeProduct(id, productId);
        return ResponseEntity.noContent().build();
    }
}
