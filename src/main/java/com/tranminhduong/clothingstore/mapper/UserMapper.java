package com.tranminhduong.clothingstore.mapper;

import com.tranminhduong.clothingstore.dto.UserResponse;
import com.tranminhduong.clothingstore.entity.User;
import org.springframework.stereotype.Component;

@Component
public class UserMapper {

    public UserResponse toResponse(User user) {
        if (user == null) {
            return null;
        }
        return new UserResponse(
                user.getId(),
                user.getFullName(),
                user.getEmail(),
                user.getPhone(),
                user.getStatus(),
                user.getAvatarUrl(),
                user.getCreatedAt(),
                user.getRole() == null ? null : user.getRole().getId(),
                user.getRole() == null ? null : user.getRole().getRoleCode(),
                user.getRole() == null ? null : user.getRole().getRoleName());
    }

}
