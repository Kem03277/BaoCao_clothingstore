package com.tranminhduong.clothingstore;

import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.Role;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.service.LegacyPasswordMigrationService;
import jakarta.persistence.EntityManager;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.transaction.annotation.Transactional;

import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class SecurityApiTests {

    private static final byte[] PNG_IMAGE = java.util.Base64.getDecoder().decode(
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aJfkAAAAASUVORK5CYII=");

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtEncoder jwtEncoder;

    @Autowired
    private JwtDecoder jwtDecoder;

    @Autowired
    private LegacyPasswordMigrationService passwordMigrationService;

    private Category category;
    private Product product;
    private final List<Path> uploadedFiles = new ArrayList<>();

    @BeforeEach
    void setUp() {
        category = new Category();
        category.setName("Security test " + UUID.randomUUID());
        entityManager.persist(category);
        product = new Product();
        product.setName("Security test product");
        product.setPrice(10.0);
        product.setQuantity(2);
        product.setCategory(category);
        entityManager.persist(product);
        entityManager.flush();
    }

    @AfterEach
    void removeUploadedFiles() throws Exception {
        for (Path uploadedFile : uploadedFiles) {
            Files.deleteIfExists(uploadedFile);
        }
    }

    @Test
    void adminStaffAndCustomerCanLoginAndReceiveBearerTokens() throws Exception {
        User admin = createUser("ADMIN", "admin", "ACTIVE");
        User staff = createUser("STAFF", "staff", "ACTIVE");
        User customer = createUser("CUSTOMER", "customer", "ACTIVE");

        login(admin, "/api/auth/login");
        login(staff, "/api/auth/login");
        login(customer, "/api/auth/login");
        login(admin, "/api/admin/login");
        login(staff, "/api/admin/login");
        mockMvc.perform(post("/api/admin/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(loginJson(customer)))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","password":"wrong-password"}
                                """.formatted(admin.getEmail())))
                .andExpect(status().isUnauthorized());

        User lockedUser = createUser("CUSTOMER", "locked", "LOCKED");
        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(loginJson(lockedUser)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void staleBearerTokenDoesNotBlockPublicLogin() throws Exception {
        User customer = createUser("CUSTOMER", "stale-session", "ACTIVE");

        mockMvc.perform(post("/api/auth/login")
                        .header("Authorization", "Bearer expired-or-invalid-token")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(loginJson(customer)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.accessToken").isNotEmpty());
    }

    @Test
    void adminPortalTokenDoesNotExpireAndLogoutRevokesIt() throws Exception {
        User admin = createUser("ADMIN", "persistent-admin", "ACTIVE");
        String token = login(admin, "/api/admin/login");
        org.springframework.security.oauth2.jwt.Jwt decoded = jwtDecoder.decode(token);

        org.assertj.core.api.Assertions.assertThat(decoded.getExpiresAt()).isNull();
        org.assertj.core.api.Assertions.assertThat(decoded.getClaimAsBoolean("persistent_admin_session")).isTrue();
        mockMvc.perform(get("/api/admin/users").header("Authorization", bearer(token)))
                .andExpect(status().isOk());

        mockMvc.perform(post("/api/auth/logout").header("Authorization", bearer(token)))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/admin/users").header("Authorization", bearer(token)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void missingTamperedAndExpiredTokensReturnUnauthorized() throws Exception {
        User admin = createUser("ADMIN", "secure", "ACTIVE");
        String validToken = login(admin, "/api/auth/login");
        String[] tokenParts = validToken.split("\\.");
        String signature = tokenParts[2];
        char replacement = signature.charAt(0) == 'A' ? 'B' : 'A';
        tokenParts[2] = replacement + signature.substring(1);
        String tamperedToken = String.join(".", tokenParts);

        mockMvc.perform(get("/api/admin/users"))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(get("/api/admin/users").header("Authorization", "Bearer invalid-token"))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(get("/api/admin/users").header("Authorization", "Bearer " + tamperedToken))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(get("/api/admin/users").header("Authorization", "Bearer " + expiredToken(admin)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void adminCanUseAdminApisAndStaffIsRestrictedByApiAndMethod() throws Exception {
        User admin = createUser("ADMIN", "admin-permissions", "ACTIVE");
        User staff = createUser("STAFF", "staff-permissions", "ACTIVE");
        String adminToken = login(admin, "/api/auth/login");
        String staffToken = login(staff, "/api/auth/login");

        mockMvc.perform(get("/api/admin/dashboard/orders-by-status").header("Authorization", bearer(adminToken)))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/admin/users").header("Authorization", bearer(adminToken)))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/admin/coupons").header("Authorization", bearer(adminToken)))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/admin/orders").header("Authorization", bearer(staffToken)))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/products").header("Authorization", bearer(staffToken)))
                .andExpect(status().isOk());
        mockMvc.perform(put("/api/products/{id}", product.getId())
                        .header("Authorization", bearer(staffToken))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "name":"Staff updated product",
                                  "description":"Updated by staff",
                                  "price":12.5,
                                  "quantity":3,
                                  "categoryId":%d
                                }
                                """.formatted(category.getId())))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name", is("Staff updated product")));
        mockMvc.perform(multipart("/api/products/{id}/images", product.getId())
                        .header("Authorization", bearer(staffToken))
                        .file(new org.springframework.mock.web.MockMultipartFile(
                                "files", "staff-image.png", "image/png", PNG_IMAGE)))
                .andExpect(status().isOk())
                .andDo(result -> trackUploadedImages(result.getResponse().getContentAsString()));
        mockMvc.perform(get("/api/inventory/low-stock").header("Authorization", bearer(staffToken)))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/admin/users").header("Authorization", bearer(staffToken)))
                .andExpect(status().isForbidden());
        mockMvc.perform(get("/api/admin/dashboard/orders-by-status").header("Authorization", bearer(staffToken)))
                .andExpect(status().isForbidden());
        mockMvc.perform(post("/api/admin/coupons").header("Authorization", bearer(staffToken)))
                .andExpect(status().isForbidden());
        mockMvc.perform(post("/api/inventory").header("Authorization", bearer(staffToken)))
                .andExpect(status().isForbidden());
        mockMvc.perform(post("/api/inventory")
                        .header("Authorization", bearer(adminToken))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"productId":%d,"quantity":2,"lowStockThreshold":1}
                                """.formatted(product.getId())))
                .andExpect(status().isOk());
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .delete("/api/products/{id}", product.getId())
                        .header("Authorization", bearer(staffToken)))
                .andExpect(status().isForbidden());
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                        .delete("/api/products/{id}", product.getId())
                        .header("Authorization", bearer(adminToken)))
                .andExpect(status().isNoContent());
        mockMvc.perform(get("/api/products/trash").header("Authorization", bearer(adminToken)))
                .andExpect(status().isOk());
        mockMvc.perform(post("/api/products/trash/restore-all").header("Authorization", bearer(adminToken)))
                .andExpect(status().isNoContent());
        mockMvc.perform(get("/api/products/trash").header("Authorization", bearer(staffToken)))
                .andExpect(status().isForbidden());
    }

    @Test
    void customersCanUseTheirOwnProfileAndPublicApisButNotAdminApis() throws Exception {
        User customer = createUser("CUSTOMER", "profile-owner", "ACTIVE");
        User otherCustomer = createUser("CUSTOMER", "profile-other", "ACTIVE");
        String token = login(customer, "/api/auth/login");

        mockMvc.perform(get("/api/auth/me").header("Authorization", bearer(token)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", is(customer.getId().intValue())))
                .andExpect(jsonPath("$.passwordHash").doesNotExist());
        mockMvc.perform(get("/api/categories"))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/admin/orders").header("Authorization", bearer(token)))
                .andExpect(status().isForbidden());
        mockMvc.perform(multipart("/api/admin/users/{id}/avatar", otherCustomer.getId())
                        .header("Authorization", bearer(token))
                        .file(new org.springframework.mock.web.MockMultipartFile(
                                "file", "avatar.png", "image/png", new byte[] {1})))
                .andExpect(status().isForbidden());

        mockMvc.perform(put("/api/auth/change-password")
                        .header("Authorization", bearer(token))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"currentPassword":"initial-password","newPassword":"new-password-123"}
                                """))
                .andExpect(status().isNoContent());
        mockMvc.perform(get("/api/auth/me").header("Authorization", bearer(token)))
                .andExpect(status().isUnauthorized());
        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","password":"new-password-123"}
                                """.formatted(customer.getEmail())))
                .andExpect(status().isOk());

        var avatarResult = mockMvc.perform(multipart("/api/auth/me/avatar")
                        .header("Authorization", bearer(loginWithCredentials(
                                "/api/auth/login", customer.getEmail(), "new-password-123")))
                        .file(new org.springframework.mock.web.MockMultipartFile(
                                "file", "own-avatar.png", "image/png", PNG_IMAGE)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", is(customer.getId().intValue())))
                .andReturn();
        trackUploadedImages(avatarResult.getResponse().getContentAsString());
    }

    @Test
    void statusAndRoleChangesInDatabaseTakeEffectOnNextRequest() throws Exception {
        User staff = createUser("STAFF", "staff-current-role", "ACTIVE");
        String token = login(staff, "/api/auth/login");
        mockMvc.perform(get("/api/admin/orders").header("Authorization", bearer(token)))
                .andExpect(status().isOk());

        staff.setRole(findOrCreateRole("CUSTOMER"));
        entityManager.flush();
        entityManager.clear();
        mockMvc.perform(get("/api/admin/orders").header("Authorization", bearer(token)))
                .andExpect(status().isForbidden());

        User activeUser = entityManager.find(User.class, staff.getId());
        activeUser.setStatus("LOCKED");
        entityManager.flush();
        mockMvc.perform(get("/api/auth/me").header("Authorization", bearer(token)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void publicProductAndCategoryApisWorkWithoutTokenButUnknownRoutesAreDenied() throws Exception {
        mockMvc.perform(get("/api/products"))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/categories"))
                .andExpect(status().isOk());
        mockMvc.perform(get("/api/admin/unknown"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void passwordMigrationHashesPlaintextAndLeavesExistingBcryptValuesUnchanged() {
        User legacyUser = createUser("CUSTOMER", "legacy-password", "ACTIVE");
        legacyUser.setPasswordHash("legacy-plaintext");
        User hashedUser = createUser("CUSTOMER", "hashed-password", "ACTIVE");
        String existingHash = hashedUser.getPasswordHash();
        entityManager.flush();

        org.assertj.core.api.Assertions.assertThat(passwordMigrationService.migrateLegacyPasswords()).isEqualTo(1);
        org.assertj.core.api.Assertions.assertThat(passwordEncoder.matches(
                "legacy-plaintext", legacyUser.getPasswordHash())).isTrue();
        org.assertj.core.api.Assertions.assertThat(hashedUser.getPasswordHash()).isEqualTo(existingHash);
    }

    private String login(User user, String path) throws Exception {
        return loginWithCredentials(path, user.getEmail(), "initial-password");
    }

    private String loginWithCredentials(String path, String email, String password) throws Exception {
        MvcResult result = mockMvc.perform(post(path)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {"email":"%s","password":"%s"}
                                """.formatted(email, password)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.tokenType", is("Bearer")))
                .andExpect(jsonPath("$.expiresInSeconds", is(
                        "/api/admin/login".equals(path) && "ADMIN".equals(userRole(email)) ? 0 : 1800)))
                .andExpect(jsonPath("$.user.passwordHash").doesNotExist())
                .andReturn();
        return jsonValue(result, "accessToken");
    }

    private String userRole(String email) {
        return entityManager.createQuery(
                        "SELECT role.roleCode FROM User user JOIN user.role role WHERE user.email = :email",
                        String.class)
                .setParameter("email", email)
                .getSingleResult();
    }

    private String loginJson(User user) {
        return """
                {"email":"%s","password":"initial-password"}
                """.formatted(user.getEmail());
    }

    private User createUser(String roleCode, String name, String status) {
        User user = new User();
        user.setFullName(name);
        user.setEmail(name + "-" + UUID.randomUUID() + "@example.test");
        user.setPasswordHash(passwordEncoder.encode("initial-password"));
        user.setStatus(status);
        user.setRole(findOrCreateRole(roleCode));
        entityManager.persist(user);
        entityManager.flush();
        return user;
    }

    private Role findOrCreateRole(String roleCode) {
        List<Role> existingRoles = entityManager.createQuery(
                        "SELECT role FROM Role role WHERE UPPER(role.roleCode) = :roleCode", Role.class)
                .setParameter("roleCode", roleCode)
                .setMaxResults(1)
                .getResultList();
        if (!existingRoles.isEmpty()) {
            return existingRoles.get(0);
        }
        Role role = new Role();
        role.setRoleCode(roleCode);
        role.setRoleName(roleCode);
        entityManager.persist(role);
        return role;
    }

    private String expiredToken(User user) {
        Instant now = Instant.now();
        JwtClaimsSet claims = JwtClaimsSet.builder()
                .subject(user.getId().toString())
                .issuedAt(now.minusSeconds(120))
                .expiresAt(now.minusSeconds(60))
                .claim("token_version", user.getTokenVersion())
                .build();
        return jwtEncoder.encode(JwtEncoderParameters.from(
                org.springframework.security.oauth2.jwt.JwsHeader.with(MacAlgorithm.HS256).build(),
                claims)).getTokenValue();
    }

    private String bearer(String token) {
        return "Bearer " + token;
    }

    private void trackUploadedImages(String json) {
        Matcher matcher = Pattern.compile("\"(/uploads/[^\"]+)\"").matcher(json);
        while (matcher.find()) {
            uploadedFiles.add(Path.of("uploads", matcher.group(1).substring("/uploads/".length())));
        }
    }

    private String jsonValue(MvcResult result, String fieldName) throws Exception {
        Matcher matcher = Pattern.compile("\"" + fieldName + "\"\\s*:\\s*\"([^\"]+)\"")
                .matcher(result.getResponse().getContentAsString());
        if (!matcher.find()) {
            throw new AssertionError("JSON field not found: " + fieldName);
        }
        return matcher.group(1);
    }
}
