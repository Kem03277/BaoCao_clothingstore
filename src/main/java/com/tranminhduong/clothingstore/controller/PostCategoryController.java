package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.PostCategoryResponse;
import com.tranminhduong.clothingstore.repository.PostCategoryRepository;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/post-categories")
public class PostCategoryController {
    private final PostCategoryRepository postCategoryRepository;

    public PostCategoryController(PostCategoryRepository postCategoryRepository) {
        this.postCategoryRepository = postCategoryRepository;
    }

    @GetMapping
    public List<PostCategoryResponse> findActiveCategories() {
        return postCategoryRepository.findByStatusTrueOrderByCategoryNameAsc().stream()
                .map(category -> new PostCategoryResponse(
                        category.getId(), category.getCategoryName(), category.getSlug()))
                .toList();
    }
}
