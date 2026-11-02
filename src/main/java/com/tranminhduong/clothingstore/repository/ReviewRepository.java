package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ReviewRepository extends JpaRepository<Review, Long> {

    @Query("""
            SELECT DISTINCT r FROM Review r
            JOIN FETCH r.orderItem oi
            JOIN FETCH oi.order o
            JOIN FETCH o.user
            LEFT JOIN FETCH oi.product
            LEFT JOIN FETCH r.reviewsImage
            WHERE (:status IS NULL OR r.status = :status)
            ORDER BY r.createdAt DESC
            """)
    List<Review> searchReviews(@Param("status") String status);

    @Query("""
            SELECT DISTINCT r FROM Review r
            JOIN FETCH r.orderItem oi
            JOIN FETCH oi.order o
            JOIN FETCH o.user
            LEFT JOIN FETCH oi.product
            LEFT JOIN FETCH r.reviewsImage
            WHERE r.id = :id
            """)
    Optional<Review> findDetailsById(@Param("id") Long id);
}
