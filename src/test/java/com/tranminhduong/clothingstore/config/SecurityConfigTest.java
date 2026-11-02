package com.tranminhduong.clothingstore.config;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

import java.util.Arrays;
import javax.crypto.SecretKey;
import org.junit.jupiter.api.Test;

class SecurityConfigTest {

    private final SecurityConfig securityConfig = new SecurityConfig();

    @Test
    void generatesRandomJwtSecretWhenNotConfigured() {
        SecretKey firstKey = securityConfig.jwtSecretKey("");
        SecretKey secondKey = securityConfig.jwtSecretKey("");

        assertEquals("HmacSHA256", firstKey.getAlgorithm());
        assertEquals(32, firstKey.getEncoded().length);
        assertFalse(Arrays.equals(firstKey.getEncoded(), secondKey.getEncoded()));
    }
}
