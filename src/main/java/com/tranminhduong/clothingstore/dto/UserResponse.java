package com.tranminhduong.clothingstore.dto;

import java.time.LocalDateTime;

public record UserResponse(
        Long id,
        String fullName,
        String email,
        String phone,
        String status,
        String avatarUrl,
        LocalDateTime createdAt,
        Long roleId,
        String roleCode,
        String roleName) {
}
