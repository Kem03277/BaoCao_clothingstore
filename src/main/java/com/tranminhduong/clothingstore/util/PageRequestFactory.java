package com.tranminhduong.clothingstore.util;

import com.tranminhduong.clothingstore.exception.BadRequestException;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

public final class PageRequestFactory {

    private static final int MAX_PAGE_SIZE = 100;

    private PageRequestFactory() {
    }

    public static Pageable create(Integer page, Integer size, Sort sort) {
        if (page == null || page < 0) {
            throw new BadRequestException("Trang không hợp lệ");
        }
        if (size == null || size <= 0 || size > MAX_PAGE_SIZE) {
            throw new BadRequestException("Kích thước trang phải từ 1 đến " + MAX_PAGE_SIZE);
        }
        return PageRequest.of(page, size, sort);
    }
}
