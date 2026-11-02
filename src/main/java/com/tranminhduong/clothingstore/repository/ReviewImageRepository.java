package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.ReviewImage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewImageRepository extends JpaRepository<ReviewImage, Long> {
    void deleteByReview_Id(Long reviewId);
}
