package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.entity.Brand;
import com.tranminhduong.clothingstore.dto.BrandRequest;
import java.util.List;

public interface BrandService {
    List<Brand> findAll();

    List<Brand> findDeleted();

    Brand findById(Long id);

    Brand create(BrandRequest request);

    Brand update(Long id, BrandRequest request);

    void delete(Long id);

    void restoreDeleted(Long id);

    void restoreAllDeleted();

    void deletePermanently(Long id);
}