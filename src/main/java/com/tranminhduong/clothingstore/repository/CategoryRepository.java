package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Category;

import java.util.List;

public interface CategoryRepository {

    List<Category> findAll();

    List<Category> findDeleted();

    boolean existsById(Long id);

    Category findById(Long id);

    Category findDeletedById(Long id);

    boolean existsByNameIgnoreCase(String name);

    boolean existsByNameIgnoreCaseAndIdNot(String name, Long id);

    Category save(Category category);

    void deleteById(Long id);

    void setDeleted(Long id, boolean deleted);

    long countProductsById(Long id);
}