package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.dto.CategoryRequest;

import java.util.List;

public interface CategoryService {
    List<Category> getAllCategories();

    List<Category> getDeletedCategories();

    Category getCategoryById(Long id);

    Category create(CategoryRequest request);

    Category update(Long id, CategoryRequest request);

    void delete(Long id);

    void restoreDeleted(Long id);

    void restoreAllDeleted();

    void deletePermanently(Long id);
}