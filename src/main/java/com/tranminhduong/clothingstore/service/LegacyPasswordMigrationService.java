package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.repository.CustomerRepository;
import java.util.List;
import java.util.regex.Pattern;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LegacyPasswordMigrationService {

    private static final Pattern BCRYPT_HASH =
            Pattern.compile("\\$2[aby]\\$\\d{2}\\$[./A-Za-z0-9]{53}");

    private final CustomerRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public LegacyPasswordMigrationService(
            CustomerRepository userRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public int migrateLegacyPasswords() {
        List<User> users = userRepository.findAll();
        int migratedCount = 0;
        for (User user : users) {
            String storedPassword = user.getPasswordHash();
            if (storedPassword != null && !BCRYPT_HASH.matcher(storedPassword).matches()) {
                user.setPasswordHash(passwordEncoder.encode(storedPassword));
                migratedCount++;
            }
        }
        return migratedCount;
    }
}
