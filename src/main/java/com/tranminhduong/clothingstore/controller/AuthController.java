package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.ChangePasswordRequest;
import com.tranminhduong.clothingstore.dto.LoginRequest;
import com.tranminhduong.clothingstore.dto.LoginResponse;
import com.tranminhduong.clothingstore.dto.ProfileUpdateRequest;
import com.tranminhduong.clothingstore.dto.RegisterRequest;
import com.tranminhduong.clothingstore.dto.UserResponse;
import com.tranminhduong.clothingstore.mapper.UserMapper;
import com.tranminhduong.clothingstore.security.AuthenticatedUser;
import com.tranminhduong.clothingstore.service.AuthenticationService;
import com.tranminhduong.clothingstore.service.CustomerService;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationService authenticationService;
    private final CustomerService customerService;
    private final UserMapper userMapper;

    public AuthController(
            AuthenticationService authenticationService,
            CustomerService customerService,
            UserMapper userMapper) {
        this.authenticationService = authenticationService;
        this.customerService = customerService;
        this.userMapper = userMapper;
    }

    @PostMapping("/register")
    public ResponseEntity<UserResponse> register(@RequestBody(required = false) RegisterRequest request) {
        UserResponse response = userMapper.toResponse(authenticationService.register(
                request == null ? null : request.fullName(),
                request == null ? null : request.email(),
                request == null ? null : request.password(),
                request == null ? null : request.phone()));
        return ResponseEntity.status(201).body(response);
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody(required = false) LoginRequest request) {
        return ResponseEntity.ok(authenticationService.login(
                request == null ? null : request.email(),
                request == null ? null : request.password(),
                false));
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout(@AuthenticationPrincipal AuthenticatedUser currentUser) {
        authenticationService.logout(currentUser.id());
        return ResponseEntity.ok("Đăng xuất thành công");
    }

    @GetMapping("/me")
    public ResponseEntity<UserResponse> getCurrentUser(@AuthenticationPrincipal AuthenticatedUser currentUser) {
        return ResponseEntity.ok(userMapper.toResponse(
                authenticationService.getCurrentUser(currentUser.id())));
    }

    @PutMapping("/me")
    @PatchMapping("/me")
    public ResponseEntity<UserResponse> updateCurrentUser(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @RequestBody(required = false) ProfileUpdateRequest request) {
        return ResponseEntity.ok(userMapper.toResponse(authenticationService.updateCurrentProfile(
                currentUser.id(),
                request == null ? null : request.fullName(),
                request == null ? null : request.phone())));
    }

    @PutMapping("/change-password")
    public ResponseEntity<Void> changePassword(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @RequestBody(required = false) ChangePasswordRequest request) {
        authenticationService.changePassword(
                currentUser.id(),
                request == null ? null : request.currentPassword(),
                request == null ? null : request.newPassword());
        return ResponseEntity.noContent().build();
    }

    @PostMapping(value = "/me/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<UserResponse> updateOwnAvatar(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @RequestPart("file") MultipartFile file) {
        return ResponseEntity.ok(userMapper.toResponse(
                customerService.updateAvatar(currentUser.id(), file)));
    }
}
