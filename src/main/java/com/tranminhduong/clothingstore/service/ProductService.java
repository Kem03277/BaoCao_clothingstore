package com.tranminhduong.clothingstore.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.ProductImage;
import org.springframework.web.multipart.MultipartFile;

public interface ProductService {

    List<Product> getAllProducts();

    Product getProductById(Long id);

    List<Product> getDeletedProducts();

    Page<Product> searchProducts(
            boolean deleted,
            Long categoryId,
            Long brandId,
            com.tranminhduong.clothingstore.entity.Gender gender,
            Double minPrice,
            Double maxPrice,
            String keyword,
            Pageable pageable);

    Product create(Product product, String initialImageUrl);

    Product update(Long id, Product product);

    Product updateMainImage(Long id, MultipartFile file);

    Product addImages(Long id, List<MultipartFile> files);

    List<ProductImage> getAdditionalImages(Long id);

    ProductImage updateAdditionalImage(Long productId, Long imageId, MultipartFile file);

    void deleteAdditionalImage(Long productId, Long imageId);

    void delete(Long id);

    void deletePermanently(Long id);

    void restoreDeleted(Long id);

    void restoreAllDeleted();
}
