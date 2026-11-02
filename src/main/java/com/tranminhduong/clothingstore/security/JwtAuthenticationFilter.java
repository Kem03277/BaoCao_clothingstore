package com.tranminhduong.clothingstore.security;

import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.repository.CustomerRepository;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtDecoder jwtDecoder;
    private final CustomerRepository userRepository;

    public JwtAuthenticationFilter(JwtDecoder jwtDecoder, CustomerRepository userRepository) {
        this.jwtDecoder = jwtDecoder;
        this.userRepository = userRepository;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        if (!"POST".equals(request.getMethod())) {
            return false;
        }
        String path = request.getRequestURI().substring(request.getContextPath().length());
        return "/api/auth/login".equals(path)
                || "/api/admin/login".equals(path)
                || "/api/auth/register".equals(path);
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {
        String authorization = request.getHeader(HttpHeaders.AUTHORIZATION);
        if (authorization == null || !authorization.regionMatches(true, 0, "Bearer ", 0, 7)) {
            filterChain.doFilter(request, response);
            return;
        }

        try {
            String token = authorization.substring(7).trim();
            if (token.isEmpty()) {
                throw new JwtException("Bearer token is empty");
            }
            Jwt jwt = jwtDecoder.decode(token);
            Long userId = Long.valueOf(jwt.getSubject());
            Object tokenVersionClaim = jwt.getClaims().get("token_version");
            boolean persistentAdminSession = Boolean.TRUE.equals(
                    jwt.getClaims().get("persistent_admin_session"));
            User user = userRepository.findWithRoleById(userId).orElse(null);
            long currentTokenVersion = user == null || user.getTokenVersion() == null
                    ? 0
                    : user.getTokenVersion().longValue();
            if (user == null
                    || !"ACTIVE".equalsIgnoreCase(user.getStatus())
                    || user.getRole() == null
                    || !(tokenVersionClaim instanceof Number tokenVersion)
                    || tokenVersion.longValue() != currentTokenVersion
                    || jwt.getIssuedAt() == null
                    || (jwt.getExpiresAt() == null && !persistentAdminSession)
                    || (persistentAdminSession && jwt.getExpiresAt() != null)
                    || jwt.getIssuedAt().isAfter(java.time.Instant.now())) {
                writeUnauthorized(request, response);
                return;
            }

            String roleCode = normalizeRole(user.getRole().getRoleCode());
            if (roleCode == null || (persistentAdminSession && !"ADMIN".equals(roleCode))) {
                writeUnauthorized(request, response);
                return;
            }
            AuthenticatedUser principal = new AuthenticatedUser(user.getId(), user.getEmail(), roleCode);
            UsernamePasswordAuthenticationToken authentication =
                    new UsernamePasswordAuthenticationToken(
                            principal,
                            null,
                            List.of(new SimpleGrantedAuthority("ROLE_" + roleCode)));
            SecurityContextHolder.getContext().setAuthentication(authentication);
        } catch (JwtException | IllegalArgumentException exception) {
            SecurityContextHolder.clearContext();
            writeUnauthorized(request, response);
            return;
        }

        filterChain.doFilter(request, response);
    }

    private String normalizeRole(String roleCode) {
        if (roleCode == null) {
            return null;
        }
        return switch (roleCode.toUpperCase()) {
            case "ADMIN" -> "ADMIN";
            case "STAFF" -> "STAFF";
            case "USER", "CUSTOMER" -> "USER";
            default -> null;
        };
    }

    private void writeUnauthorized(HttpServletRequest request, HttpServletResponse response) throws IOException {
        SecurityContextHolder.clearContext();
        SecurityErrorWriter.write(
                request, response, HttpStatus.UNAUTHORIZED, "Thông tin xác thực không hợp lệ hoặc đã hết hạn");
    }
}
