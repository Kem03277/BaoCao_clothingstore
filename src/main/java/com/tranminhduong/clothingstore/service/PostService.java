package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.dto.PostRequest;
import com.tranminhduong.clothingstore.entity.Post;
import java.util.List;

public interface PostService {
    List<Post> findPublished();

    Post findPublishedById(Long id);

    List<Post> findForManagement(String status);

    List<Post> findDeletedForManagement();

    Post findForManagementById(Long id);

    Post create(PostRequest request, Long authorId);

    Post update(Long id, PostRequest request);

    void delete(Long id);

    void restoreDeleted(Long id);

    void restoreAllDeleted();

    void deletePermanently(Long id);
}