package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Shipment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface ShipmentRepository extends JpaRepository<Shipment, Long> {
    @Query("SELECT DISTINCT s.carrier FROM Shipment s WHERE s.carrier IS NOT NULL AND s.carrier <> '' ORDER BY s.carrier")
    List<String> findDistinctCarriers();

    @Query("SELECT DISTINCT s.status FROM Shipment s WHERE s.status IS NOT NULL AND s.status <> '' ORDER BY s.status")
    List<String> findDistinctStatuses();

    Optional<Shipment> findByOrder_Id(Long orderId);
}
