package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.dto.CategoryRequest;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.repository.CategoryRepository;
import com.tranminhduong.clothingstore.service.CategoryService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryServiceImpl(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Category> getDeletedCategories() {
        return categoryRepository.findDeleted();
    }

    @Override
    public Category getCategoryById(Long id) {
        Category category = categoryRepository.findById(id);
        if (category == null) {
            throw new ResourceNotFoundException("Không tìm thấy danh mục có id = " + id);
        }
        return category;
    }

    @Override
    @Transactional
    public Category create(CategoryRequest request) {
        validateRequest(request);
        String name = request.name().trim();
        if (categoryRepository.existsByNameIgnoreCase(name)) {
            throw new BadRequestException("Tên danh mục đã tồn tại");
        }
        Category category = new Category();
        category.setName(name);
        category.setDescription(normalizeDescription(request.description()));
        return categoryRepository.save(category);
    }

    @Override
    @Transactional
    public Category update(Long id, CategoryRequest request) {
        validateRequest(request);
        Category category = getCategoryById(id);
        String name = request.name().trim();
        if (categoryRepository.existsByNameIgnoreCaseAndIdNot(name, id)) {
            throw new BadRequestException("Tên danh mục đã tồn tại");
        }
        category.setName(name);
        category.setDescription(normalizeDescription(request.description()));
        return categoryRepository.save(category);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        getCategoryById(id);
        categoryRepository.setDeleted(id, true);
    }

    @Override
    @Transactional
    public void restoreDeleted(Long id) {
        if (categoryRepository.findDeletedById(id) == null) {
            throw new ResourceNotFoundException("Không tìm thấy danh mục trong thùng rác có id = " + id);
        }
        categoryRepository.setDeleted(id, false);
    }

    @Override
    @Transactional
    public void restoreAllDeleted() {
        categoryRepository.findDeleted().forEach(category -> categoryRepository.setDeleted(category.getId(), false));
    }

    @Override
    @Transactional
    public void deletePermanently(Long id) {
        if (categoryRepository.findDeletedById(id) == null) {
            throw new ResourceNotFoundException("Không tìm thấy danh mục trong thùng rác có id = " + id);
        }
        if (categoryRepository.countProductsById(id) > 0) {
            throw new BadRequestException("Không thể xóa vĩnh viễn vì danh mục đang được dữ liệu khác tham chiếu");
        }
        categoryRepository.deleteById(id);
    }

    private void validateRequest(CategoryRequest request) {
        if (request == null || request.name() == null || request.name().isBlank()) {
            throw new BadRequestException("Tên danh mục không được để trống");
        }
        if (request.name().trim().length() > 100) {
            throw new BadRequestException("Tên danh mục không được vượt quá 100 ký tự");
        }
        if (request.description() != null && request.description().length() > 500) {
            throw new BadRequestException("Mô tả danh mục không được vượt quá 500 ký tự");
        }
    }

    private String normalizeDescription(String description) {
        return description == null || description.isBlank() ? null : description.trim();
    }
}