package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.dto.LoginResponse;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.mapper.UserMapper;
import com.tranminhduong.clothingstore.entity.Role;
import com.tranminhduong.clothingstore.repository.CustomerRepository;
import com.tranminhduong.clothingstore.repository.RoleRepository;
import com.tranminhduong.clothingstore.security.JwtService;
import java.nio.charset.StandardCharsets;
import java.util.Locale;
import java.util.Set;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthenticationService {

    private static final String INVALID_CREDENTIALS = "Email hoặc mật khẩu không chính xác";

    private final CustomerRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final UserMapper userMapper;

    public AuthenticationService(
            CustomerRepository userRepository,
            RoleRepository roleRepository,
            PasswordEncoder passwordEncoder,
            JwtService jwtService,
            UserMapper userMapper) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.userMapper = userMapper;
    }

    @Transactional
    public LoginResponse login(String email, String password, boolean adminEndpoint) {
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            throw new BadCredentialsException(INVALID_CREDENTIALS);
        }
        User user = userRepository.findByEmailIgnoreCase(email.trim())
                .orElseThrow(() -> new BadCredentialsException(INVALID_CREDENTIALS));

        String roleCode = user.getRole() == null ? null : user.getRole().getRoleCode();
        String normalizedRole = normalizeRole(roleCode);
        if (!"ACTIVE".equalsIgnoreCase(user.getStatus())
                || normalizedRole == null
                || (adminEndpoint && !Set.of("ADMIN", "STAFF").contains(normalizedRole))
                || user.getPasswordHash() == null
                || !passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new BadCredentialsException(INVALID_CREDENTIALS);
        }

        if (user.getTokenVersion() == null) {
            user.setTokenVersion(0);
            userRepository.save(user);
        }

        return new LoginResponse(
                jwtService.createToken(user, adminEndpoint && "ADMIN".equals(normalizedRole)),
                "Bearer",
                adminEndpoint && "ADMIN".equals(normalizedRole) ? 0 : jwtService.getExpiresInSeconds(),
                userMapper.toResponse(user));
    }

    @Transactional
    public void logout(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy tài khoản"));
        user.setTokenVersion(user.getTokenVersion() == null ? 1 : user.getTokenVersion() + 1);
    }

    @Transactional
    public User register(String fullName, String email, String password, String phone) {
        if (fullName == null || fullName.isBlank()) {
            throw new IllegalArgumentException("Tên người dùng không được để trống");
        }
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Email không được để trống");
        }
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 6 ký tự");
        }
        String trimmedEmail = email.trim();
        if (userRepository.findByEmailIgnoreCase(trimmedEmail).isPresent()) {
            throw new BadCredentialsException("Email đã được sử dụng");
        }

        Role userRole = roleRepository.findByRoleCodeIgnoreCase("USER")
                .orElseGet(() -> roleRepository.findByRoleCodeIgnoreCase("CUSTOMER")
                        .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy vai trò USER")));

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(trimmedEmail);
        user.setPasswordHash(passwordEncoder.encode(password));
        user.setPhone(phone);
        user.setStatus("ACTIVE");
        user.setTokenVersion(0);
        user.setRole(userRole);
        return userRepository.save(user);
    }

    @Transactional
    public User updateCurrentProfile(Long userId, String fullName, String phone) {
        User user = getCurrentUser(userId);
        if (fullName != null && !fullName.isBlank()) {
            user.setFullName(fullName.trim());
        }
        if (phone != null) {
            user.setPhone(phone.trim().isEmpty() ? null : phone.trim());
        }
        return userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public User getCurrentUser(Long userId) {
        return userRepository.findWithRoleById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy tài khoản"));
    }

    @Transactional
    public void changePassword(Long userId, String currentPassword, String newPassword) {
        User user = userRepository.findWithRoleById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy tài khoản"));
        if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
            throw new BadCredentialsException(INVALID_CREDENTIALS);
        }
        if (currentPassword == null
                || user.getPasswordHash() == null
                || !passwordEncoder.matches(currentPassword, user.getPasswordHash())) {
            throw new BadCredentialsException("Mật khẩu hiện tại không chính xác");
        }
        if (newPassword == null
                || newPassword.length() < 6
                || newPassword.getBytes(StandardCharsets.UTF_8).length > 72) {
            throw new IllegalArgumentException("Mật khẩu mới phải dài từ 6 đến 72 ký tự");
        }

        user.setPasswordHash(passwordEncoder.encode(newPassword));
        user.setTokenVersion(user.getTokenVersion() == null ? 1 : user.getTokenVersion() + 1);
    }

    private String normalizeRole(String roleCode) {
        if (roleCode == null) {
            return null;
        }
        return switch (roleCode.toUpperCase(Locale.ROOT)) {
            case "ADMIN", "STAFF", "USER" -> roleCode.toUpperCase(Locale.ROOT);
            case "CUSTOMER" -> "USER";
            default -> null;
        };
    }
}
