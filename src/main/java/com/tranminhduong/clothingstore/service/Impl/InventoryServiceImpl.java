package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.entity.Inventory;
import com.tranminhduong.clothingstore.entity.InventoryTransaction;
import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.repository.InventoryRepository;
import com.tranminhduong.clothingstore.repository.InventoryTransactionRepository;
import com.tranminhduong.clothingstore.service.InventoryService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class InventoryServiceImpl implements InventoryService {
    private final InventoryRepository inventoryRepository;
    private final InventoryTransactionRepository transactionRepository;
    private final EntityManager entityManager;

    public InventoryServiceImpl(InventoryRepository inventoryRepository,
            InventoryTransactionRepository transactionRepository,
            EntityManager entityManager) {
        this.inventoryRepository = inventoryRepository;
        this.transactionRepository = transactionRepository;
        this.entityManager = entityManager;
    }

    @Override
    public Inventory findByProductId(Long productId) {
        return inventoryRepository.findById(productId)
                .orElseThrow(
                        () -> new ResourceNotFoundException("Không tìm thấy kho của sản phẩm có id = " + productId));
    }

    @Override
    @Transactional
    public Inventory create(Inventory inventory) {
        validateInventory(inventory);
        Long productId = inventory.getProductId();
        Product product = findProductForUpdate(productId);
        if (inventoryRepository.existsById(productId)) {
            throw new BadRequestException("Sản phẩm đã có kho");
        }
        inventory.setProduct(entityManager.getReference(Product.class, productId));
        inventory.setUpdatedAt(LocalDateTime.now());
        product.setQuantity(inventory.getQuantity());
        entityManager.persist(inventory);
        entityManager.flush();
        return inventory;
    }

    @Override
    public List<Inventory> findLowStock() {
        return inventoryRepository.findLowStock();
    }

    @Override
    public List<InventoryTransaction> findTransactions(Long productId) {
        findByProductId(productId);
        return transactionRepository.findByInventory_ProductIdOrderByCreatedAtDesc(productId);
    }

    @Override
    @Transactional
    public InventoryTransaction changeStock(Long productId, Integer quantityChange, String reason, Long createdById) {
        validateChange(quantityChange, reason, createdById);
        Product product = findProductForUpdate(productId);
        Inventory inventory = findOrCreateInventory(product);
        int quantityAfter = inventory.getQuantity() + quantityChange;
        if (quantityAfter < 0) {
            throw new BadRequestException("Tồn kho không được nhỏ hơn 0");
        }
        inventory.setQuantity(quantityAfter);
        inventory.setUpdatedAt(LocalDateTime.now());
        product.setQuantity(quantityAfter);
        inventoryRepository.save(inventory);

        InventoryTransaction transaction = new InventoryTransaction();
        transaction.setInventory(inventory);
        transaction.setQuantityChange(quantityChange);
        transaction.setQuantityAfter(quantityAfter);
        transaction.setReason(reason);
        transaction.setCreatedBy(entityManager.getReference(User.class, createdById));
        InventoryTransaction savedTransaction = transactionRepository.save(transaction);
        entityManager.flush();
        return savedTransaction;
    }

    @Override
    @Transactional
    public InventoryTransaction recordOrderSale(Long productId, Integer quantity, Order order, User createdBy) {
        if (quantity == null || quantity <= 0 || order == null || createdBy == null) {
            throw new BadRequestException("Thông tin xuất kho theo đơn hàng không hợp lệ");
        }

        Product product = findProductForUpdate(productId);
        Inventory inventory = findOrCreateInventory(product);
        if (product.getQuantity() == null || product.getQuantity() < quantity) {
            throw new BadRequestException("Sản phẩm \"" + product.getName() + "\" không đủ số lượng tồn kho");
        }

        int quantityAfter = product.getQuantity() - quantity;
        product.setQuantity(quantityAfter);
        inventory.setQuantity(quantityAfter);
        inventory.setUpdatedAt(LocalDateTime.now());
        inventoryRepository.save(inventory);

        InventoryTransaction transaction = new InventoryTransaction();
        transaction.setInventory(inventory);
        transaction.setQuantityChange(-quantity);
        transaction.setQuantityAfter(quantityAfter);
        transaction.setReason("Bán hàng - " + order.getOrderCode());
        transaction.setCreatedBy(createdBy);
        transaction.setOrder(order);
        InventoryTransaction savedTransaction = transactionRepository.save(transaction);
        entityManager.flush();
        return savedTransaction;
    }

    @Override
    @Transactional
    public void restoreOrderStock(Order order) {
        if (order == null || order.getId() == null) {
            throw new BadRequestException("Đơn hàng cần hoàn kho không hợp lệ");
        }

        List<InventoryTransaction> sales = transactionRepository.findByOrder_IdOrderByIdAsc(order.getId());
        for (InventoryTransaction sale : sales) {
            if (sale.getQuantityChange() == null || sale.getQuantityChange() >= 0
                    || sale.getReason() == null || !sale.getReason().startsWith("Bán hàng - ")) {
                continue;
            }

            Inventory inventory = sale.getInventory();
            Product product = findProductForUpdate(inventory.getProductId());
            Inventory lockedInventory = findOrCreateInventory(product);
            int restoredQuantity = -sale.getQuantityChange();
            int quantityAfter = lockedInventory.getQuantity() + restoredQuantity;
            lockedInventory.setQuantity(quantityAfter);
            lockedInventory.setUpdatedAt(LocalDateTime.now());
            product.setQuantity(quantityAfter);
            inventoryRepository.save(lockedInventory);

            InventoryTransaction reversal = new InventoryTransaction();
            reversal.setInventory(lockedInventory);
            reversal.setOrder(order);
            reversal.setCreatedBy(order.getUser());
            reversal.setQuantityChange(restoredQuantity);
            reversal.setQuantityAfter(quantityAfter);
            reversal.setReason("Hoàn kho thanh toán VNPay - " + order.getOrderCode());
            transactionRepository.save(reversal);
        }
        entityManager.flush();
    }

    private Product findProductForUpdate(Long productId) {
        Product product = entityManager.find(Product.class, productId);
        if (product == null) {
            throw new ResourceNotFoundException("Không tìm thấy sản phẩm có id = " + productId);
        }
        entityManager.refresh(product, LockModeType.PESSIMISTIC_WRITE);
        return product;
    }

    private Inventory findOrCreateInventory(Product product) {
        return inventoryRepository.findByProductIdForUpdate(product.getId())
                .orElseGet(() -> {
                    Inventory inventory = new Inventory();
                    inventory.setProductId(product.getId());
                    inventory.setProduct(product);
                    inventory.setQuantity(product.getQuantity() == null ? 0 : product.getQuantity());
                    inventory.setLowStockThreshold(0);
                    inventory.setUpdatedAt(LocalDateTime.now());
                    entityManager.persist(inventory);
                    return inventory;
                });
    }

    private void validateInventory(Inventory inventory) {
        if (inventory == null || inventory.getProductId() == null || inventory.getQuantity() == null
                || inventory.getLowStockThreshold() == null || inventory.getQuantity() < 0
                || inventory.getLowStockThreshold() < 0) {
            throw new BadRequestException("Thông tin kho không hợp lệ");
        }
    }

    private void validateChange(Integer quantityChange, String reason, Long createdById) {
        if (quantityChange == null || quantityChange == 0 || reason == null || reason.isBlank()
                || createdById == null) {
            throw new BadRequestException("Số lượng thay đổi, lý do và người thực hiện không hợp lệ");
        }
        if (reason.length() > 255) {
            throw new BadRequestException("Lý do không được vượt quá 255 ký tự");
        }
    }
}