package com.tranminhduong.clothingstore.config;

import com.tranminhduong.clothingstore.service.LegacyPasswordMigrationService;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

@Component
@ConditionalOnProperty(name = "security.password-migration.enabled", havingValue = "true")
public class LegacyPasswordMigrationRunner implements ApplicationRunner {

    private final LegacyPasswordMigrationService migrationService;

    public LegacyPasswordMigrationRunner(LegacyPasswordMigrationService migrationService) {
        this.migrationService = migrationService;
    }

    @Override
    public void run(ApplicationArguments args) {
        int migratedCount = migrationService.migrateLegacyPasswords();
        System.out.println("Legacy password migration completed. Updated account count: " + migratedCount);
    }
}
