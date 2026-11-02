package com.tranminhduong.clothingstore;

import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.entity.Gender;
import com.tranminhduong.clothingstore.entity.Inventory;
import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.Role;
import com.tranminhduong.clothingstore.entity.Brand;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.repository.ProductRepository;
import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
@WithMockUser(authorities = "ROLE_ADMIN")
@Import(SecurityMockMvcTestConfig.class)
class ProductAdminApiTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private ProductRepository productRepository;

    private Long categoryId;
    private Long productId;

    @BeforeEach
    void setUp() {
        Category category = new Category();
        category.setName("Admin Test " + UUID.randomUUID());
        entityManager.persist(category);
        entityManager.flush();
        categoryId = category.getId();

        Product product = new Product();
        product.setName("Test item");
        product.setPrice(25.0);
        product.setQuantity(4);
        product.setCategory(category);
        entityManager.persist(product);
        entityManager.flush();
        productId = product.getId();
    }

    @Test
    void updateProductChangesItsInformation() throws Exception {
        Brand brand = new Brand();
        brand.setBrandName("Test brand");
        entityManager.persist(brand);
        entityManager.flush();

        mockMvc.perform(get("/api/products/{id}", productId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("Test item")));

        String request = """
                {
                  "name": "Updated item",
                  "description": "Updated description",
                  "price": 39.5,
                  "quantity": 7,
                  "categoryId": %d,
                  "brandId": %d
                }
                """.formatted(categoryId, brand.getId());

        mockMvc.perform(put("/api/products/{id}", productId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(request))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("Updated item")))
                .andExpect(jsonPath("$.price", is(39.5)))
                .andExpect(jsonPath("$.quantity", is(7)))
                .andExpect(jsonPath("$.brandId", is(brand.getId().intValue())));
    }

    @Test
    void softDeletedProductsAreHiddenUntilRestored() throws Exception {
        mockMvc.perform(delete("/api/products/{id}", productId))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/products"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(0)));

        mockMvc.perform(get("/api/products/trash"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].id", is(productId.intValue())));

        mockMvc.perform(post("/api/products/trash/restore-all"))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/products"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
    }

    @Test
    void filtersProductsByGenderUsingDatabaseEnumValues() throws Exception {
        Product maleProduct = createProduct("Male item", Gender.MALE);
        Product femaleProduct = createProduct("Female item", Gender.FEMALE);
        Product unisexProduct = createProduct("Unisex item", Gender.UNISEX);

        mockMvc.perform(get("/api/products").param("gender", "MALE"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].id", is(maleProduct.getId().intValue())));

        mockMvc.perform(get("/api/products").param("gender", "FEMALE"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].id", is(femaleProduct.getId().intValue())));

        mockMvc.perform(get("/api/products").param("gender", "UNISEX"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].id", is(unisexProduct.getId().intValue())));
    }

    @Test
    void productListingFiltersAndPaginatesInDatabase() throws Exception {
        Product maleProduct = createProduct("Paged male item", Gender.MALE);
        Product firstSortedMaleProduct = createProduct("Another male item", Gender.MALE);

        mockMvc.perform(get("/api/products/page")
                        .param("gender", "MALE")
                        .param("keyword", "male")
                        .param("page", "0")
                        .param("size", "1")
                        .param("sort", "name_asc"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(1)))
                .andExpect(jsonPath("$.content[0].id", is(firstSortedMaleProduct.getId().intValue())))
                .andExpect(jsonPath("$.page", is(0)))
                .andExpect(jsonPath("$.size", is(1)))
                .andExpect(jsonPath("$.totalElements", is(2)))
                .andExpect(jsonPath("$.totalPages", is(2)));

        mockMvc.perform(get("/api/products/page")
                        .param("gender", "MALE")
                        .param("keyword", "male")
                        .param("page", "1")
                        .param("size", "1")
                        .param("sort", "name_asc"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(1)))
                .andExpect(jsonPath("$.content[0].id", is(maleProduct.getId().intValue())));

        mockMvc.perform(get("/api/products").param("gender", "MALE").param("size", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
    }

    @Test
    void rejectsPageSizesAboveTheMaximum() throws Exception {
        mockMvc.perform(get("/api/products/page").param("size", "101"))
                .andExpect(status().isBadRequest());
    }

    @Test
    @WithMockUser(authorities = "ROLE_CUSTOMER")
    void productManagementPageRequiresStaffAccess() throws Exception {
        mockMvc.perform(get("/api/products/manage/page"))
                .andExpect(status().isForbidden());
    }

    private Product createProduct(String name, Gender gender) {
        Product product = new Product();
        product.setName(name);
        product.setPrice(25.0);
        product.setQuantity(4);
        product.setCategory(entityManager.getReference(Category.class, categoryId));
        product.setGender(gender);
        entityManager.persist(product);
        entityManager.flush();
        return product;
    }

    @Test
    void restoresOneSoftDeletedProduct() throws Exception {
        mockMvc.perform(delete("/api/products/{id}", productId))
                .andExpect(status().isNoContent());

        mockMvc.perform(post("/api/products/trash/{id}/restore", productId))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/products"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].id", is(productId.intValue())));
        mockMvc.perform(get("/api/products/trash"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(0)));
    }

    @Test
    void permanentDeleteRejectsProductsReferencedByInventory() throws Exception {
        Product product = productRepository.findById(productId).orElseThrow();
        Inventory inventory = new Inventory();
        inventory.setProduct(product);
        inventory.setProductId(productId);
        inventory.setQuantity(4);
        inventory.setLowStockThreshold(1);
        entityManager.persist(inventory);
        entityManager.flush();

        mockMvc.perform(delete("/api/products/{id}", productId))
                .andExpect(status().isNoContent());

        mockMvc.perform(delete("/api/products/trash/{id}", productId))
                .andExpect(status().isBadRequest());

        org.assertj.core.api.Assertions.assertThat(productRepository.existsById(productId)).isTrue();
    }

    @Test
    void permanentDeleteRemovesAnUnreferencedProductFromTrash() throws Exception {
        mockMvc.perform(delete("/api/products/{id}", productId))
                .andExpect(status().isNoContent());

        mockMvc.perform(delete("/api/products/trash/{id}", productId))
                .andExpect(status().isNoContent());

        org.assertj.core.api.Assertions.assertThat(productRepository.existsById(productId)).isFalse();
    }

    @Test
    void cancellationIsAllowedOnlyForNewPendingOrConfirmedOrders() throws Exception {
        Order order = createOrder("CONFIRMED", new BigDecimal("25.00"), LocalDate.now());

        mockMvc.perform(put("/api/admin/orders/{id}/cancel", order.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", is("CANCELLED")));

        Order shippedOrder = createOrder("SHIPPED", new BigDecimal("10.00"), LocalDate.now());
        mockMvc.perform(put("/api/admin/orders/{id}/cancel", shippedOrder.getId()))
                .andExpect(status().isBadRequest());
    }

    @Test
    void dailyRevenueIncludesEachDateAndExcludesCancelledOrders() throws Exception {
        LocalDate today = LocalDate.now();
        createOrder("NEW", new BigDecimal("12.50"), today);
        createOrder("CONFIRMED", new BigDecimal("3.00"), today);
        createOrder("CANCELLED", new BigDecimal("100.00"), today);

        mockMvc.perform(get("/api/admin/dashboard/revenue/by-day")
                        .param("from", today.toString())
                        .param("to", today.plusDays(1).toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].date", is(today.toString())))
                .andExpect(jsonPath("$[0].revenue", is(15.5)))
                .andExpect(jsonPath("$[1].date", is(today.plusDays(1).toString())))
                .andExpect(jsonPath("$[1].revenue", is(0)));

        mockMvc.perform(get("/api/admin/dashboard/revenue")
                        .param("from", today.toString())
                        .param("to", today.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.revenue", is(15.5)));
    }

    private Order createOrder(String status, BigDecimal totalAmount, LocalDate date) {
        Role role = new Role();
        role.setRoleCode("CUSTOMER");
        role.setRoleName("Customer");
        entityManager.persist(role);

        User user = new User();
        user.setEmail(UUID.randomUUID() + "@example.test");
        user.setFullName("Test user");
        user.setStatus("ACTIVE");
        user.setRole(role);
        entityManager.persist(user);

        Order order = new Order();
        order.setUser(user);
        order.setStatus(status);
        order.setTotalAmount(totalAmount);
        order.setCreatedAt(date.atTime(12, 0));
        order.setUpdatedAt(LocalDateTime.now());
        entityManager.persist(order);
        entityManager.flush();
        return order;
    }
}
