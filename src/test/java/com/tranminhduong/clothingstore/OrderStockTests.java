package com.tranminhduong.clothingstore;

import com.tranminhduong.clothingstore.dto.UserOrderRequest;
import com.tranminhduong.clothingstore.entity.Address;
import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.entity.Inventory;
import com.tranminhduong.clothingstore.entity.InventoryTransaction;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.Role;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.service.InventoryService;
import com.tranminhduong.clothingstore.service.OrderService;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class OrderStockTests {

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private OrderService orderService;

    @Autowired
    private InventoryService inventoryService;

    private Product product;
    private User customer;
    private Address address;

    @BeforeEach
    void setUp() {
        Category category = new Category();
        category.setName("Order stock test " + UUID.randomUUID());
        entityManager.persist(category);

        product = new Product();
        product.setName("Stock test product");
        product.setPrice(100_000.0);
        product.setQuantity(8);
        product.setCategory(category);
        entityManager.persist(product);

        Role role = new Role();
        role.setRoleCode("CUSTOMER");
        role.setRoleName("Customer");
        entityManager.persist(role);

        customer = new User();
        customer.setEmail("stock-" + UUID.randomUUID() + "@example.test");
        customer.setFullName("Stock test customer");
        customer.setPasswordHash("test-password");
        customer.setStatus("ACTIVE");
        customer.setRole(role);
        entityManager.persist(customer);

        address = new Address();
        address.setRecipientName(customer.getFullName());
        address.setPhone("0123456789");
        address.setProvince("Hà Nội");
        address.setAddressLine("1 Test Street");
        address.setUser(customer);
        entityManager.persist(address);
        entityManager.flush();
    }

    @Test
    void placingOrderDecreasesProductAndInventoryAndRestockingIncreasesBoth() {
        UserOrderRequest request = new UserOrderRequest(
                address.getId(),
                null,
                null,
                List.of(
                        new UserOrderRequest.OrderItemRequest(product.getId(), "M", 2, null),
                        new UserOrderRequest.OrderItemRequest(product.getId(), "L", 1, null)));

        var order = orderService.placeOrder(customer.getId(), request);
        entityManager.flush();
        entityManager.refresh(product);
        Inventory inventory = inventoryService.findByProductId(product.getId());

        assertThat(product.getQuantity()).isEqualTo(5);
        assertThat(inventory.getQuantity()).isEqualTo(5);

        inventoryService.changeStock(product.getId(), 4, "Nhập hàng bổ sung", customer.getId());
        entityManager.flush();
        entityManager.refresh(product);
        entityManager.refresh(inventory);

        assertThat(product.getQuantity()).isEqualTo(9);
        assertThat(inventory.getQuantity()).isEqualTo(9);

        List<InventoryTransaction> transactions = inventoryService.findTransactions(product.getId());
        assertThat(transactions).hasSize(2);
        assertThat(transactions)
                .anySatisfy(transaction -> {
                    assertThat(transaction.getQuantityChange()).isEqualTo(-3);
                    assertThat(transaction.getQuantityAfter()).isEqualTo(5);
                    assertThat(transaction.getOrder().getId()).isEqualTo(order.getId());
                });
    }

    @Test
    void placingOrderWithMoreThanAvailableStockIsRejected() {
        UserOrderRequest request = new UserOrderRequest(
                address.getId(),
                null,
                null,
                List.of(new UserOrderRequest.OrderItemRequest(product.getId(), "M", 9, null)));

        assertThatThrownBy(() -> orderService.placeOrder(customer.getId(), request))
                .isInstanceOf(BadRequestException.class)
                .hasMessageContaining("không đủ số lượng tồn kho");
    }
}
