package com.tranminhduong.clothingstore.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(
        name = "product_variant_attributes",
        uniqueConstraints = @UniqueConstraint(
                name = "uk_variant_attribute_value",
                columnNames = {"variant_id", "attribute_value_id"}
        )
)
public class ProductVariantAttribute {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "variant_id", nullable = false)
    @JsonIgnore
    private ProductVariant variant;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "attribute_value_id", nullable = false)
    @JsonIgnore
    private ProductAttributeValue attributeValue;

    public ProductVariantAttribute() {
    }

    public ProductVariantAttribute(ProductVariant variant, ProductAttributeValue attributeValue) {
        this.variant = variant;
        this.attributeValue = attributeValue;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public ProductVariant getVariant() {
        return variant;
    }

    public void setVariant(ProductVariant variant) {
        this.variant = variant;
    }

    public ProductAttributeValue getAttributeValue() {
        return attributeValue;
    }

    public void setAttributeValue(ProductAttributeValue attributeValue) {
        this.attributeValue = attributeValue;
    }
}
