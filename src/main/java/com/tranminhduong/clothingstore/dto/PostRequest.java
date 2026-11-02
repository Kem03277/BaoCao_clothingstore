package com.tranminhduong.clothingstore.dto;

public record PostRequest(
        String title,
        String slug,
        String thumbnailUrl,
        String content,
        String status,
        Long postCategoryId) {
}
