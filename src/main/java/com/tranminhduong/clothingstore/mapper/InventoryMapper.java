package com.tranminhduong.clothingstore.mapper;

import com.tranminhduong.clothingstore.dto.InventoryRequest;
import com.tranminhduong.clothingstore.dto.InventoryResponse;
import com.tranminhduong.clothingstore.dto.InventoryTransactionResponse;
import com.tranminhduong.clothingstore.entity.Inventory;
import com.tranminhduong.clothingstore.entity.InventoryTransaction;
import org.springframework.stereotype.Component;

@Component
public class InventoryMapper {
    public Inventory toEntity(InventoryRequest request) {
        if (request == null) {
            return null;
        }
        Inventory inventory = new Inventory();
        inventory.setProductId(request.productId());
        inventory.setQuantity(request.quantity());
        inventory.setLowStockThreshold(request.lowStockThreshold());
        return inventory;
    }

    public InventoryResponse toResponse(Inventory inventory) {
        if (inventory == null) {
            return null;
        }
        return new InventoryResponse(inventory.getProductId(), inventory.getQuantity(),
                inventory.getLowStockThreshold(), inventory.getUpdatedAt());
    }

    public InventoryTransactionResponse toResponse(InventoryTransaction transaction) {
        if (transaction == null) {
            return null;
        }
        return new InventoryTransactionResponse(transaction.getId(), transaction.getInventory().getProductId(),
                transaction.getQuantityChange(), transaction.getQuantityAfter(), transaction.getReason(),
                transaction.getCreatedAt(), transaction.getCreatedBy().getId());
    }
}