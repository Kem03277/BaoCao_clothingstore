package com.tranminhduong.clothingstore.dto;

import java.time.LocalDateTime;

public record PostResponse(Long id, String title, String slug, String thumbnailUrl, String content,
        String status, LocalDateTime publishedAt, LocalDateTime createdAt, Long postCategoryId, Long authorId,
        String postCategoryName, String postCategorySlug, String authorName) {
}