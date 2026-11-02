package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Post;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.EntityGraph;

public interface PostRepository extends JpaRepository<Post, Long> {
    @EntityGraph(attributePaths = {"postCategory", "author"})
    @Query("SELECT post FROM Post post WHERE post.status = :status "
            + "AND COALESCE(post.deleted, false) = false ORDER BY post.publishedAt DESC")
    List<Post> findPublishedNotDeleted(@Param("status") String status);

    @EntityGraph(attributePaths = {"postCategory", "author"})
    @Query("SELECT post FROM Post post WHERE COALESCE(post.deleted, false) = false ORDER BY post.createdAt DESC")
    List<Post> findAllForManagement();

    @EntityGraph(attributePaths = {"postCategory", "author"})
    @Query("SELECT post FROM Post post WHERE post.status = :status AND COALESCE(post.deleted, false) = false "
            + "ORDER BY COALESCE(post.publishedAt, post.createdAt) DESC")
    List<Post> findForManagementByStatus(@Param("status") String status);

    @EntityGraph(attributePaths = {"postCategory", "author"})
    @Query("SELECT post FROM Post post WHERE post.id = :id AND COALESCE(post.deleted, false) = false")
    Optional<Post> findActiveWithDetailsById(@Param("id") Long id);

    @EntityGraph(attributePaths = {"postCategory", "author"})
    @Query("SELECT post FROM Post post WHERE post.id = :id AND post.deleted = true")
    Optional<Post> findDeletedWithDetailsById(@Param("id") Long id);

    @EntityGraph(attributePaths = {"postCategory", "author"})
    @Query("SELECT post FROM Post post WHERE post.deleted = true ORDER BY post.createdAt DESC")
    List<Post> findDeletedForManagement();

    boolean existsBySlug(String slug);

    boolean existsBySlugAndIdNot(String slug, Long id);
}