package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {

    @Query("SELECT DISTINCT product FROM Product product LEFT JOIN FETCH product.images "
            + "WHERE product.deleted = false OR product.deleted IS NULL ORDER BY product.id")
    List<Product> findActiveProducts();

    @Query("SELECT DISTINCT product FROM Product product LEFT JOIN FETCH product.images "
            + "WHERE product.id = :id AND (product.deleted = false OR product.deleted IS NULL)")
    Optional<Product> findActiveById(@Param("id") Long id);

    @Query("SELECT DISTINCT product FROM Product product LEFT JOIN FETCH product.images "
            + "WHERE product.deleted = true ORDER BY product.id")
    List<Product> findDeletedProducts();

    @Query("SELECT CASE WHEN COUNT(item) > 0 THEN true ELSE false END "
            + "FROM OrderItem item WHERE item.product.id = :productId")
    boolean hasOrderItems(@Param("productId") Long productId);

    @Query("SELECT CASE WHEN COUNT(item) > 0 THEN true ELSE false END "
            + "FROM CartItem item WHERE item.product.id = :productId")
    boolean hasCartItems(@Param("productId") Long productId);

    @Query("SELECT CASE WHEN COUNT(item) > 0 THEN true ELSE false END "
            + "FROM Wishlist item WHERE item.product.id = :productId")
    boolean hasWishlists(@Param("productId") Long productId);

    @Query("SELECT CASE WHEN COUNT(item) > 0 THEN true ELSE false END "
            + "FROM CouponProduct item WHERE item.product.id = :productId")
    boolean hasCouponTargets(@Param("productId") Long productId);

    @Query("SELECT CASE WHEN COUNT(item) > 0 THEN true ELSE false END "
            + "FROM PriceListItem item WHERE item.product.id = :productId")
    boolean hasPriceListItems(@Param("productId") Long productId);

    @Query("SELECT CASE WHEN COUNT(item) > 0 THEN true ELSE false END "
            + "FROM Inventory item WHERE item.productId = :productId")
    boolean hasInventory(@Param("productId") Long productId);

    @Query("SELECT CASE WHEN COUNT(item) > 0 THEN true ELSE false END "
            + "FROM ProductImage item WHERE item.product.id = :productId")
    boolean hasImages(@Param("productId") Long productId);
}