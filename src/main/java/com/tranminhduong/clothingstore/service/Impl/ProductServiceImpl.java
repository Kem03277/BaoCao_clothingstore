package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.entity.Category;
import com.tranminhduong.clothingstore.entity.Brand;
import com.tranminhduong.clothingstore.entity.Gender;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.ProductImage;
import com.tranminhduong.clothingstore.dto.UploadResponse;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.repository.CategoryRepository;
import com.tranminhduong.clothingstore.repository.ProductImageRepository;
import com.tranminhduong.clothingstore.repository.ProductRepository;
import com.tranminhduong.clothingstore.repository.ProductSpecifications;
import com.tranminhduong.clothingstore.service.ProductService;
import com.tranminhduong.clothingstore.service.UploadService;
import jakarta.persistence.EntityManager;

import java.util.ArrayList;
import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final ProductImageRepository productImageRepository;
    private final CategoryRepository categoryRepository;
    private final EntityManager entityManager;
    private final UploadService uploadService;

    public ProductServiceImpl(
            ProductRepository productRepository,
            ProductImageRepository productImageRepository,
            CategoryRepository categoryRepository,
            EntityManager entityManager,
            UploadService uploadService) {
        this.productRepository = productRepository;
        this.productImageRepository = productImageRepository;
        this.categoryRepository = categoryRepository;
        this.entityManager = entityManager;
        this.uploadService = uploadService;
    }

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findActiveProducts();
    }

    @Override
    public Product getProductById(Long id) {
        return productRepository.findActiveById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy sản phẩm có id = " + id));
    }

    @Override
    public List<Product> getDeletedProducts() {
        return productRepository.findDeletedProducts();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<Product> searchProducts(
            boolean deleted,
            Long categoryId,
            Long brandId,
            Gender gender,
            Double minPrice,
            Double maxPrice,
            String keyword,
            Pageable pageable) {
        return productRepository.findAll(
                ProductSpecifications.search(deleted, categoryId, brandId, gender, minPrice, maxPrice, keyword),
                pageable);
    }

    private void validateProduct(Product product) {
        if (product == null || product.getName() == null || product.getName().isBlank()) {
            throw new BadRequestException("Tên sản phẩm không được để trống");
        }
        if (product.getPrice() == null || product.getPrice() < 0) {
            throw new BadRequestException("Giá sản phẩm không hợp lệ");
        }
        if (product.getQuantity() == null || product.getQuantity() < 0) {
            throw new BadRequestException("Số lượng sản phẩm không hợp lệ");
        }
        if (product.getCategory() == null || product.getCategory().getId() == null) {
            throw new BadRequestException("Danh mục sản phẩm không được để trống");
        }
    }

    @Override
    @Transactional
    public Product create(Product product, String initialImageUrl) {
        validateProduct(product);

        Long categoryId = product.getCategory().getId();
        if (!categoryRepository.existsById(categoryId)) {
            throw new ResourceNotFoundException("Không tìm thấy danh mục có id = " + categoryId);
        }
        Long brandId = product.getBrand() == null ? null : product.getBrand().getId();
        if (brandId != null && entityManager.find(Brand.class, brandId) == null) {
            throw new ResourceNotFoundException("Không tìm thấy thương hiệu có id = " + brandId);
        }

        product.setCategory(entityManager.getReference(Category.class, categoryId));
        if (brandId != null) {
            product.setBrand(entityManager.getReference(Brand.class, brandId));
        }
        if (product.getDeleted() == null) {
            product.setDeleted(false);
        }
        if (product.getGender() == null) {
            product.setGender(Gender.UNISEX);
        }

        Product savedProduct = productRepository.save(product);

        if (initialImageUrl != null && !initialImageUrl.isBlank()) {
            ProductImage mainImage = new ProductImage();
            mainImage.setImageUrl(initialImageUrl.trim());
            mainImage.setAltText(savedProduct.getName());
            mainImage.setPrimary(true);
            mainImage.setProduct(savedProduct);
            ProductImage savedImage = productImageRepository.save(mainImage);
            if (savedProduct.getImages() == null) {
                savedProduct.setImages(new ArrayList<>());
            }
            savedProduct.getImages().add(savedImage);
        }

        return savedProduct;
    }

    @Override
    @Transactional
    public Product update(Long id, Product product) {
        validateProduct(product);
        Product existingProduct = getProductById(id);

        Long categoryId = product.getCategory().getId();
        if (!categoryRepository.existsById(categoryId)) {
            throw new ResourceNotFoundException(
                    "Không tìm thấy danh mục có id = " + categoryId);
        }
        Long brandId = product.getBrand() == null ? null : product.getBrand().getId();
        if (brandId != null && entityManager.find(Brand.class, brandId) == null) {
            throw new ResourceNotFoundException("Không tìm thấy thương hiệu có id = " + brandId);
        }
        existingProduct.setName(product.getName());
        existingProduct.setDescription(product.getDescription());
        existingProduct.setPrice(product.getPrice());
        existingProduct.setQuantity(product.getQuantity());
        existingProduct.setGender(product.getGender());
        existingProduct.setTag(product.getTag());
        existingProduct.setCategory(
                entityManager.getReference(Category.class, categoryId));
        if (brandId != null) {
            existingProduct.setBrand(entityManager.getReference(Brand.class, brandId));
        } else {
            existingProduct.setBrand(null);
        }
        if (product.getGender() != null) {
            existingProduct.setGender(product.getGender());
        }
        if (product.getTag() != null) {
            existingProduct.setTag(product.getTag());
        }
        return productRepository.save(existingProduct);
    }

    @Override
    @Transactional
    public Product updateMainImage(Long id, MultipartFile file) {
        Product product = getProductById(id);
        UploadResponse uploadedImage = uploadService.upload(file);

        List<ProductImage> images = new ArrayList<>(product.getImages());
        for (ProductImage image : images) {
            if (Boolean.TRUE.equals(image.getPrimary())) {
                image.setPrimary(false);
            }
        }

        ProductImage mainImage = new ProductImage();
        mainImage.setImageUrl(uploadedImage.url());
        mainImage.setAltText(product.getName());
        mainImage.setPrimary(true);
        mainImage.setProduct(product);
        images.add(productImageRepository.save(mainImage));
        product.setImages(images);
        return product;
    }

    @Override
    @Transactional
    public Product addImages(Long id, List<MultipartFile> files) {
        Product product = getProductById(id);
        if (files == null || files.isEmpty()) {
            throw new BadRequestException("Vui lòng chọn ít nhất một ảnh phụ");
        }

        List<ProductImage> images = new ArrayList<>(product.getImages());
        for (MultipartFile file : files) {
            UploadResponse uploadedImage = uploadService.upload(file);
            ProductImage additionalImage = new ProductImage();
            additionalImage.setImageUrl(uploadedImage.url());
            additionalImage.setAltText(product.getName());
            additionalImage.setPrimary(false);
            additionalImage.setProduct(product);
            images.add(productImageRepository.save(additionalImage));
        }
        product.setImages(images);
        return product;
    }

    @Override
    @Transactional(readOnly = true)
    public List<ProductImage> getAdditionalImages(Long id) {
        Product product = getProductById(id);
        return product.getImages().stream()
                .filter(image -> !Boolean.TRUE.equals(image.getPrimary()))
                .toList();
    }

    @Override
    @Transactional
    public ProductImage updateAdditionalImage(Long productId, Long imageId, MultipartFile file) {
        getProductById(productId);
        ProductImage image = findAdditionalImage(productId, imageId);
        UploadResponse uploadedImage = uploadService.upload(file);
        image.setImageUrl(uploadedImage.url());
        return productImageRepository.save(image);
    }

    @Override
    @Transactional
    public void deleteAdditionalImage(Long productId, Long imageId) {
        Product product = getProductById(productId);
        ProductImage image = findAdditionalImage(productId, imageId);
        product.getImages().remove(image);
        productImageRepository.delete(image);
    }

    private ProductImage findAdditionalImage(Long productId, Long imageId) {
        ProductImage image = productImageRepository.findByIdAndProduct_Id(imageId, productId)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Không tìm thấy ảnh phụ có id = " + imageId + " của sản phẩm"));
        if (Boolean.TRUE.equals(image.getPrimary())) {
            throw new BadRequestException("Không thể sửa hoặc xóa ảnh chính tại mục ảnh phụ");
        }
        return image;
    }

    @Override
    @Transactional
    public void delete(Long id) {
        Product product = getProductById(id);
        product.setDeleted(true);
    }

    @Override
    @Transactional
    public void deletePermanently(Long id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy sản phẩm có id = " + id));
        if (!Boolean.TRUE.equals(product.getDeleted())) {
            throw new BadRequestException("Chỉ có thể xóa vĩnh viễn sản phẩm trong thùng rác");
        }

        // 1. Gỡ liên kết trong OrderItem (giữ nguyên thông tin hóa đơn lịch sử cho khách hàng)
        entityManager.createQuery("UPDATE OrderItem oi SET oi.product = null WHERE oi.product.id = :id")
                .setParameter("id", id)
                .executeUpdate();

        // 2. Xóa khỏi giỏ hàng
        entityManager.createQuery("DELETE FROM CartItem ci WHERE ci.product.id = :id")
                .setParameter("id", id)
                .executeUpdate();

        // 3. Xóa khỏi danh sách yêu thích
        entityManager.createQuery("DELETE FROM Wishlist w WHERE w.product.id = :id")
                .setParameter("id", id)
                .executeUpdate();

        // 4. Xóa liên kết mã giảm giá áp dụng theo sản phẩm
        entityManager.createQuery("DELETE FROM CouponProduct cp WHERE cp.product.id = :id")
                .setParameter("id", id)
                .executeUpdate();

        // 5. Xóa lịch sử thay đổi giá và bảng giá liên quan
        entityManager.createQuery("DELETE FROM PriceHistory ph WHERE ph.priceItem.id IN (SELECT pli.id FROM PriceListItem pli WHERE pli.product.id = :id)")
                .setParameter("id", id)
                .executeUpdate();
        entityManager.createQuery("DELETE FROM PriceListItem pli WHERE pli.product.id = :id")
                .setParameter("id", id)
                .executeUpdate();

        // 6. Xóa thuộc tính biến thể và các biến thể sản phẩm (nếu có)
        entityManager.createQuery("DELETE FROM ProductVariantAttribute pva WHERE pva.variant.id IN (SELECT pv.id FROM ProductVariant pv WHERE pv.product.id = :id)")
                .setParameter("id", id)
                .executeUpdate();
        entityManager.createQuery("DELETE FROM ProductVariant pv WHERE pv.product.id = :id")
                .setParameter("id", id)
                .executeUpdate();

        // 7. Xóa nhật ký kho và bản ghi tồn kho
        entityManager.createQuery("DELETE FROM InventoryTransaction it WHERE it.inventory.productId = :id")
                .setParameter("id", id)
                .executeUpdate();
        entityManager.createQuery("DELETE FROM Inventory i WHERE i.productId = :id")
                .setParameter("id", id)
                .executeUpdate();

        // 8. Xóa toàn bộ ảnh của sản phẩm
        entityManager.createQuery("DELETE FROM ProductImage pi WHERE pi.product.id = :id")
                .setParameter("id", id)
                .executeUpdate();

        // 9. Xóa vĩnh viễn sản phẩm khỏi bảng products
        entityManager.createQuery("DELETE FROM Product p WHERE p.id = :id")
                .setParameter("id", id)
                .executeUpdate();

        entityManager.clear();
    }

    @Override
    @Transactional
    public void restoreDeleted(Long id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy sản phẩm có id = " + id));
        if (!Boolean.TRUE.equals(product.getDeleted())) {
            throw new BadRequestException("Sản phẩm không nằm trong thùng rác");
        }
        product.setDeleted(false);
    }

    @Override
    @Transactional
    public void restoreAllDeleted() {
        productRepository.findDeletedProducts().forEach(product -> product.setDeleted(false));
    }
}
