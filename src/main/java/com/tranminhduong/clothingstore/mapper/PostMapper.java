package com.tranminhduong.clothingstore.mapper;

import com.tranminhduong.clothingstore.dto.PostResponse;
import com.tranminhduong.clothingstore.entity.Post;
import org.springframework.stereotype.Component;

@Component
public class PostMapper {
    public PostResponse toResponse(Post post) {
        if (post == null) {
            return null;
        }
        return new PostResponse(post.getId(), post.getTitle(), post.getSlug(), post.getThumbnailUrl(),
                post.getContent(), post.getStatus(), post.getPublishedAt(), post.getCreatedAt(),
                post.getPostCategory().getId(), post.getAuthor().getId(),
                post.getPostCategory().getCategoryName(), post.getPostCategory().getSlug(),
                post.getAuthor().getFullName());
    }
}