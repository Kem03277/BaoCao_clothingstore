package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.entity.Inventory;
import com.tranminhduong.clothingstore.entity.InventoryTransaction;
import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.entity.User;
import java.util.List;

public interface InventoryService {
    Inventory findByProductId(Long productId);

    Inventory create(Inventory inventory);

    List<Inventory> findLowStock();

    List<InventoryTransaction> findTransactions(Long productId);

    InventoryTransaction changeStock(Long productId, Integer quantityChange, String reason, Long createdById);

    InventoryTransaction recordOrderSale(Long productId, Integer quantity, Order order, User createdBy);

    void restoreOrderStock(Order order);
}