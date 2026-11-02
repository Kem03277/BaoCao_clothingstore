package com.tranminhduong.clothingstore.repository;

import com.tranminhduong.clothingstore.entity.Category;
import java.sql.Statement;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import java.util.List;
import org.springframework.dao.EmptyResultDataAccessException;

@Repository
public class JdbcCategoryRepository implements CategoryRepository {

    private final JdbcTemplate jdbcTemplate;

    private final RowMapper<Category> categoryRowMapper = (rs, rowNum) -> {
        Category category = new Category();
        category.setId(rs.getLong("id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setDeleted(rs.getBoolean("deleted"));
        return category;
    };

    public JdbcCategoryRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<Category> findAll() {
        String sql = "SELECT id, name, description, deleted FROM categories "
                + "WHERE COALESCE(deleted, FALSE) = FALSE ORDER BY id";
        return jdbcTemplate.query(sql, categoryRowMapper);
    }

    @Override
    public List<Category> findDeleted() {
        return jdbcTemplate.query(
                "SELECT id, name, description, deleted FROM categories WHERE deleted = TRUE ORDER BY id",
                categoryRowMapper);
    }

    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM categories WHERE id = ? AND COALESCE(deleted, FALSE) = FALSE";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, id);
        return count != null && count > 0;
    }

    @Override
    public Category findById(Long id) {
        String sql = "SELECT id, name, description, deleted FROM categories "
                + "WHERE id = ? AND COALESCE(deleted, FALSE) = FALSE";
        List<Category> categories = jdbcTemplate.query(sql, categoryRowMapper, id);
        return categories.isEmpty() ? null : categories.get(0);
    }

    @Override
    public Category findDeletedById(Long id) {
        List<Category> categories = jdbcTemplate.query(
                "SELECT id, name, description, deleted FROM categories WHERE id = ? AND deleted = TRUE",
                categoryRowMapper,
                id);
        return categories.isEmpty() ? null : categories.get(0);
    }

    @Override
    public boolean existsByNameIgnoreCase(String name) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM categories WHERE LOWER(name) = LOWER(?)",
                Integer.class,
                name);
        return count != null && count > 0;
    }

    @Override
    public boolean existsByNameIgnoreCaseAndIdNot(String name, Long id) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM categories WHERE LOWER(name) = LOWER(?) AND id <> ?",
                Integer.class,
                name,
                id);
        return count != null && count > 0;
    }

    @Override
    public Category save(Category category) {
        if (category.getId() == null) {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                var statement = connection.prepareStatement(
                        "INSERT INTO categories (name, description) VALUES (?, ?)",
                        Statement.RETURN_GENERATED_KEYS);
                statement.setString(1, category.getName());
                statement.setString(2, category.getDescription());
                return statement;
            }, keyHolder);
            Number generatedId = keyHolder.getKey();
            if (generatedId == null) {
                throw new IllegalStateException("Không lấy được ID danh mục vừa tạo");
            }
            return findById(generatedId.longValue());
        }

        jdbcTemplate.update(
                "UPDATE categories SET name = ?, description = ? WHERE id = ?",
                category.getName(),
                category.getDescription(),
                category.getId());
        return findById(category.getId());
    }

    @Override
    public void deleteById(Long id) {
        jdbcTemplate.update("DELETE FROM categories WHERE id = ?", id);
    }

    @Override
    public void setDeleted(Long id, boolean deleted) {
        jdbcTemplate.update("UPDATE categories SET deleted = ? WHERE id = ?", deleted, id);
    }

    @Override
    public long countProductsById(Long id) {
        Long count = jdbcTemplate.queryForObject(
                "SELECT (SELECT COUNT(*) FROM products WHERE category_id = ?) "
                        + "+ (SELECT COUNT(*) FROM coupon_categories WHERE category_id = ?)",
                Long.class,
                id,
                id);
        return count == null ? 0 : count;
    }
}