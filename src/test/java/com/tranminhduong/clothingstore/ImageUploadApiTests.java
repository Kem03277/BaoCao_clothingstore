package com.tranminhduong.clothingstore;

import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.ProductImage;
import com.tranminhduong.clothingstore.entity.Role;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.repository.ProductImageRepository;
import jakarta.persistence.EntityManager;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
@WithMockUser(authorities = "ROLE_ADMIN")
@Import(SecurityMockMvcTestConfig.class)
class ImageUploadApiTests {

    private static final byte[] PNG_IMAGE = Base64.getDecoder().decode(
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aJfkAAAAASUVORK5CYII=");

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private ProductImageRepository productImageRepository;

    private final List<Path> uploadedFiles = new ArrayList<>();
    private Long productId;
    private Long userId;

    @BeforeEach
    void setUp() {
        Category category = new Category();
        category.setName("Image test " + UUID.randomUUID());
        entityManager.persist(category);

        Product product = new Product();
        product.setName("Image test product");
        product.setPrice(10.0);
        product.setQuantity(1);
        product.setCategory(category);
        entityManager.persist(product);

        Role role = new Role();
        role.setRoleCode("CUSTOMER");
        role.setRoleName("Customer");
        entityManager.persist(role);

        User user = new User();
        user.setFullName("Image test user");
        user.setEmail(UUID.randomUUID() + "@example.com");
        user.setPasswordHash("not-returned");
        user.setStatus("ACTIVE");
        user.setRole(role);
        entityManager.persist(user);
        entityManager.flush();

        productId = product.getId();
        userId = user.getId();
    }

    @AfterEach
    void removeUploadedFiles() throws Exception {
        for (Path uploadedFile : uploadedFiles) {
            Files.deleteIfExists(uploadedFile);
        }
    }

    @Test
    void mainImageCanBeUploadedAndReplacedAndIsServedByItsUrl() throws Exception {
        String firstUrl = uploadMainImage("first.png");
        String secondUrl = uploadMainImage("second.png");

        org.assertj.core.api.Assertions.assertThat(secondUrl).isNotEqualTo(firstUrl);
        mockMvc.perform(get(secondUrl))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/products/{id}", productId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.mainImageUrl", is(secondUrl)))
                .andExpect(jsonPath("$.additionalImageUrls", hasSize(1)));
        mockMvc.perform(get("/api/products"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].mainImageUrl", is(secondUrl)));
    }

    @Test
    void additionalImagesAreAppendedWithoutReplacingMainImage() throws Exception {
        String mainUrl = uploadMainImage("main.png");
        MockMultipartFile firstImage = image("files", "first.png");
        MockMultipartFile secondImage = image("files", "second.png");

        var result = mockMvc.perform(multipart("/api/products/{id}/images", productId)
                        .file(firstImage)
                        .file(secondImage))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.mainImageUrl", is(mainUrl)))
                .andExpect(jsonPath("$.additionalImageUrls", hasSize(2)))
                .andReturn();
        trackImageUrls(result.getResponse().getContentAsString());
    }

