package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.entity.Brand;
import com.tranminhduong.clothingstore.dto.BrandRequest;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.repository.BrandRepository;
import com.tranminhduong.clothingstore.service.BrandService;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BrandServiceImpl implements BrandService {
    private final BrandRepository brandRepository;

    public BrandServiceImpl(BrandRepository brandRepository) {
        this.brandRepository = brandRepository;
    }

    @Override
    public List<Brand> findAll() {
        return brandRepository.findAllNotDeleted();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Brand> findDeleted() {
        return brandRepository.findDeletedBrands();
    }

    @Override
    public Brand findById(Long id) {
        return brandRepository.findActiveById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy thương hiệu có id = " + id));
    }

    @Override
    @Transactional
    public Brand create(BrandRequest request) {
        validateRequest(request);
        String name = request.brandName().trim();
        if (brandRepository.existsByBrandNameIgnoreCase(name)) {
            throw new BadRequestException("Tên thương hiệu đã tồn tại");
        }
        Brand brand = new Brand();
        applyRequest(brand, request, name);
        return brandRepository.save(brand);
    }

    @Override
    @Transactional
    public Brand update(Long id, BrandRequest request) {
        validateRequest(request);
        Brand brand = findById(id);
        String name = request.brandName().trim();
        if (brandRepository.existsByBrandNameIgnoreCaseAndIdNot(name, id)) {
            throw new BadRequestException("Tên thương hiệu đã tồn tại");
        }
        applyRequest(brand, request, name);
        return brandRepository.save(brand);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Brand brand = findById(id);
        brand.setDeleted(true);
        brandRepository.save(brand);
    }

    @Override
    @Transactional
    public void restoreDeleted(Long id) {
        Brand brand = brandRepository.findDeletedById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy thương hiệu trong thùng rác có id = " + id));
        brand.setDeleted(false);
        brandRepository.save(brand);
    }

    @Override
    @Transactional
    public void restoreAllDeleted() {
        brandRepository.findDeletedBrands().forEach(brand -> brand.setDeleted(false));
    }

    @Override
    @Transactional
    public void deletePermanently(Long id) {
        Brand brand = brandRepository.findDeletedById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy thương hiệu trong thùng rác có id = " + id));
        if (brandRepository.countProductsById(id) > 0) {
            throw new BadRequestException("Không thể xóa vĩnh viễn vì thương hiệu đang được sản phẩm sử dụng");
        }
        brandRepository.delete(brand);
    }

    private void applyRequest(Brand brand, BrandRequest request, String name) {
        brand.setBrandName(name);
        brand.setLogoUrl(normalize(request.logoUrl()));
        brand.setDescription(normalize(request.description()));
        brand.setStatus(request.status() == null ? true : request.status());
    }

    private void validateRequest(BrandRequest request) {
        if (request == null || request.brandName() == null || request.brandName().isBlank()) {
            throw new BadRequestException("Tên thương hiệu không được để trống");
        }
        if (request.brandName().trim().length() > 100) {
            throw new BadRequestException("Tên thương hiệu không được vượt quá 100 ký tự");
        }
        if (request.logoUrl() != null && request.logoUrl().length() > 150) {
            throw new BadRequestException("Đường dẫn logo không được vượt quá 150 ký tự");
        }
    }

    private String normalize(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }
}