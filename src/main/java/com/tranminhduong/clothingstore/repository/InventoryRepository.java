package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Inventory;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface InventoryRepository extends JpaRepository<Inventory, Long> {
    @Query(value = "SELECT * FROM inventories WHERE product_id = :productId FOR UPDATE", nativeQuery = true)
    Optional<Inventory> findByProductIdForUpdate(@Param("productId") Long productId);

    @Query("SELECT inventory FROM Inventory inventory WHERE inventory.quantity <= inventory.lowStockThreshold")
    List<Inventory> findLowStock();
}