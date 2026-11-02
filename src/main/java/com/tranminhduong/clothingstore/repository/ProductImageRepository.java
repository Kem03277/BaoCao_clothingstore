package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.ProductImage;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductImageRepository extends JpaRepository<ProductImage, Long> {
    List<ProductImage> findByProduct_IdOrderByIdAsc(Long productId);

    Optional<ProductImage> findByIdAndProduct_Id(Long id, Long productId);
}