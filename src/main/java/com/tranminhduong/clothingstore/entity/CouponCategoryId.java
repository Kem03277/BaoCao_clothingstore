package com.tranminhduong.clothingstore.entity;

import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class CouponCategoryId implements Serializable {
    private static final long serialVersionUID = 1L;

    @Column(name = "coupon_id")
    private Long couponId;

    @Column(name = "category_id")
    private Long categoryId;
}
