package com.tranminhduong.clothingstore.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.ArrayList;
import java.util.List;

/** Ánh xạ bảng post_categories trong ERD. */
@Entity
@Table(name = "post_categories")
@Getter
@Setter
@NoArgsConstructor
public class PostCategory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "post_category_id")
    private Long id;

    @Column(name = "category_name", length = 100)
    private String categoryName;

    @Column(name = "slug", length = 150)
    private String slug;

    @Column(name = "status")
    private Boolean status = true;

    @OneToMany(mappedBy = "postCategory")
    @JsonIgnore
    private List<Post> posts = new ArrayList<>();

}
