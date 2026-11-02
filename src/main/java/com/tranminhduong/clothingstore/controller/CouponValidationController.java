package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.CouponValidationRequest;
import com.tranminhduong.clothingstore.dto.CouponValidationResponse;
import com.tranminhduong.clothingstore.service.CouponService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/coupons")
public class CouponValidationController {

    private final CouponService couponService;

    public CouponValidationController(CouponService couponService) {
        this.couponService = couponService;
    }

    @PostMapping("/validate")
    public ResponseEntity<CouponValidationResponse> validate(
            @RequestBody(required = false) CouponValidationRequest request) {
        return ResponseEntity.ok(couponService.validateForCart(request));
    }
}
