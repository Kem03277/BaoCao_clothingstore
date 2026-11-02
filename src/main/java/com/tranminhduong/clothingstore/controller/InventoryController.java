package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.InventoryRequest;
import com.tranminhduong.clothingstore.dto.InventoryResponse;
import com.tranminhduong.clothingstore.dto.InventoryTransactionRequest;
import com.tranminhduong.clothingstore.dto.InventoryTransactionResponse;
import com.tranminhduong.clothingstore.mapper.InventoryMapper;
import com.tranminhduong.clothingstore.service.InventoryService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/inventory")
public class InventoryController {
    private final InventoryService inventoryService;
    private final InventoryMapper inventoryMapper;

    public InventoryController(InventoryService inventoryService, InventoryMapper inventoryMapper) {
        this.inventoryService = inventoryService;
        this.inventoryMapper = inventoryMapper;
    }

    // Chức năng: Xem tồn kho sản phẩm, ví dụ GET /api/inventory/product/1
    @GetMapping("/product/{productId}")
    public ResponseEntity<InventoryResponse> findByProduct(@PathVariable("productId") Long productId) {
        return ResponseEntity.ok(inventoryMapper.toResponse(inventoryService.findByProductId(productId)));
    }

    // Chức năng: Tạo kho sản phẩm, ví dụ POST /api/inventory
    @PostMapping
    public ResponseEntity<InventoryResponse> create(@RequestBody InventoryRequest request) {
        return ResponseEntity
                .ok(inventoryMapper.toResponse(inventoryService.create(inventoryMapper.toEntity(request))));
    }

    // Chức năng: Xem tồn kho thấp, ví dụ GET /api/inventory/low-stock
    @GetMapping("/low-stock")
    public List<InventoryResponse> findLowStock() {
        return inventoryService.findLowStock().stream().map(inventoryMapper::toResponse).toList();
    }

    // Chức năng: Xem lịch sử kho, ví dụ GET /api/inventory/1/transactions
    @GetMapping("/{productId}/transactions")
    public List<InventoryTransactionResponse> findTransactions(@PathVariable("productId") Long productId) {
        return inventoryService.findTransactions(productId).stream().map(inventoryMapper::toResponse).toList();
    }

    // Chức năng: Nhập kho, ví dụ POST /api/inventory/1/stock-in
    @PostMapping("/{productId}/stock-in")
    public ResponseEntity<InventoryTransactionResponse> stockIn(@PathVariable("productId") Long productId,
            @RequestBody InventoryTransactionRequest request) {
        if (request.quantity() == null || request.quantity() <= 0) {
            throw new com.tranminhduong.clothingstore.exception.BadRequestException("Số lượng nhập phải lớn hơn 0");
        }
        return ResponseEntity.ok(inventoryMapper.toResponse(inventoryService.changeStock(
                productId, request.quantity(), request.reason(), request.createdById())));
    }

    // Chức năng: Xuất kho, ví dụ POST /api/inventory/1/stock-out
    @PostMapping("/{productId}/stock-out")
    public ResponseEntity<InventoryTransactionResponse> stockOut(@PathVariable("productId") Long productId,
            @RequestBody InventoryTransactionRequest request) {
        if (request.quantity() == null || request.quantity() <= 0) {
            throw new com.tranminhduong.clothingstore.exception.BadRequestException("Số lượng xuất phải lớn hơn 0");
        }
        return ResponseEntity.ok(inventoryMapper.toResponse(inventoryService.changeStock(
                productId, -request.quantity(), request.reason(), request.createdById())));
    }

    // Chức năng: Điều chỉnh kho, ví dụ POST /api/inventory/1/adjustment
    @PostMapping("/{productId}/adjustment")
    public ResponseEntity<InventoryTransactionResponse> adjust(@PathVariable("productId") Long productId,
            @RequestBody InventoryTransactionRequest request) {
        return ResponseEntity.ok(inventoryMapper.toResponse(inventoryService.changeStock(
                productId, request.quantityChange(), request.reason(), request.createdById())));
    }
}