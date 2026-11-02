package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.PostCategory;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PostCategoryRepository extends JpaRepository<PostCategory, Long> {
    List<PostCategory> findByStatusTrueOrderByCategoryNameAsc();
}