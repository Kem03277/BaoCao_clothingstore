package com.tranminhduong.clothingstore.dto;

import com.tranminhduong.clothingstore.entity.Gender;

public record ProductRequest(
        String name,
        String description,
        Double price,
        Integer quantity,
        Long categoryId,
        Long brandId,
        Gender gender,
        String tag,
        String imageUrl) {

    public ProductRequest(
            String name,
            String description,
            Double price,
            Integer quantity,
            Long categoryId,
            Long brandId) {
        this(name, description, price, quantity, categoryId, brandId, Gender.UNISEX, null, null);
    }
}
