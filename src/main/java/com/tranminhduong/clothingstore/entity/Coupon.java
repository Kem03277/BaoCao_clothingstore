package com.tranminhduong.clothingstore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/** Ánh xạ bảng coupons trong ERD. */
@Entity
@Table(name = "coupons")
@Getter
@Setter
@NoArgsConstructor
public class Coupon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "coupon_id")
    private Long id;

    @Column(name = "code", length = 30)
    private String code;

    @Column(name = "name", length = 200)
    private String name;

    @Column(name = "discount_type", length = 20)
    private String discountType;

    @Column(name = "discount_value", precision = 12, scale = 2)
    private BigDecimal discountValue;

    @Column(name = "apply_scope", length = 20)
    private String applyScope;

    @Column(name = "min_order_amount", precision = 12, scale = 2)
    private BigDecimal minOrderAmount;

    @Column(name = "max_discount", precision = 12, scale = 2)
    private BigDecimal maxDiscount;

    @Column(name = "start_at")
    private LocalDateTime startAt;

    @Column(name = "end_at")
    private LocalDateTime endAt;

    @Column(name = "status")
    private Boolean status = true;

    @Column(name = "deleted")
    private Boolean deleted = false;

    @OneToMany(mappedBy = "coupon")
    @JsonIgnore
    private List<Order> orders = new ArrayList<>();

    @OneToMany(mappedBy = "coupon")
    @JsonIgnore
    private List<CouponCategory> couponCategories = new ArrayList<>();

    @OneToMany(mappedBy = "coupon")
    @JsonIgnore
    private List<CouponProduct> couponProducts = new ArrayList<>();

}
