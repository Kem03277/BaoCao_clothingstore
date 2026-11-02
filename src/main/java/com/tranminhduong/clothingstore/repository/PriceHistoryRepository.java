package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.PriceHistory;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PriceHistoryRepository extends JpaRepository<PriceHistory, Long> {
    List<PriceHistory> findByPriceItem_Product_IdOrderByChangedAtDesc(Long productId);
}