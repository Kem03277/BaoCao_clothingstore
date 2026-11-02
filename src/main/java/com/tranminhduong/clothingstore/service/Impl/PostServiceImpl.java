package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.dto.PostRequest;
import com.tranminhduong.clothingstore.entity.Post;
import com.tranminhduong.clothingstore.entity.PostCategory;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.repository.CustomerRepository;
import com.tranminhduong.clothingstore.repository.PostCategoryRepository;
import com.tranminhduong.clothingstore.repository.PostRepository;
import com.tranminhduong.clothingstore.service.PostService;
import java.text.Normalizer;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class PostServiceImpl implements PostService {
    private final PostRepository postRepository;
    private final PostCategoryRepository postCategoryRepository;
    private final CustomerRepository userRepository;

    public PostServiceImpl(
            PostRepository postRepository,
            PostCategoryRepository postCategoryRepository,
            CustomerRepository userRepository) {
        this.postRepository = postRepository;
        this.postCategoryRepository = postCategoryRepository;
        this.userRepository = userRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Post> findPublished() {
        return postRepository.findPublishedNotDeleted("PUBLISHED");
    }

    @Override
    @Transactional(readOnly = true)
    public Post findPublishedById(Long id) {
        Post post = postRepository.findActiveWithDetailsById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy bài viết có id = " + id));
        if (!"PUBLISHED".equalsIgnoreCase(post.getStatus())) {
            throw new ResourceNotFoundException("Không tìm thấy bài viết có id = " + id);
        }
        return post;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Post> findForManagement(String status) {
        if (status == null || status.isBlank() || "ALL".equalsIgnoreCase(status.trim())) {
            return postRepository.findAllForManagement();
        }
        String normalizedStatus = normalizeStatus(status);
        return postRepository.findForManagementByStatus(normalizedStatus);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Post> findDeletedForManagement() {
        return postRepository.findDeletedForManagement();
    }

    @Override
    @Transactional(readOnly = true)
    public Post findForManagementById(Long id) {
        return postRepository.findActiveWithDetailsById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy bài viết có id = " + id));
    }

    @Override
    public Post create(PostRequest request, Long authorId) {
        Post post = new Post();
        applyRequest(post, request);
        post.setAuthor(userRepository.findById(authorId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy tác giả")));
        post.setCreatedAt(LocalDateTime.now());
        return postRepository.save(post);
    }

    @Override
    public Post update(Long id, PostRequest request) {
        Post post = findForManagementById(id);
        applyRequest(post, request);
        return postRepository.save(post);
    }

    @Override
    public void delete(Long id) {
        Post post = findForManagementById(id);
        post.setDeleted(true);
        postRepository.save(post);
    }

    @Override
    public void restoreDeleted(Long id) {
        Post post = postRepository.findDeletedWithDetailsById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy bài viết trong thùng rác có id = " + id));
        post.setDeleted(false);
        postRepository.save(post);
    }

    @Override
    public void restoreAllDeleted() {
        postRepository.findDeletedForManagement().forEach(post -> post.setDeleted(false));
    }

    @Override
    public void deletePermanently(Long id) {
        Post post = postRepository.findDeletedWithDetailsById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy bài viết trong thùng rác có id = " + id));
        postRepository.delete(post);
    }

    private void applyRequest(Post post, PostRequest request) {
        if (request == null || request.title() == null || request.title().isBlank()) {
            throw new IllegalArgumentException("Tiêu đề bài viết không được để trống");
        }
        if (request.title().trim().length() > 200) {
            throw new IllegalArgumentException("Tiêu đề bài viết tối đa 200 ký tự");
        }
        if (request.content() == null || request.content().isBlank()) {
            throw new IllegalArgumentException("Nội dung bài viết không được để trống");
        }
        if (request.thumbnailUrl() != null && request.thumbnailUrl().trim().length() > 500) {
            throw new IllegalArgumentException("Đường dẫn ảnh bìa tối đa 500 ký tự");
        }

        String status = normalizeStatus(request.status());
        Long categoryId = request.postCategoryId();
        if (categoryId == null) {
            throw new IllegalArgumentException("Vui lòng chọn danh mục bài viết");
        }
        PostCategory category = postCategoryRepository.findById(categoryId)
                .filter(item -> Boolean.TRUE.equals(item.getStatus()))
                .orElseThrow(() -> new ResourceNotFoundException("Danh mục bài viết không tồn tại hoặc đã ẩn"));

        boolean wasPublished = "PUBLISHED".equalsIgnoreCase(post.getStatus());
        post.setTitle(request.title().trim());
        post.setSlug(uniqueSlug(request.slug(), request.title(), post.getId()));
        post.setThumbnailUrl(blankToNull(request.thumbnailUrl()));
        post.setContent(request.content().trim());
        post.setStatus(status);
        post.setPublishedAt("PUBLISHED".equals(status)
                ? (wasPublished && post.getPublishedAt() != null ? post.getPublishedAt() : LocalDateTime.now())
                : null);
        post.setPostCategory(category);
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            throw new IllegalArgumentException("Trạng thái bài viết không được để trống");
        }
        String normalized = status.trim().toUpperCase(Locale.ROOT);
        if (!"DRAFT".equals(normalized) && !"PUBLISHED".equals(normalized)) {
            throw new IllegalArgumentException("Trạng thái chỉ được là DRAFT hoặc PUBLISHED");
        }
        return normalized;
    }

    private String uniqueSlug(String requestedSlug, String title, Long postId) {
        String base = slugify(requestedSlug == null || requestedSlug.isBlank() ? title : requestedSlug);
        if (base.isBlank()) {
            throw new IllegalArgumentException("Không thể tạo đường dẫn bài viết từ tiêu đề này");
        }
        base = base.substring(0, Math.min(base.length(), 220));
        String candidate = base;
        int suffix = 2;
        while (postId == null
                ? postRepository.existsBySlug(candidate)
                : postRepository.existsBySlugAndIdNot(candidate, postId)) {
            String suffixText = "-" + suffix++;
            candidate = base.substring(0, Math.min(base.length(), 220 - suffixText.length())) + suffixText;
        }
        return candidate;
    }

    private String slugify(String value) {
        String normalized = Normalizer.normalize(value.trim().toLowerCase(Locale.ROOT), Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .replace('đ', 'd');
        return normalized.replaceAll("[^a-z0-9]+", "-").replaceAll("(^-+|-+$)", "");
    }

    private String blankToNull(String value) {
        return value == null || value.isBlank() ? null : value.trim();
    }
}
