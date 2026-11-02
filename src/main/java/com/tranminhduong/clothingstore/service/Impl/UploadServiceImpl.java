package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.dto.UploadResponse;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.service.UploadService;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class UploadServiceImpl implements UploadService {
    private static final long MAX_FILE_SIZE = 5L * 1024 * 1024;
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "webp");

    @Override
    public UploadResponse upload(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BadRequestException("Vui lòng chọn ảnh cần tải lên");
        }
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new BadRequestException("Dung lượng ảnh không được vượt quá 5 MB");
        }
        String originalName = file.getOriginalFilename();
        String extension = "";
        if (originalName != null) {
            int dotIndex = originalName.lastIndexOf('.');
            if (dotIndex >= 0) {
                extension = originalName.substring(dotIndex + 1).toLowerCase(Locale.ROOT);
            }
        }
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new BadRequestException("Chỉ chấp nhận ảnh jpg, jpeg, png hoặc webp");
        }

        if (!isValidImage(file, extension)) {
            throw new BadRequestException("Nội dung tệp không đúng định dạng ảnh");
        }

        String fileName = UUID.randomUUID() + "." + extension;
        Path uploadDirectory = Path.of("uploads");
        Path savedFile = uploadDirectory.resolve(fileName);
        try (var inputStream = file.getInputStream()) {
            Files.createDirectories(uploadDirectory);
            Files.copy(inputStream, savedFile);
        } catch (IOException exception) {
            throw new BadRequestException("Không thể lưu tệp ảnh");
        }
        return new UploadResponse(
                fileName,
                savedFile.toString().replace('\\', '/'),
                "/uploads/" + fileName);
    }

    private boolean isValidImage(MultipartFile file, String extension) {
        try (InputStream inputStream = file.getInputStream()) {
            byte[] header = inputStream.readNBytes(12);
            return switch (extension) {
                case "jpg", "jpeg" -> header.length >= 3
                        && (header[0] & 0xFF) == 0xFF
                        && (header[1] & 0xFF) == 0xD8
                        && (header[2] & 0xFF) == 0xFF;
                case "png" -> header.length >= 8
                        && (header[0] & 0xFF) == 0x89
                        && header[1] == 'P'
                        && header[2] == 'N'
                        && header[3] == 'G'
                        && header[4] == 0x0D
                        && header[5] == 0x0A
                        && header[6] == 0x1A
                        && header[7] == 0x0A;
                case "webp" -> header.length >= 12
                        && header[0] == 'R'
                        && header[1] == 'I'
                        && header[2] == 'F'
                        && header[3] == 'F'
                        && header[8] == 'W'
                        && header[9] == 'E'
                        && header[10] == 'B'
                        && header[11] == 'P';
                default -> false;
            };
        } catch (IOException exception) {
            throw new BadRequestException("Không thể đọc tệp ảnh");
        }
    }
}