package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Brand;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;
import java.util.List;
import java.util.Optional;

public interface BrandRepository extends JpaRepository<Brand, Long> {
    @Query("SELECT brand FROM Brand brand WHERE COALESCE(brand.deleted, false) = false")
    List<Brand> findAllNotDeleted();

    @Query("SELECT brand FROM Brand brand WHERE brand.deleted = true")
    List<Brand> findDeletedBrands();

    @Query("SELECT brand FROM Brand brand WHERE brand.id = :id AND COALESCE(brand.deleted, false) = false")
    Optional<Brand> findActiveById(@Param("id") Long id);

    @Query("SELECT brand FROM Brand brand WHERE brand.id = :id AND brand.deleted = true")
    Optional<Brand> findDeletedById(@Param("id") Long id);

    boolean existsByBrandNameIgnoreCase(String brandName);

    boolean existsByBrandNameIgnoreCaseAndIdNot(String brandName, Long id);

    @Query("SELECT COUNT(product) FROM Product product WHERE product.brand.id = :brandId")
    long countProductsById(@Param("brandId") Long brandId);
}