    @Test
    void additionalImagesCanBeListedReplacedAndDeletedIndividually() throws Exception {
        String mainUrl = uploadMainImage("main.png");
        var uploadResult = mockMvc.perform(multipart("/api/products/{id}/images", productId)
                        .file(image("files", "additional.png")))
                .andExpect(status().isOk())
                .andReturn();
        trackImageUrls(uploadResult.getResponse().getContentAsString());

        ProductImage image = productImageRepository.findByProduct_IdOrderByIdAsc(productId).stream()
                .filter(item -> !Boolean.TRUE.equals(item.getPrimary()))
                .findFirst()
                .orElseThrow();

        mockMvc.perform(get("/api/products/{id}/images", productId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].id", is(image.getId().intValue())));

        String originalUrl = image.getImageUrl();
        var replaceResult = mockMvc.perform(multipart("/api/products/{id}/images/{imageId}", productId, image.getId())
                        .file(image("file", "replacement.png"))
                        .with(request -> {
                            request.setMethod("PUT");
                            return request;
                        }))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", is(image.getId().intValue())))
                .andReturn();
        String replacementUrl = jsonValue(replaceResult.getResponse().getContentAsString(), "imageUrl");
        trackFile(replacementUrl);
        org.assertj.core.api.Assertions.assertThat(replacementUrl).isNotEqualTo(originalUrl);

        mockMvc.perform(delete("/api/products/{id}/images/{imageId}", productId, image.getId()))
                .andExpect(status().isNoContent());
        mockMvc.perform(get("/api/products/{id}/images", productId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(0)));
        mockMvc.perform(get("/api/products/{id}", productId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.mainImageUrl", is(mainUrl)));
    }

    @Test
    void additionalImageEndpointsCannotModifyTheMainImage() throws Exception {
        uploadMainImage("main.png");
        ProductImage mainImage = productImageRepository.findByProduct_IdOrderByIdAsc(productId).stream()
                .filter(image -> Boolean.TRUE.equals(image.getPrimary()))
                .findFirst()
                .orElseThrow();

        mockMvc.perform(multipart("/api/products/{id}/images/{imageId}", productId, mainImage.getId())
                        .file(image("file", "replacement.png"))
                        .with(request -> {
                            request.setMethod("PUT");
                            return request;
                        }))
                .andExpect(status().isBadRequest());
        mockMvc.perform(delete("/api/products/{id}/images/{imageId}", productId, mainImage.getId()))
                .andExpect(status().isBadRequest());
    }

    @Test
    void avatarCanBeUploadedAndReplacedWithoutReturningPassword() throws Exception {
        mockMvc.perform(multipart("/api/admin/users/{id}/avatar", userId)
                        .file(image("file", "avatar.png")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.avatarUrl").isString())
                .andExpect(jsonPath("$.passwordHash").doesNotExist());

        String firstUrl = latestAvatarUrl();
        mockMvc.perform(multipart("/api/admin/users/{id}/avatar", userId)
                        .file(image("file", "new-avatar.png")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.avatarUrl").isNotEmpty())
                .andExpect(jsonPath("$.passwordHash").doesNotExist());
        org.assertj.core.api.Assertions.assertThat(latestAvatarUrl()).isNotEqualTo(firstUrl);
    }

    @Test
    void imageEndpointsRejectInvalidEmptyAndMissingFilesAndUnknownIds() throws Exception {
        MockMultipartFile invalidImage = new MockMultipartFile(
                "file", "not-an-image.png", MediaType.IMAGE_PNG_VALUE, new byte[] {1, 2, 3});
        MockMultipartFile emptyImage = new MockMultipartFile(
                "file", "empty.png", MediaType.IMAGE_PNG_VALUE, new byte[0]);

        mockMvc.perform(multipart("/api/products/{id}/main-image", productId).file(invalidImage))
                .andExpect(status().isBadRequest());
        mockMvc.perform(multipart("/api/products/{id}/main-image", productId).file(emptyImage))
                .andExpect(status().isBadRequest());
        mockMvc.perform(multipart("/api/products/{id}/main-image", -1L)
                        .file(image("file", "unknown-product.png")))
                .andExpect(status().isNotFound());
        mockMvc.perform(multipart("/api/products/{id}/images", productId))
                .andExpect(status().isBadRequest());
        mockMvc.perform(multipart("/api/admin/users/{id}/avatar", -1L)
                        .file(image("file", "unknown-user.png")))
                .andExpect(status().isNotFound());
    }

    private String uploadMainImage(String fileName) throws Exception {
        var result = mockMvc.perform(multipart("/api/products/{id}/main-image", productId)
                        .file(image("file", fileName)))
                .andExpect(status().isOk())
                .andReturn();
        String imageUrl = jsonValue(result.getResponse().getContentAsString(), "mainImageUrl");
        trackFile(imageUrl);
        return imageUrl;
    }

    private String latestAvatarUrl() throws Exception {
        var result = mockMvc.perform(get("/api/admin/users/{id}", userId))
                .andExpect(status().isOk())
                .andReturn();
        String imageUrl = jsonValue(result.getResponse().getContentAsString(), "avatarUrl");
        trackFile(imageUrl);
        return imageUrl;
    }

    private MockMultipartFile image(String fieldName, String fileName) {
        return new MockMultipartFile(fieldName, fileName, MediaType.IMAGE_PNG_VALUE, PNG_IMAGE);
    }

    private void trackFile(String imageUrl) {
        uploadedFiles.add(Path.of("uploads", imageUrl.substring(imageUrl.lastIndexOf('/') + 1)));
    }

    private void trackImageUrls(String json) {
        Matcher matcher = Pattern.compile("\"(/uploads/[^\"]+)\"").matcher(json);
        while (matcher.find()) {
            trackFile(matcher.group(1));
        }
    }

    private String jsonValue(String json, String key) throws Exception {
        Matcher matcher = Pattern.compile("\"" + key + "\"\\s*:\\s*\"([^\"]*)\"").matcher(json);
        if (!matcher.find()) {
            throw new AssertionError("JSON field not found: " + key);
        }
        return matcher.group(1);
    }
}
