package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.PostResponse;
import com.tranminhduong.clothingstore.dto.PostRequest;
import com.tranminhduong.clothingstore.mapper.PostMapper;
import com.tranminhduong.clothingstore.security.AuthenticatedUser;
import com.tranminhduong.clothingstore.service.PostService;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/posts")
public class PostController {
    private final PostService postService;
    private final PostMapper postMapper;

    public PostController(PostService postService, PostMapper postMapper) {
        this.postService = postService;
        this.postMapper = postMapper;
    }

    @GetMapping
    public List<PostResponse> findPublished() {
        return postService.findPublished().stream().map(postMapper::toResponse).toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<PostResponse> findPublishedById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(postMapper.toResponse(postService.findPublishedById(id)));
    }

    @GetMapping("/manage")
    public List<PostResponse> findForManagement(@RequestParam(required = false) String status) {
        return postService.findForManagement(status).stream().map(postMapper::toResponse).toList();
    }

    @GetMapping("/manage/trash")
    public List<PostResponse> findDeletedForManagement() {
        return postService.findDeletedForManagement().stream().map(postMapper::toResponse).toList();
    }

    @GetMapping("/manage/{id}")
    public ResponseEntity<PostResponse> findForManagementById(@PathVariable Long id) {
        return ResponseEntity.ok(postMapper.toResponse(postService.findForManagementById(id)));
    }

    @PostMapping
    public ResponseEntity<PostResponse> create(
            @RequestBody PostRequest request,
            @AuthenticationPrincipal AuthenticatedUser currentUser) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(postMapper.toResponse(postService.create(request, currentUser.id())));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PostResponse> update(
            @PathVariable Long id,
            @RequestBody PostRequest request) {
        return ResponseEntity.ok(postMapper.toResponse(postService.update(id, request)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        postService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/manage/trash/{id}/restore")
    public ResponseEntity<Void> restoreDeleted(@PathVariable Long id) {
        postService.restoreDeleted(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/manage/trash/restore-all")
    public ResponseEntity<Void> restoreAllDeleted() {
        postService.restoreAllDeleted();
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/manage/trash/{id}")
    public ResponseEntity<Void> deletePermanently(@PathVariable Long id) {
        postService.deletePermanently(id);
        return ResponseEntity.noContent().build();
    }
}