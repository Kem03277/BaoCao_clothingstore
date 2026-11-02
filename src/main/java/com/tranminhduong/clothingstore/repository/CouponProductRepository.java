package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.CouponProduct;
import com.tranminhduong.clothingstore.entity.CouponProductId;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CouponProductRepository extends JpaRepository<CouponProduct, CouponProductId> {
    List<CouponProduct> findByCoupon_IdOrderByProduct_IdAsc(Long couponId);
    void deleteByCoupon_IdAndProduct_Id(Long couponId, Long productId);
    boolean existsByCoupon_IdAndProduct_Id(Long couponId, Long productId);
    void deleteByCoupon_Id(Long couponId);
}
