package com.tranminhduong.clothingstore.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Seeder nạp dữ liệu mẫu cho hệ thống Clothing Store.
 * Chỉ kích hoạt khi cấu hình app.seed.enabled=true.
 */
@Component
@ConditionalOnProperty(name = "app.seed.enabled", havingValue = "true", matchIfMissing = false)
public class DatabaseSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DatabaseSeeder.class);
    private static final String CATALOG_SECTION_MARKER = "-- CATALOG SEED SECTION";
    private final DataSource dataSource;
    private final org.springframework.core.env.Environment environment;

    public DatabaseSeeder(DataSource dataSource, org.springframework.core.env.Environment environment) {
        this.dataSource = dataSource;
        this.environment = environment;
    }

    @Override
    public void run(String... args) {
        if (isTestProfileActive()) {
            return;
        }

        boolean databaseHasData;
        try {
            databaseHasData = hasExistingData();
            try (Connection conn = dataSource.getConnection(); Statement stmt = conn.createStatement()) {
                stmt.execute("ALTER TABLE order_items MODIFY product_id BIGINT NULL");
            } catch (Exception ignored) {
            }
        } catch (SQLException exception) {
            log.error(">>> [SEEDER ERROR] Không thể kiểm tra database trước khi seed.", exception);
            return;
        }

        try {
            if (!databaseHasData) {
                log.info(">>> [SEEDER] Database trống -> Đang nạp dữ liệu mẫu ban đầu...");
            } else {
                log.info(">>> [SEEDER] Bỏ qua dữ liệu mẫu ban đầu vì database đã có dữ liệu.");
            }

            executeSeedScripts(!databaseHasData);
            if (!databaseHasData) {
                log.info(">>> [SEEDER SUCCESS] Đã nạp dữ liệu mẫu ban đầu.");
            }
            log.info(">>> [SEEDER SUCCESS] Đã cập nhật seed danh mục, thương hiệu và bài viết.");
        } catch (Exception e) {
            log.error(">>> [SEEDER ERROR] Quá trình seed dữ liệu gặp lỗi: {}", e.getMessage(), e);
        }
    }

    private void executeSeedScripts(boolean includeInitialData) throws IOException {
        String fileName = "seed_clothingstore.sql";
        Resource resource = new ClassPathResource(fileName);
        if (!resource.exists()) {
            resource = new FileSystemResource(fileName);
        }
        if (!resource.exists()) {
            throw new IllegalStateException("Không tìm thấy file " + fileName + " tại classpath hoặc thư mục gốc.");
        }

        String script;
        try (InputStream input = resource.getInputStream()) {
            script = new String(input.readAllBytes(), StandardCharsets.UTF_8);
        }

        int catalogSectionStart = script.indexOf(CATALOG_SECTION_MARKER);
        if (catalogSectionStart < 0) {
            throw new IllegalStateException("Không tìm thấy phần catalog trong " + fileName + ".");
        }

        if (includeInitialData) {
            executeSqlScript(script.substring(0, catalogSectionStart), fileName + " (initial data)");
        }
        executeSqlScript(
                script.substring(catalogSectionStart + CATALOG_SECTION_MARKER.length()),
                fileName + " (catalog)");
    }

    private void executeSqlScript(String script, String description) {
        ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
        populator.addScript(new ByteArrayResource(script.getBytes(StandardCharsets.UTF_8), description));
        populator.setSqlScriptEncoding(StandardCharsets.UTF_8.name());
        populator.setContinueOnError(false);
        populator.setIgnoreFailedDrops(true);
        populator.execute(dataSource);
    }

    private boolean hasExistingData() throws SQLException {
        try (Connection connection = dataSource.getConnection()) {
            DatabaseMetaData metadata = connection.getMetaData();
            String catalog = connection.getCatalog();
            String quote = metadata.getIdentifierQuoteString().trim();

            try (ResultSet tables = metadata.getTables(catalog, null, "%", new String[] { "TABLE" })) {
                while (tables.next()) {
                    String tableName = tables.getString("TABLE_NAME");
                    String query = "SELECT 1 FROM " + quote + tableName + quote + " LIMIT 1";
                    try (Statement statement = connection.createStatement();
                            ResultSet row = statement.executeQuery(query)) {
                        if (row.next()) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    private boolean isTestProfileActive() {
        String[] activeProfiles = environment.getActiveProfiles();
        for (String profile : activeProfiles) {
            if ("test".equalsIgnoreCase(profile)) {
                return true;
            }
        }
        return false;
    }
}
