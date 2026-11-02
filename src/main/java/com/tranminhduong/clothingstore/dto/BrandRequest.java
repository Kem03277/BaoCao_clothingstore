package com.tranminhduong.clothingstore.dto;

public record BrandRequest(
        String brandName,
        String logoUrl,
        String description,
        Boolean status) {
}
