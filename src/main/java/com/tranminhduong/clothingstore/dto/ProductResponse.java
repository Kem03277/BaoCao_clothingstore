package com.tranminhduong.clothingstore.dto;

import com.tranminhduong.clothingstore.entity.Gender;
import java.util.List;

public record ProductResponse(
        Long id,
        String name,
        String tag,
        String description,
        Double price,
        Integer quantity,
        Long categoryId,
        Long brandId,
        String mainImageUrl,
        List<String> additionalImageUrls,
        Gender gender) {
}