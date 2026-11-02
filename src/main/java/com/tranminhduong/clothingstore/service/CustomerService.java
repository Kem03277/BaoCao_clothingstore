package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface CustomerService {
    List<User> getAllUsers();
    Page<User> searchUsers(String keyword, Pageable pageable);
    User getUserById(Long id);
    User updateUserStatus(Long id, String status);
    User updateAvatar(Long id, MultipartFile file);
}
