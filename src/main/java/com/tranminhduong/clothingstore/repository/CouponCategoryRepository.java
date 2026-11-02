package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.CouponCategory;
import com.tranminhduong.clothingstore.entity.CouponCategoryId;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CouponCategoryRepository extends JpaRepository<CouponCategory, CouponCategoryId> {
    List<CouponCategory> findByCoupon_IdOrderByCategory_IdAsc(Long couponId);
    void deleteByCoupon_IdAndCategory_Id(Long couponId, Long categoryId);
    void deleteByCoupon_Id(Long couponId);
    boolean existsByCoupon_IdAndCategory_Id(Long couponId, Long categoryId);
}
