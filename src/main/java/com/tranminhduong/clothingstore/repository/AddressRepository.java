package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Address;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AddressRepository extends JpaRepository<Address, Long> {
    List<Address> findByUser_IdOrderByIdAsc(Long userId);
}
