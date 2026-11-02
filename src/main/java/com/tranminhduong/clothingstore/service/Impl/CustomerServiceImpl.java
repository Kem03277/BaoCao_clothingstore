package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.dto.UploadResponse;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.repository.CustomerRepository;
import com.tranminhduong.clothingstore.service.CustomerService;
import com.tranminhduong.clothingstore.service.UploadService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
public class CustomerServiceImpl implements CustomerService {

    private final CustomerRepository userRepository;
    private final UploadService uploadService;

    public CustomerServiceImpl(CustomerRepository userRepository, UploadService uploadService) {
        this.userRepository = userRepository;
        this.uploadService = uploadService;
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<User> searchUsers(String keyword, Pageable pageable) {
        if (keyword == null || keyword.isBlank()) {
            return userRepository.findAll(pageable);
        }

        String pattern = "%" + keyword.trim().toLowerCase() + "%";
        Specification<User> matchingKeyword = (root, query, criteriaBuilder) ->
                criteriaBuilder.or(
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("fullName")), pattern),
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("email")), pattern),
                        criteriaBuilder.like(criteriaBuilder.lower(root.get("phone")), pattern));
        return userRepository.findAll(matchingKeyword, pageable);
    }

    @Override
    @Transactional(readOnly = true)
    public User getUserById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy người dùng có id = " + id));
    }

    @Override
    @Transactional
    public User updateUserStatus(Long id, String status) {
        if (status == null || !(status.equalsIgnoreCase("ACTIVE") || status.equalsIgnoreCase("LOCKED"))) {
            throw new BadRequestException("Trạng thái tài khoản chỉ nhận ACTIVE hoặc LOCKED");
        }
        User user = getUserById(id);
        user.setStatus(status.toUpperCase());
        return user;
    }

    @Override
    @Transactional
    public User updateAvatar(Long id, MultipartFile file) {
        User user = getUserById(id);
        UploadResponse uploadedImage = uploadService.upload(file);
        user.setAvatarUrl(uploadedImage.url());
        return user;
    }

}
