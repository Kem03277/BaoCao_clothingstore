package com.tranminhduong.clothingstore;

import com.tranminhduong.clothingstore.entity.Brand;
import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.entity.Product;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.hasItem;
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
class CategoryBrandAdminApiTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private EntityManager entityManager;

    @Test
    void categoryCanBeCreatedUpdatedAndDeleted() throws Exception {
        var createResult = mockMvc.perform(post("/api/categories")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"name":"Admin category test","description":"Category description"}
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("Admin category test")))
                .andReturn();
        Long categoryId = readId(createResult.getResponse().getContentAsString());

        mockMvc.perform(put("/api/categories/{id}", categoryId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"name":"Updated category test","description":"Updated"}
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("Updated category test")));

        mockMvc.perform(delete("/api/categories/{id}", categoryId))
                .andExpect(status().isNoContent());
    }

    @Test
    void brandCanBeManagedIncludingInactiveBrands() throws Exception {
        var createResult = mockMvc.perform(post("/api/brands")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "brandName":"Admin brand test",
                                  "logoUrl":"https://example.com/logo.png",
                                  "description":"Brand description",
                                  "status":false
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.brandName", is("Admin brand test")))
                .andExpect(jsonPath("$.status", is(false)))
                .andReturn();
        Long brandId = readId(createResult.getResponse().getContentAsString());

        mockMvc.perform(get("/api/brands/manage"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[*].id", hasItem(brandId.intValue())));

        mockMvc.perform(put("/api/brands/{id}", brandId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "brandName":"Updated admin brand",
                                  "logoUrl":"",
                                  "description":"Updated",
                                  "status":true
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.brandName", is("Updated admin brand")))
                .andExpect(jsonPath("$.status", is(true)));

        mockMvc.perform(delete("/api/brands/{id}", brandId))
                .andExpect(status().isNoContent());
    }

    @Test
    void categoriesAndBrandsInUseCanBeSoftDeletedButNotPermanentlyDeleted() throws Exception {
        Category category = new Category();
        category.setName("Referenced category");
        entityManager.persist(category);

        Brand brand = new Brand();
        brand.setBrandName("Referenced brand");
        entityManager.persist(brand);

        Product product = new Product();
        product.setName("Referenced product");
        product.setPrice(100.0);
        product.setQuantity(1);
        product.setCategory(category);
        product.setBrand(brand);
        entityManager.persist(product);
        entityManager.flush();

        mockMvc.perform(delete("/api/categories/{id}", category.getId()))
                .andExpect(status().isNoContent());
        mockMvc.perform(delete("/api/brands/{id}", brand.getId()))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/categories/trash"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[*].id", hasItem(category.getId().intValue())));
        mockMvc.perform(get("/api/brands/trash"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[*].id", hasItem(brand.getId().intValue())));

        mockMvc.perform(delete("/api/categories/trash/{id}", category.getId()))
                .andExpect(status().isBadRequest());
        mockMvc.perform(delete("/api/brands/trash/{id}", brand.getId()))
                .andExpect(status().isBadRequest());

        mockMvc.perform(post("/api/categories/trash/{id}/restore", category.getId()))
                .andExpect(status().isNoContent());
        mockMvc.perform(post("/api/brands/trash/{id}/restore", brand.getId()))
                .andExpect(status().isNoContent());
    }

    private Long readId(String json) {
        var matcher = java.util.regex.Pattern.compile("\"id\"\\s*:\\s*(\\d+)")
                .matcher(json);
        if (!matcher.find()) {
            throw new AssertionError("ID not found in response");
        }
        return Long.valueOf(matcher.group(1));
    }
}
