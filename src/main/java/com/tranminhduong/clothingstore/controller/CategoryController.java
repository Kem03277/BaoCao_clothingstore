package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.CategoryResponse;
import com.tranminhduong.clothingstore.dto.CategoryRequest;
import com.tranminhduong.clothingstore.dto.ProductResponse;
import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.mapper.CategoryMapper;
import com.tranminhduong.clothingstore.mapper.ProductMapper;
import com.tranminhduong.clothingstore.service.CategoryService;
import com.tranminhduong.clothingstore.service.ProductService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final CategoryService categoryService;
    private final CategoryMapper categoryMapper;
    private final ProductService productService;
    private final ProductMapper productMapper;

    public CategoryController(CategoryService categoryService, CategoryMapper categoryMapper,
            ProductService productService, ProductMapper productMapper) {
        this.categoryService = categoryService;
        this.categoryMapper = categoryMapper;
        this.productService = productService;
        this.productMapper = productMapper;
    }

    @GetMapping
    public List<CategoryResponse> getAllCategories() {
        return categoryService.getAllCategories()
                .stream()
                .map(categoryMapper::toResponse)
                .toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<CategoryResponse> getCategoryById(@PathVariable("id") Long id) {
        Category category = categoryService.getCategoryById(id);
        return ResponseEntity.ok(categoryMapper.toResponse(category));
    }

    @PostMapping
    public ResponseEntity<CategoryResponse> createCategory(@RequestBody(required = false) CategoryRequest request) {
        return ResponseEntity.ok(categoryMapper.toResponse(categoryService.create(request)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<CategoryResponse> updateCategory(
            @PathVariable("id") Long id,
            @RequestBody(required = false) CategoryRequest request) {
        return ResponseEntity.ok(categoryMapper.toResponse(categoryService.update(id, request)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCategory(@PathVariable("id") Long id) {
        categoryService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/trash")
    public List<CategoryResponse> getDeletedCategories() {
        return categoryService.getDeletedCategories().stream()
                .map(categoryMapper::toResponse)
                .toList();
    }

    @PostMapping("/trash/{id}/restore")
    public ResponseEntity<Void> restoreDeletedCategory(@PathVariable("id") Long id) {
        categoryService.restoreDeleted(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/trash/restore-all")
    public ResponseEntity<Void> restoreAllDeletedCategories() {
        categoryService.restoreAllDeleted();
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/trash/{id}")
    public ResponseEntity<Void> deleteCategoryPermanently(@PathVariable("id") Long id) {
        categoryService.deletePermanently(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/products")
    public List<ProductResponse> getProductsByCategory(@PathVariable("id") Long id) {
        return productService.getAllProducts().stream()
                .filter(product -> product.getCategory() != null && id.equals(product.getCategory().getId()))
                .map(productMapper::toResponse)
                .toList();
    }
}