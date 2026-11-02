package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.InventoryTransaction;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InventoryTransactionRepository extends JpaRepository<InventoryTransaction, Long> {
    List<InventoryTransaction> findByInventory_ProductIdOrderByCreatedAtDesc(Long productId);
    List<InventoryTransaction> findByOrder_IdOrderByIdAsc(Long orderId);
}