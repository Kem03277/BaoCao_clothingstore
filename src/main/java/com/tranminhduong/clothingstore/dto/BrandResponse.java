package com.tranminhduong.clothingstore.dto;

public record BrandResponse(
        Long id,
        String brandName,
        String name,
        String logoUrl,
        String description,
        Boolean status) {

    public BrandResponse(Long id, String brandName, String logoUrl, String description, Boolean status) {
        this(id, brandName, brandName, logoUrl, description, status);
    }
}
