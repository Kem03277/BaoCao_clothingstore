package com.tranminhduong.clothingstore.mapper;

import com.tranminhduong.clothingstore.dto.BrandResponse;
import com.tranminhduong.clothingstore.entity.Brand;
import org.springframework.stereotype.Component;

@Component
public class BrandMapper {
    public BrandResponse toResponse(Brand brand) {
        if (brand == null) {
            return null;
        }
        return new BrandResponse(brand.getId(), brand.getBrandName(), brand.getLogoUrl(),
                brand.getDescription(), brand.getStatus());
    }
}