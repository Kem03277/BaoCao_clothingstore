package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.AuditLog;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {
    @Query("SELECT log FROM AuditLog log WHERE (:userId IS NULL OR log.user.id = :userId) "
            + "AND (:action IS NULL OR log.action = :action) ORDER BY log.createdAt DESC")
    List<AuditLog> search(@Param("userId") Long userId, @Param("action") String action);
}