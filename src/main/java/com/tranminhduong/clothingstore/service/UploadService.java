package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.dto.UploadResponse;
import org.springframework.web.multipart.MultipartFile;

public interface UploadService {
    UploadResponse upload(MultipartFile file);
}