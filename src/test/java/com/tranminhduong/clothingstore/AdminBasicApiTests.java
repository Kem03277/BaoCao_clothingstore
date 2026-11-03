package com.tranminhduong.clothingstore;

import com.tranminhduong.clothingstore.entity.Brand;
import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.entity.Coupon;
import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.entity.OrderItem;
import com.tranminhduong.clothingstore.entity.Post;
import com.tranminhduong.clothingstore.entity.PostCategory;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.Role;
import com.tranminhduong.clothingstore.entity.User;
import jakarta.servlet.DispatcherType;
import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.security.test.context.support.WithAnonymousUser;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
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
class AdminBasicApiTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private Category category;
    private Product product;

    @BeforeEach
    void setUp() {
        category = new Category();
        category.setName("Basic API Test " + UUID.randomUUID());
        entityManager.persist(category);

        product = new Product();
        product.setName("Basic API Product");
        product.setPrice(50.0);
        product.setQuantity(8);
        product.setCategory(category);
        entityManager.persist(product);
        entityManager.flush();
    }

    @Test
    void adminCanLoginChangePasswordAndManageUserStatus() throws Exception {
        User admin = createUser("ADMIN", "admin-" + UUID.randomUUID() + "@example.test", "old-password");

        mockMvc.perform(get("/api/admin/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
        mockMvc.perform(get("/api/admin/users/{id}", admin.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email", is(admin.getEmail())));
        MvcResult loginResult = mockMvc.perform(post("/api/admin/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","password":"old-password"}
                                """.formatted(admin.getEmail())))
                .andExpect(status().isOk())
                .andReturn();

        mockMvc.perform(put("/api/admin/change-password")
                        .header("Authorization", "Bearer " + jsonString(
                                loginResult.getResponse().getContentAsString(), "accessToken"))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"currentPassword":"old-password","newPassword":"new-password"}
                                """))
                .andExpect(status().isNoContent());
        mockMvc.perform(post("/api/admin/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","password":"new-password"}
                                """.formatted(admin.getEmail())))
                .andExpect(status().isOk());

        mockMvc.perform(put("/api/admin/users/{id}/status", admin.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\":\"LOCKED\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", is("LOCKED")));
        mockMvc.perform(post("/api/admin/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","password":"new-password"}
                                """.formatted(admin.getEmail())))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(put("/api/admin/users/{id}/status", admin.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\":\"ACTIVE\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", is("ACTIVE")));
    }

    @Test
    void userSearchIsFilteredAndPagedByDatabase() throws Exception {
        createUser("CUSTOMER", "paged-user-one-" + UUID.randomUUID() + "@example.test", "password");
        createUser("CUSTOMER", "paged-user-two-" + UUID.randomUUID() + "@example.test", "password");

        mockMvc.perform(get("/api/admin/users/page")
                        .param("keyword", "paged-user")
                        .param("page", "0")
                        .param("size", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(1)))
                .andExpect(jsonPath("$.totalElements", is(2)))
                .andExpect(jsonPath("$.totalPages", is(2)));
    }

    @Test
    void orderListingFiltersAndPagesWithoutFetchingAllOrders() throws Exception {
        User customer = createUser("CUSTOMER", "order-page-" + UUID.randomUUID() + "@example.test", "password");
        createOrder(customer, "NEW");
        createOrder(customer, "CANCELLED");

        mockMvc.perform(get("/api/admin/orders/page")
                        .param("status", "NEW")
                        .param("page", "0")
                        .param("size", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content", hasSize(1)))
                .andExpect(jsonPath("$.content[0].status", is("NEW")))
                .andExpect(jsonPath("$.totalElements", is(1)))
                .andExpect(jsonPath("$.totalPages", is(1)));
    }

    @Test
    void couponCrudAndCategoryProductTargetsWork() throws Exception {
        String couponJson = """
                {
                  "code":"SAVE10",
                  "name":"Ten percent",
                  "discountType":"PERCENT",
                  "discountValue":10,
                  "applyScope":"PRODUCT",
                  "minOrderAmount":0,
                  "maxDiscount":20,
                  "startAt":null,
                  "endAt":null,
                  "status":true
                }
                """;
        MvcResult createResult = mockMvc.perform(post("/api/admin/coupons")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(couponJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.discountType", is("PERCENTAGE")))
                .andReturn();
        long couponId = jsonLong(createResult.getResponse().getContentAsString(), "id");

        mockMvc.perform(post("/api/admin/coupons")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(couponJson.replace("SAVE10", "FIXED10").replace("\"PERCENT\"", "\"FIXED\"")))
                .andExpect(status().isBadRequest());
        mockMvc.perform(post("/api/admin/coupons")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(couponJson.replace("SAVE10", "OVER100").replace("\"discountValue\":10", "\"discountValue\":101")))
                .andExpect(status().isBadRequest());

        mockMvc.perform(get("/api/admin/coupons"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
        mockMvc.perform(get("/api/admin/coupons/{id}", couponId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code", is("SAVE10")));

        mockMvc.perform(put("/api/admin/coupons/{id}", couponId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(couponJson.replace("Ten percent", "Updated discount")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("Updated discount")));

        mockMvc.perform(patch("/api/admin/coupons/{id}/status", couponId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\":false}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", is(false)));
        mockMvc.perform(patch("/api/admin/coupons/{id}/status", couponId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\":true}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", is(true)));

        Coupon expiredCoupon = entityManager.find(Coupon.class, couponId);
        expiredCoupon.setEndAt(LocalDateTime.now().minusMinutes(1));
        entityManager.flush();
        mockMvc.perform(patch("/api/admin/coupons/{id}/status", couponId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\":true}"))
                .andExpect(status().isBadRequest());

        mockMvc.perform(post("/api/admin/coupons/{id}/categories", couponId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"targetId\":" + category.getId() + "}"))
                .andExpect(status().isNoContent());
        mockMvc.perform(get("/api/admin/coupons/{id}/categories", couponId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
        mockMvc.perform(delete("/api/admin/coupons/{id}/categories/{categoryId}", couponId, category.getId()))
                .andExpect(status().isNoContent());

        mockMvc.perform(post("/api/admin/coupons/{id}/products", couponId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"targetId\":" + product.getId() + "}"))
                .andExpect(status().isNoContent());
        mockMvc.perform(get("/api/admin/coupons/{id}/products", couponId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
        mockMvc.perform(delete("/api/admin/coupons/{id}/products/{productId}", couponId, product.getId()))
                .andExpect(status().isNoContent());
        mockMvc.perform(delete("/api/admin/coupons/{id}", couponId))
                .andExpect(status().isNoContent());
    }

    @Test
    @WithAnonymousUser
    void customerCanValidateCouponAgainstDatabaseCodeAndCart() throws Exception {
        Coupon coupon = new Coupon();
        coupon.setCode("CART10");
        coupon.setName("Cart discount");
        coupon.setDiscountType("PERCENTAGE");
        coupon.setDiscountValue(new BigDecimal("10"));
        coupon.setApplyScope("ALL");
        coupon.setMinOrderAmount(BigDecimal.ZERO);
        coupon.setMaxDiscount(new BigDecimal("100"));
        coupon.setStartAt(LocalDateTime.now().minusMinutes(1));
        coupon.setEndAt(LocalDateTime.now().plusDays(1));
        coupon.setStatus(true);
        entityManager.persist(coupon);
        entityManager.flush();

        mockMvc.perform(post("/api/coupons/validate")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "code":"cart10",
                                  "items":[{"productId":%d,"quantity":2}]
                                }
                                """.formatted(product.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.coupon.code", is("CART10")))
                .andExpect(jsonPath("$.discountAmount", is(10.0)))
                .andExpect(jsonPath("$.eligibleProductIds[0]", is(product.getId().intValue())));

        coupon.setCode("WELCOME10");
        entityManager.flush();
        mockMvc.perform(post("/api/coupons/validate")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"code":"WELCOM10","items":[{"productId":%d,"quantity":2}]}
                                """.formatted(product.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.coupon.code", is("WELCOME10")))
                .andExpect(jsonPath("$.discountAmount", is(10.0)));

        mockMvc.perform(post("/api/coupons/validate")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"code":"UNKNOWN","items":[{"productId":%d,"quantity":2}]}
                                """.formatted(product.getId())))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message", is("Mã không hợp lệ hoặc đã hết hạn")));
    }

    @Test
    void inventoryReadAndStockOperationsWork() throws Exception {
        User admin = createUser("ADMIN", "inventory-" + UUID.randomUUID() + "@example.test", "password");

        mockMvc.perform(post("/api/inventory")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"productId":%d,"quantity":2,"lowStockThreshold":2}
                                """.formatted(product.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.quantity", is(2)));
        entityManager.refresh(product);
        org.assertj.core.api.Assertions.assertThat(product.getQuantity()).isEqualTo(2);
        mockMvc.perform(get("/api/inventory/product/{productId}", product.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.quantity", is(2)));
        mockMvc.perform(get("/api/inventory/low-stock"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
        mockMvc.perform(get("/api/inventory/{productId}/transactions", product.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(0)));

        String stockRequest = """
                {"quantity":3,"quantityChange":null,"reason":"stock update","createdById":%d}
                """.formatted(admin.getId());
        mockMvc.perform(post("/api/inventory/{productId}/stock-in", product.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(stockRequest))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.quantityAfter", is(5)));
        entityManager.refresh(product);
        org.assertj.core.api.Assertions.assertThat(product.getQuantity()).isEqualTo(5);
        mockMvc.perform(post("/api/inventory/{productId}/stock-out", product.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(stockRequest))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.quantityAfter", is(2)));
        entityManager.refresh(product);
        org.assertj.core.api.Assertions.assertThat(product.getQuantity()).isEqualTo(2);
        mockMvc.perform(post("/api/inventory/{productId}/adjustment", product.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"quantity":null,"quantityChange":1,"reason":"manual count","createdById":%d}
                                """.formatted(admin.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.quantityAfter", is(3)));
        entityManager.refresh(product);
        org.assertj.core.api.Assertions.assertThat(product.getQuantity()).isEqualTo(3);
        mockMvc.perform(post("/api/inventory/{productId}/stock-out", product.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"quantity":4,"quantityChange":null,"reason":"exceeds stock","createdById":%d}
                                """.formatted(admin.getId())))
                .andExpect(status().isBadRequest());
        mockMvc.perform(get("/api/inventory/product/{productId}", product.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.quantity", is(3)));
        mockMvc.perform(get("/api/inventory/{productId}/transactions", product.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(3)));
    }

    @Test
    void categoryBrandAndPostReadApisReturnTheirData() throws Exception {
        Brand brand = new Brand();
        brand.setBrandName("Read-only brand");
        entityManager.persist(brand);

        User author = createUser("ADMIN", "author-" + UUID.randomUUID() + "@example.test", "password");
        PostCategory postCategory = new PostCategory();
        postCategory.setCategoryName("News");
        postCategory.setSlug("news");
        entityManager.persist(postCategory);

        Post post = new Post();
        post.setTitle("Read-only post");
        post.setSlug("read-only-post");
        post.setContent("Content");
        post.setStatus("PUBLISHED");
        post.setPostCategory(postCategory);
        post.setAuthor(author);
        entityManager.persist(post);
        entityManager.flush();

        mockMvc.perform(get("/api/categories"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
        mockMvc.perform(get("/api/categories/{id}", category.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is(category.getName())));
        mockMvc.perform(get("/api/brands"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
        mockMvc.perform(get("/api/brands/{id}", brand.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.brandName", is("Read-only brand")));
        mockMvc.perform(get("/api/posts").param("status", "PUBLISHED"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
        mockMvc.perform(get("/api/post-categories"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].categoryName", is("News")));
        mockMvc.perform(get("/api/posts/{id}", post.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title", is("Read-only post")));
    }

    @Test
    void adminCanCreatePublishUpdateAndDeletePostsWhilePublicOnlySeesPublishedPosts() throws Exception {
        PostCategory postCategory = new PostCategory();
        postCategory.setCategoryName("Editorial " + UUID.randomUUID());
        postCategory.setSlug("editorial-" + UUID.randomUUID());
        entityManager.persist(postCategory);
        User author = createUser("ADMIN", "post-admin-" + UUID.randomUUID() + "@example.test", "post-password");

        MvcResult loginResult = mockMvc.perform(post("/api/admin/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","password":"post-password"}
                                """.formatted(author.getEmail())))
                .andExpect(status().isOk())
                .andReturn();
        String authorization = "Bearer " + jsonString(loginResult.getResponse().getContentAsString(), "accessToken");

        MvcResult publishedResult = mockMvc.perform(post("/api/posts")
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"title":"Áo khoác mùa thu","slug":"","thumbnailUrl":"","content":"Bài viết đã xuất bản",
                                 "status":"PUBLISHED","postCategoryId":%d}
                                """.formatted(postCategory.getId())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.status", is("PUBLISHED")))
                .andExpect(jsonPath("$.postCategoryName", is(postCategory.getCategoryName())))
                .andReturn();
        long publishedId = jsonLong(publishedResult.getResponse().getContentAsString(), "id");

        MvcResult draftResult = mockMvc.perform(post("/api/posts")
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"title":"Bản nháp mùa đông","content":"Nội dung nháp",
                                 "status":"DRAFT","postCategoryId":%d}
                                """.formatted(postCategory.getId())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.publishedAt").doesNotExist())
                .andReturn();
        long draftId = jsonLong(draftResult.getResponse().getContentAsString(), "id");

        mockMvc.perform(get("/api/posts"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].title", is("Áo khoác mùa thu")));
        mockMvc.perform(get("/api/posts/{id}", draftId))
                .andExpect(status().isNotFound());
        mockMvc.perform(get("/api/posts/manage").header("Authorization", authorization))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)));
        mockMvc.perform(get("/api/posts/manage/trash").header("Authorization", authorization))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(0)));

        mockMvc.perform(put("/api/posts/{id}", draftId)
                        .header("Authorization", authorization)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"title":"Bản nháp mùa đông","content":"Nội dung đã chỉnh sửa",
                                 "status":"PUBLISHED","postCategoryId":%d}
                                """.formatted(postCategory.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", is("PUBLISHED")))
                .andExpect(jsonPath("$.publishedAt").exists());
        mockMvc.perform(delete("/api/posts/{id}", publishedId).header("Authorization", authorization))
                .andExpect(status().isNoContent());
    }

    @Test
    @WithAnonymousUser
    void anonymousUsersCannotAccessPostManagementEndpoints() throws Exception {
        mockMvc.perform(get("/api/posts/manage"))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(get("/api/posts/manage/trash"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @WithAnonymousUser
    void errorDispatchDoesNotTurnControllerErrorsIntoUnauthorizedResponses() throws Exception {
        mockMvc.perform(get("/api/posts/manage").with(request -> {
                    request.setDispatcherType(DispatcherType.ERROR);
                    return request;
                }))
                .andExpect(status().isOk());
    }

    @Test
    void orderListDetailAndStatusAndDashboardCountsWork() throws Exception {
        User user = createUser("CUSTOMER", "order-" + UUID.randomUUID() + "@example.test", "password");
        Order order = new Order();
        order.setUser(user);
        order.setStatus("NEW");
        order.setTotalAmount(new BigDecimal("50.00"));
        order.setCreatedAt(LocalDate.now().atStartOfDay());
        entityManager.persist(order);

        OrderItem item = new OrderItem();
        item.setOrder(order);
        item.setProduct(product);
        item.setProductName(product.getName());
        item.setQuantity(2);
        item.setUnitPrice(new BigDecimal("25.00"));
        item.setLineTotal(new BigDecimal("50.00"));
        order.getOrderItems().add(item);
        entityManager.persist(item);
        entityManager.flush();

        mockMvc.perform(get("/api/admin/orders"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
        mockMvc.perform(get("/api/admin/orders/{id}", order.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.items", hasSize(1)))
                .andExpect(jsonPath("$.items[0].productName", is(product.getName())));
        mockMvc.perform(put("/api/admin/orders/{id}/status", order.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\":\"CONFIRMED\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", is("CONFIRMED")));
        mockMvc.perform(put("/api/admin/orders/{id}/status", order.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\":\"NOT_A_STATUS\"}"))
                .andExpect(status().isBadRequest());
        mockMvc.perform(get("/api/admin/dashboard/orders-by-status"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].status", is("CONFIRMED")))
                .andExpect(jsonPath("$[0].count", is(1)));

        Order cancelledOrder = new Order();
        cancelledOrder.setUser(user);
        cancelledOrder.setStatus("CANCELLED");
        cancelledOrder.setTotalAmount(new BigDecimal("2475.00"));
        cancelledOrder.setCreatedAt(LocalDate.now().atStartOfDay());
        entityManager.persist(cancelledOrder);
        OrderItem cancelledItem = new OrderItem();
        cancelledItem.setOrder(cancelledOrder);
        cancelledItem.setProduct(product);
        cancelledItem.setProductName(product.getName());
        cancelledItem.setQuantity(99);
        cancelledItem.setUnitPrice(new BigDecimal("25.00"));
        cancelledItem.setLineTotal(new BigDecimal("2475.00"));
        entityManager.persist(cancelledItem);
        entityManager.flush();

        mockMvc.perform(get("/api/admin/dashboard/top-products").param("limit", "5"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].productId", is(product.getId().intValue())))
                .andExpect(jsonPath("$[0].quantitySold", is(2)));
    }

    @Test
    void imageUploadAcceptsAnImageAndCleansItsTestFile() throws Exception {
        Path uploadDirectory = Path.of("uploads");
        boolean directoryExisted = Files.exists(uploadDirectory);
        Path uploadedFile = null;

        try {
            MockMultipartFile image = new MockMultipartFile(
                    "file",
                    "test-image.png",
                    "image/png",
                    java.util.Base64.getDecoder().decode(
                            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aJfkAAAAASUVORK5CYII="));
            MvcResult result = mockMvc.perform(multipart("/api/upload").file(image))
                    .andExpect(status().isOk())
                    .andReturn();
            String savedPath = jsonString(result.getResponse().getContentAsString(), "path");
            uploadedFile = Path.of(savedPath);
            org.assertj.core.api.Assertions.assertThat(Files.exists(uploadedFile)).isTrue();
        } finally {
            if (uploadedFile != null) {
                Files.deleteIfExists(uploadedFile);
            }
            if (!directoryExisted && Files.isDirectory(uploadDirectory)) {
                Files.deleteIfExists(uploadDirectory);
            }
        }
    }

    private User createUser(String roleCode, String email, String password) {
        Role role = new Role();
        role.setRoleCode(roleCode);
        role.setRoleName(roleCode);
        entityManager.persist(role);

        User user = new User();
        user.setEmail(email);
        user.setFullName("Test user");
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setStatus("ACTIVE");
        user.setRole(role);
        entityManager.persist(user);
        entityManager.flush();
        return user;
    }

    private Order createOrder(User user, String status) {
        Order order = new Order();
        order.setUser(user);
        order.setStatus(status);
        order.setRecipientName(user.getFullName());
        order.setRecipientPhone(user.getPhone());
        order.setShippingAddress("Test address");
        order.setSubtotal(BigDecimal.ZERO);
        order.setDiscountAmount(BigDecimal.ZERO);
        order.setShippingFee(BigDecimal.ZERO);
        order.setTotalAmount(BigDecimal.ZERO);
        order.setCreatedAt(LocalDateTime.now());
        order.setUpdatedAt(LocalDateTime.now());
        entityManager.persist(order);
        entityManager.flush();
        return order;
    }

    private long jsonLong(String json, String fieldName) {
        return Long.parseLong(jsonValue(json, fieldName, "(\\d+)"));
    }

    private String jsonString(String json, String fieldName) {
        return jsonValue(json, fieldName, "\"([^\"]+)\"");
    }

    private String jsonValue(String json, String fieldName, String valuePattern) {
        Pattern pattern = Pattern.compile("\"" + fieldName + "\":" + valuePattern);
        Matcher matcher = pattern.matcher(json);
        if (!matcher.find()) {
            throw new AssertionError("JSON field not found: " + fieldName);
        }
        return matcher.group(1);
    }
}
