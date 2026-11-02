package com.tranminhduong.clothingstore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.ArrayList;
import java.util.List;

/** Ánh xạ bảng brands trong ERD. */
@Entity
@Table(name = "brands")
@Getter
@Setter
@NoArgsConstructor
public class Brand {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "brand_id")
    private Long id;

    @Column(name = "brand_name", length = 100)
    private String brandName;

    @Column(name = "logo_url", length = 150)
    private String logoUrl;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "status")
    private Boolean status = true;

    @Column(name = "deleted")
    private Boolean deleted = false;

    @OneToMany(mappedBy = "brand")
    @JsonIgnore
    private List<Product> products = new ArrayList<>();

}
