package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.BrandResponse;
import com.tranminhduong.clothingstore.dto.BrandRequest;
import com.tranminhduong.clothingstore.dto.ProductResponse;
import com.tranminhduong.clothingstore.mapper.BrandMapper;
import com.tranminhduong.clothingstore.mapper.ProductMapper;
import com.tranminhduong.clothingstore.service.BrandService;
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
@RequestMapping("/api/brands")
public class BrandController {
    private final BrandService brandService;
    private final BrandMapper brandMapper;
    private final ProductService productService;
    private final ProductMapper productMapper;

    public BrandController(BrandService brandService, BrandMapper brandMapper,
            ProductService productService, ProductMapper productMapper) {
        this.brandService = brandService;
        this.brandMapper = brandMapper;
        this.productService = productService;
        this.productMapper = productMapper;
    }

    @GetMapping
    public List<BrandResponse> getAll() {
        return brandService.findAll().stream()
                .filter(brand -> brand.getStatus() == null || Boolean.TRUE.equals(brand.getStatus()))
                .map(brandMapper::toResponse)
                .toList();
    }

    @GetMapping("/manage")
    public List<BrandResponse> getAllForManagement() {
        return brandService.findAll().stream()
                .map(brandMapper::toResponse)
                .toList();
    }

    @PostMapping
    public ResponseEntity<BrandResponse> create(@RequestBody(required = false) BrandRequest request) {
        return ResponseEntity.ok(brandMapper.toResponse(brandService.create(request)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<BrandResponse> update(
            @PathVariable("id") Long id,
            @RequestBody(required = false) BrandRequest request) {
        return ResponseEntity.ok(brandMapper.toResponse(brandService.update(id, request)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        brandService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/trash")
    public List<BrandResponse> getDeletedBrands() {
        return brandService.findDeleted().stream().map(brandMapper::toResponse).toList();
    }

    @PostMapping("/trash/{id}/restore")
    public ResponseEntity<Void> restoreDeletedBrand(@PathVariable("id") Long id) {
        brandService.restoreDeleted(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/trash/restore-all")
    public ResponseEntity<Void> restoreAllDeletedBrands() {
        brandService.restoreAllDeleted();
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/trash/{id}")
    public ResponseEntity<Void> deleteBrandPermanently(@PathVariable("id") Long id) {
        brandService.deletePermanently(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}")
    public ResponseEntity<BrandResponse> getById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(brandMapper.toResponse(brandService.findById(id)));
    }

    @GetMapping("/{id}/products")
    public List<ProductResponse> getProductsByBrand(@PathVariable("id") Long id) {
        return productService.getAllProducts().stream()
                .filter(product -> product.getBrand() != null && id.equals(product.getBrand().getId()))
                .map(productMapper::toResponse)
                .toList();
    }
}