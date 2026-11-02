package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Coupon;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.List;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CouponRepository extends JpaRepository<Coupon, Long> {
    @Query("SELECT coupon FROM Coupon coupon WHERE COALESCE(coupon.deleted, false) = false")
    List<Coupon> findAllNotDeleted();

    @Query("SELECT coupon FROM Coupon coupon WHERE coupon.deleted = true")
    List<Coupon> findDeletedCoupons();

    @Query("SELECT coupon FROM Coupon coupon WHERE coupon.id = :id AND COALESCE(coupon.deleted, false) = false")
    Optional<Coupon> findActiveById(@Param("id") Long id);

    @Query("SELECT coupon FROM Coupon coupon WHERE coupon.id = :id AND coupon.deleted = true")
    Optional<Coupon> findDeletedById(@Param("id") Long id);

    Optional<Coupon> findByCodeIgnoreCaseAndDeletedFalse(String code);

    boolean existsByCodeIgnoreCase(String code);
    boolean existsByCodeIgnoreCaseAndIdNot(String code, Long id);
}
