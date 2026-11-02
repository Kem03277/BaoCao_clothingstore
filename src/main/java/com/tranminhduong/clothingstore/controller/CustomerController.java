package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.ChangePasswordRequest;
import com.tranminhduong.clothingstore.dto.LoginRequest;
import com.tranminhduong.clothingstore.dto.LoginResponse;
import com.tranminhduong.clothingstore.dto.PageResponse;
import com.tranminhduong.clothingstore.dto.UserResponse;
import com.tranminhduong.clothingstore.dto.UserStatusRequest;
import com.tranminhduong.clothingstore.mapper.UserMapper;
import com.tranminhduong.clothingstore.security.AuthenticatedUser;
import com.tranminhduong.clothingstore.service.AuthenticationService;
import com.tranminhduong.clothingstore.service.CustomerService;
import com.tranminhduong.clothingstore.util.PageRequestFactory;
import org.springframework.data.domain.Sort;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/admin")
public class CustomerController {

    private final CustomerService customerService;
    private final AuthenticationService authenticationService;
    private final UserMapper userMapper;

    public CustomerController(
            CustomerService customerService,
            AuthenticationService authenticationService,
            UserMapper userMapper) {
        this.customerService = customerService;
        this.authenticationService = authenticationService;
        this.userMapper = userMapper;
    }

    // Chức năng: đăng nhập quản trị. Ví dụ: POST /api/admin/login
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody(required = false) LoginRequest request) {
        return ResponseEntity.ok(authenticationService.login(
                request == null ? null : request.email(),
                request == null ? null : request.password(),
                true));
    }

    // Chức năng: đổi mật khẩu quản trị. Ví dụ: PUT /api/admin/change-password
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

    // Chức năng: danh sách người dùng. Ví dụ: GET /api/admin/users
    @GetMapping("/users")
    public ResponseEntity<List<UserResponse>> getUsers() {
        return ResponseEntity.ok(customerService.getAllUsers().stream()
                .map(userMapper::toResponse)
                .toList());
    }

    @GetMapping("/users/page")
    @Transactional(readOnly = true)
    public ResponseEntity<PageResponse<UserResponse>> getUsersPage(
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        var users = customerService.searchUsers(
                keyword,
                PageRequestFactory.create(
                        page,
                        size,
                        Sort.by(Sort.Order.desc("createdAt"), Sort.Order.desc("id"))));
        return ResponseEntity.ok(PageResponse.from(users.map(userMapper::toResponse)));
    }

    // Chức năng: chi tiết người dùng. Ví dụ: GET /api/admin/users/1
    @GetMapping("/users/{id}")
    public ResponseEntity<UserResponse> getUser(@PathVariable("id") Long id) {
        return ResponseEntity.ok(userMapper.toResponse(customerService.getUserById(id)));
    }

    // Chức năng: khóa hoặc mở tài khoản. Ví dụ: PUT /api/admin/users/1/status
    @PutMapping("/users/{id}/status")
    public ResponseEntity<UserResponse> updateUserStatus(
            @PathVariable("id") Long id,
            @RequestBody(required = false) UserStatusRequest request) {
        return ResponseEntity.ok(userMapper.toResponse(
                customerService.updateUserStatus(id, request == null ? null : request.status())));
    }

    @PostMapping(value = "/users/{id}/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<UserResponse> updateAvatar(
            @PathVariable("id") Long id,
            @RequestPart("file") MultipartFile file) {
        return ResponseEntity.ok(userMapper.toResponse(customerService.updateAvatar(id, file)));
    }

}
