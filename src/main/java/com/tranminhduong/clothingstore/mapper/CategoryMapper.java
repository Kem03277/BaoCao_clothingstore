package com.tranminhduong.clothingstore.mapper;

import com.tranminhduong.clothingstore.dto.CategoryResponse;
import com.tranminhduong.clothingstore.entity.Category;
import org.springframework.stereotype.Component;

@Component
public class CategoryMapper {
    public CategoryResponse toResponse(Category category) {
        return new CategoryResponse(
                category.getId(),
                category.getName(),
                category.getDescription());
    }
}