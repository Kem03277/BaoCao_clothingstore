package com.tranminhduong.clothingstore.security;

import com.tranminhduong.clothingstore.entity.User;
import java.time.Instant;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.stereotype.Service;

@Service
public class JwtService {

    private final JwtEncoder jwtEncoder;
    private final long expiresInSeconds;

    public JwtService(
            JwtEncoder jwtEncoder,
            @Value("${security.jwt.access-token-minutes:1440}") long accessTokenMinutes) {
        if (accessTokenMinutes < 1) {
            throw new IllegalStateException("JWT access-token lifetime must be at least one minute");
        }
        this.jwtEncoder = jwtEncoder;
        this.expiresInSeconds = accessTokenMinutes * 60;
    }

    public String createToken(User user, boolean persistentAdminSession) {
        if (persistentAdminSession
                && (user.getRole() == null || !"ADMIN".equalsIgnoreCase(user.getRole().getRoleCode()))) {
            throw new IllegalArgumentException("Persistent sessions are only available to administrators");
        }
        Instant issuedAt = Instant.now();
        JwtClaimsSet.Builder claims = JwtClaimsSet.builder()
                .subject(user.getId().toString())
                .issuedAt(issuedAt)
                .claim("token_version", user.getTokenVersion() == null ? 0 : user.getTokenVersion())
                .claim("persistent_admin_session", persistentAdminSession);
        if (!persistentAdminSession) {
            claims.expiresAt(issuedAt.plusSeconds(expiresInSeconds));
        }

        return jwtEncoder.encode(JwtEncoderParameters.from(
                org.springframework.security.oauth2.jwt.JwsHeader.with(MacAlgorithm.HS256).build(),
                claims.build())).getTokenValue();
    }

    public long getExpiresInSeconds() {
        return expiresInSeconds;
    }
}
