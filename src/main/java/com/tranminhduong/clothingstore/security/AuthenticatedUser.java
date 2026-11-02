package com.tranminhduong.clothingstore.security;

public record AuthenticatedUser(Long id, String email, String roleCode) {
}
