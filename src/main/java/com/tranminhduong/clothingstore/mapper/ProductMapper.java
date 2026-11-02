package com.tranminhduong.clothingstore.mapper;

import com.tranminhduong.clothingstore.dto.ProductRequest;
import com.tranminhduong.clothingstore.dto.ProductResponse;
import com.tranminhduong.clothingstore.entity.Brand;
import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.entity.Gender;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.ProductImage;
import java.util.List;
import org.springframework.stereotype.Component;

@Component
public class ProductMapper {

    public Product toEntity(ProductRequest request) {
        if (request == null) {
            return null;
        }

        Category category = null;
        if (request.categoryId() != null) {
            category = new Category();
            category.setId(request.categoryId());
        }
        Brand brand = null;
        if (request.brandId() != null) {
            brand = new Brand();
            brand.setId(request.brandId());
        }
        Product product = new Product();
        product.setName(request.name());
        product.setDescription(request.description());
        product.setPrice(request.price());
        product.setQuantity(request.quantity());
        product.setCategory(category);
        product.setBrand(brand);
        product.setGender(request.gender() != null ? request.gender() : Gender.UNISEX);
        product.setTag(request.tag());
        return product;
    }

    public ProductResponse toResponse(Product product) {
        List<ProductImage> images = product.getImages() == null ? List.of() : product.getImages();
        ProductImage mainImage = images.stream()
                .filter(image -> Boolean.TRUE.equals(image.getPrimary()))
                .findFirst()
                .orElse(images.isEmpty() ? null : images.get(0));
        List<String> additionalImageUrls = images.stream()
                .filter(image -> mainImage == null || !image.getId().equals(mainImage.getId()))
                .map(ProductImage::getImageUrl)
                .toList();

        return new ProductResponse(
                product.getId(),
                product.getName(),
                product.getTag(),
                product.getDescription(),
                product.getPrice(),
                product.getQuantity(),
                product.getCategory() == null ? null : product.getCategory().getId(),
                product.getBrand() == null ? null : product.getBrand().getId(),
                mainImage == null ? null : mainImage.getImageUrl(),
                additionalImageUrls,
                product.getGender());
    }
}
