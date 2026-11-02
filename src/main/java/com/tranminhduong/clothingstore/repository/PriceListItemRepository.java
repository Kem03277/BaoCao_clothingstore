package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.PriceListItem;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PriceListItemRepository extends JpaRepository<PriceListItem, Long> {
    List<PriceListItem> findByPriceList_IdOrderByIdAsc(Long priceListId);
}