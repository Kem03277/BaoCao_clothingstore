package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.service.ProductService;
import com.tranminhduong.clothingstore.dto.ProductRequest;
import com.tranminhduong.clothingstore.dto.ProductResponse;
import com.tranminhduong.clothingstore.dto.ProductImageResponse;
import com.tranminhduong.clothingstore.dto.PageResponse;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.ProductImage;
import com.tranminhduong.clothingstore.entity.Gender;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.mapper.ProductMapper;
import com.tranminhduong.clothingstore.util.PageRequestFactory;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.transaction.annotation.Transactional;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;
    private final ProductMapper productMapper;

    public ProductController(ProductService productService, ProductMapper productMapper) {
        this.productService = productService;
        this.productMapper = productMapper;
    }

    @GetMapping
    @Transactional(readOnly = true)
    public List<ProductResponse> getAllProducts(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Long brandId,
            @RequestParam(required = false) Gender gender,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "newest") String sort,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size) {
        return searchPage(false, categoryId, brandId, gender, minPrice, maxPrice, keyword, sort, page, size)
                .getContent()
                .stream()
                .map(productMapper::toResponse)
                .toList();
    }

    @GetMapping("/page")
    @Transactional(readOnly = true)
    public PageResponse<ProductResponse> getProductPage(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Long brandId,
            @RequestParam(required = false) Gender gender,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "newest") String sort,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size) {
        return PageResponse.from(searchPage(
                false, categoryId, brandId, gender, minPrice, maxPrice, keyword, sort, page, size)
                .map(productMapper::toResponse));
    }

    @GetMapping("/manage/page")
    @Transactional(readOnly = true)
    public PageResponse<ProductResponse> getManagedProductPage(
            @RequestParam(defaultValue = "false") boolean deleted,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "newest") String sort,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return PageResponse.from(searchPage(deleted, null, null, null, null, null, keyword, sort, page, size)
                .map(productMapper::toResponse));
    }

    private Page<Product> searchPage(
            boolean deleted,
            Long categoryId,
            Long brandId,
            Gender gender,
            Double minPrice,
            Double maxPrice,
            String keyword,
            String sort,
            Integer page,
            Integer size) {
        Double effectiveMin = normalizePrice(minPrice);
        Double effectiveMax = normalizePrice(maxPrice);
        Pageable pageable = PageRequestFactory.create(page, size, productSort(sort));
        return productService.searchProducts(
                deleted, categoryId, brandId, gender, effectiveMin, effectiveMax, keyword, pageable);
    }

    private Double normalizePrice(Double price) {
        if (price == null || price <= 0 || price >= 1000) {
            return price;
        }
        return price * 1000;
    }

    private Sort productSort(String sort) {
        String normalizedSort = sort == null ? "newest" : sort.toLowerCase(Locale.ROOT);
        return switch (normalizedSort) {
            case "price_asc" -> Sort.by(Sort.Order.asc("price"), Sort.Order.desc("id"));
            case "price_desc" -> Sort.by(Sort.Order.desc("price"), Sort.Order.desc("id"));
            case "name_asc" -> Sort.by(Sort.Order.asc("name").ignoreCase(), Sort.Order.desc("id"));
            case "name_desc" -> Sort.by(Sort.Order.desc("name").ignoreCase(), Sort.Order.desc("id"));
            default -> Sort.by(Sort.Order.desc("id"));
        };
    }

    @GetMapping("/search")
    @Transactional(readOnly = true)
    public List<ProductResponse> searchProducts(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Long brandId,
            @RequestParam(required = false) Gender gender,
            @RequestParam(required = false) Double minPrice,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(defaultValue = "newest") String sort,
            @RequestParam(defaultValue = "0") Integer page,
            @RequestParam(defaultValue = "20") Integer size) {
        return getAllProducts(categoryId, brandId, gender, minPrice, maxPrice, keyword, sort, page, size);
    }

    @GetMapping("/featured")
    public List<ProductResponse> getFeaturedProducts() {
        return productService.getAllProducts().stream()
                .filter(product -> product.getTag() != null
                        && "hot".equalsIgnoreCase(product.getTag().trim()))
                .sorted(Comparator.comparing(Product::getId).reversed())
                .limit(8)
                .map(productMapper::toResponse)
                .toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProductResponse> getProductById(@PathVariable("id") Long id) {
        Product product = productService.getProductById(id);
        if (product == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(productMapper.toResponse(product));
    }

    @GetMapping("/category/{categoryId}")
    public List<ProductResponse> getProductsByCategory(@PathVariable Long categoryId) {
        return getAllProducts(categoryId, null, null, null, null, null, "newest", 0, 50);
    }

    @GetMapping("/brand/{brandId}")
    public List<ProductResponse> getProductsByBrand(@PathVariable Long brandId) {
        return getAllProducts(null, brandId, null, null, null, null, "newest", 0, 50);
    }

    @PostMapping
    public ResponseEntity<ProductResponse> createProduct(@RequestBody ProductRequest request) {
        Product product = productMapper.toEntity(request);
        Product createdProduct = productService.create(product, request.imageUrl());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(productMapper.toResponse(createdProduct));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProductResponse> updateProduct(
            @PathVariable("id") Long id,
            @RequestBody ProductRequest request) {
        Product updatedProduct = productService.update(id, productMapper.toEntity(request));
        return ResponseEntity.ok(productMapper.toResponse(updatedProduct));
    }

    @PostMapping(value = "/{id}/main-image", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ProductResponse> updateMainImage(
            @PathVariable("id") Long id,
            @RequestPart("file") MultipartFile file) {
        return ResponseEntity.ok(productMapper.toResponse(productService.updateMainImage(id, file)));
    }

    @PostMapping(value = "/{id}/images", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ProductResponse> addImages(
            @PathVariable("id") Long id,
            @RequestPart("files") List<MultipartFile> files) {
        return ResponseEntity.ok(productMapper.toResponse(productService.addImages(id, files)));
    }

    @GetMapping("/{id}/images")
    public List<ProductImageResponse> getAdditionalImages(@PathVariable("id") Long id) {
        return productService.getAdditionalImages(id).stream()
                .map(this::toImageResponse)
                .toList();
    }

    @PutMapping(value = "/{id}/images/{imageId}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<ProductImageResponse> updateAdditionalImage(
            @PathVariable("id") Long id,
            @PathVariable("imageId") Long imageId,
            @RequestPart("file") MultipartFile file) {
        return ResponseEntity.ok(toImageResponse(productService.updateAdditionalImage(id, imageId, file)));
    }

    @DeleteMapping("/{id}/images/{imageId}")
    public ResponseEntity<Void> deleteAdditionalImage(
            @PathVariable("id") Long id,
            @PathVariable("imageId") Long imageId) {
        productService.deleteAdditionalImage(id, imageId);
        return ResponseEntity.noContent().build();
    }

    private ProductImageResponse toImageResponse(ProductImage image) {
        return new ProductImageResponse(image.getId(), image.getImageUrl(), image.getAltText());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable("id") Long id) {
        productService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/trash")
    public List<ProductResponse> getDeletedProducts() {
        return productService.getDeletedProducts().stream()
                .map(productMapper::toResponse)
                .toList();
    }

    @DeleteMapping("/trash/{id}")
    public ResponseEntity<Void> deletePermanently(@PathVariable("id") Long id) {
        productService.deletePermanently(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/trash/{id}/restore")
    public ResponseEntity<Void> restoreDeleted(@PathVariable("id") Long id) {
        productService.restoreDeleted(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/trash/restore-all")
    public ResponseEntity<Void> restoreAllDeleted() {
        productService.restoreAllDeleted();
        return ResponseEntity.noContent().build();
    }
}
