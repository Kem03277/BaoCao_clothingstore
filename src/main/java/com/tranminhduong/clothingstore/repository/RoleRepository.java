package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RoleRepository extends JpaRepository<Role, Long> {
    boolean existsByRoleCodeIgnoreCase(String roleCode);

    java.util.Optional<Role> findByRoleCodeIgnoreCase(String roleCode);
}
