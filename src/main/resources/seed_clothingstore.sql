-- ==============================================================================
-- FILE SEEDER DATABASE CLOTHING STORE (MySQL/MariaDB)
-- Generated with precision according to project entities, constraints, and requirements.
--
-- Đặc điểm an toàn:
-- 1. Idempotent: Có thể chạy nhiều lần mà không tạo trùng lặp dữ liệu.
-- 2. Không DROP TABLE, không DROP DATABASE, không xóa dữ liệu người dùng thật.
-- 3. Đảm bảo toàn vẹn khóa ngoại (Foreign Key integrity).
-- 4. Bốn tài khoản demo: admin@gmail.com, duong@gmail.com, thinh@gmail.com, staff@gmail.com
-- 5. Đúng 100 sản phẩm thời trang (38 MALE, 39 FEMALE, 23 UNISEX) với Size/Color Variants.
-- ==============================================================================

USE clothingstore;

-- ------------------------------------------------------------------------------
-- 1. ROLES (Đảm bảo 3 role tồn tại: ADMIN, STAFF, USER)
-- ------------------------------------------------------------------------------
INSERT INTO roles (role_code, role_name, description)
SELECT 'ADMIN', 'Quản trị viên', 'Toàn quyền quản trị hệ thống'
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE UPPER(role_code) = 'ADMIN');

INSERT INTO roles (role_code, role_name, description)
SELECT 'STAFF', 'Nhân viên', 'Quản lý sản phẩm và đơn hàng'
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE UPPER(role_code) = 'STAFF');

INSERT INTO roles (role_code, role_name, description)
SELECT 'USER', 'Khách hàng', 'Khách hàng mua sắm'
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE UPPER(role_code) = 'USER');

-- ------------------------------------------------------------------------------
-- 2. USERS: Bốn tài khoản demo cố định (mật khẩu 123456 -> BCrypt hash)
-- ------------------------------------------------------------------------------
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Quản Trị Viên Demo', 'admin@gmail.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901234567', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'ADMIN'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('admin@gmail.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Trần Minh Dương', 'duong@gmail.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0902345678', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('duong@gmail.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Nguyễn Văn Thịnh', 'thinh@gmail.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0903456789', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('thinh@gmail.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Nhân Viên Demo', 'staff@gmail.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0904567890', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'STAFF'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('staff@gmail.com'));

-- ------------------------------------------------------------------------------
-- 3. USERS: 25 Tài khoản khách hàng mẫu (Role USER)
-- ------------------------------------------------------------------------------
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Nguyễn Văn An', 'nguyenvanan@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000001', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('nguyenvanan@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Trần Thị Bích', 'tranthibich@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000002', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('tranthibich@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Lê Hoàng Nam', 'lehoangnam@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000003', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('lehoangnam@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Phạm Minh Đức', 'phamminhduc@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000004', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('phamminhduc@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Vũ Thị Hương', 'vuthihuong@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000005', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('vuthihuong@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Hoàng Quang Huy', 'hoangquanghuy@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000006', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('hoangquanghuy@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Đặng Thùy Linh', 'dangthuylinh@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000007', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('dangthuylinh@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Bùi Tuấn Kiệt', 'buituankiet@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000008', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('buituankiet@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Đỗ Ngọc Mai', 'dongoctmai@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000009', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('dongoctmai@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Ngô Bảo Trâm', 'ngobaotram@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000010', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('ngobaotram@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Dương Văn Hậu', 'duongvanhau@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000011', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('duongvanhau@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Lý Khánh Vy', 'lykhanhvy@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000012', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('lykhanhvy@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Trịnh Quốc Bảo', 'trinhquocbao@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000013', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('trinhquocbao@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Phan Thu Thảo', 'phanthuthao@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000014', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('phanthuthao@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Mai Đức Anh', 'maiducanh@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000015', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('maiducanh@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Võ Hoàng Yến', 'vohoangyen@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000016', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('vohoangyen@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Đinh Trọng Nghĩa', 'dinhtrongnghia@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000017', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('dinhtrongnghia@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Lâm Thanh Hà', 'lamthanhha@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000018', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('lamthanhha@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Châu Hải Đăng', 'chauhoidang@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000019', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('chauhoidang@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Hồ Quỳnh Như', 'hoquynhnhu@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000020', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('hoquynhnhu@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Đoàn Công Thành', 'doancongthanh@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000021', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('doancongthanh@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Tống Mỹ Duyên', 'tongmyduyen@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000022', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('tongmyduyen@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Lương Gia Bảo', 'luonggiabao@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000023', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('luonggiabao@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Cao Minh Tuấn', 'caominhtuan@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000024', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('caominhtuan@example.com'));
INSERT INTO users (full_name, email, password_hash, phone, status, token_version, role_id, created_at)
SELECT 'Tạ Bích Phương', 'tabichphuong@example.com', '$2a$10$UgHbamSV70G4BVHRWjq.i.IsyzBXLbE1iXZhCM2WCWCxnMXkZOE2i', '0901000025', 'ACTIVE', 0, r.role_id, NOW()
FROM roles r WHERE UPPER(r.role_code) = 'USER'
AND NOT EXISTS (SELECT 1 FROM users WHERE UPPER(email) = UPPER('tabichphuong@example.com'));

-- ------------------------------------------------------------------------------
-- 4. CATEGORIES: 10 Danh mục loại sản phẩm (KHÔNG có danh mục giới tính)
-- ------------------------------------------------------------------------------
INSERT INTO categories (name, description)
SELECT 'Áo thun', 'Áo thun cotton thoáng mát, form dáng đa dạng từ basic đến oversize'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Áo thun');
INSERT INTO categories (name, description)
SELECT 'Áo sơ mi', 'Áo sơ mi thanh lịch, chất liệu cao cấp cho đi làm và dạo phố'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Áo sơ mi');
INSERT INTO categories (name, description)
SELECT 'Áo polo', 'Áo polo thời trang, cổ bẻ chỉn chu, co giãn tốt và tôn dáng'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Áo polo');
INSERT INTO categories (name, description)
SELECT 'Áo khoác', 'Áo khoác gió, bomber, cardigan, dù 2 lớp chống gió cản bụi'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Áo khoác');
INSERT INTO categories (name, description)
SELECT 'Áo hoodie & Sweatshirt', 'Áo nỉ chui đầu và có khóa ấm áp, phong cách trẻ trung năng động'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Áo hoodie & Sweatshirt');
INSERT INTO categories (name, description)
SELECT 'Quần jeans', 'Quần jeans denim chất lượng cao, bền bỉ, đường may sắc sảo'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Quần jeans');
INSERT INTO categories (name, description)
SELECT 'Quần kaki', 'Quần kaki dáng slim và suông đứng, trẻ trung cho môi trường công sở'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Quần kaki');
INSERT INTO categories (name, description)
SELECT 'Quần short', 'Quần short thoáng mát, thoải mái cho các hoạt động thể thao dạo phố'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Quần short');
INSERT INTO categories (name, description)
SELECT 'Quần tây', 'Quần âu may đo chuẩn phom dáng, phong cách lịch lãm hiện đại'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Quần tây');
INSERT INTO categories (name, description)
SELECT 'Váy & Đầm', 'Chân váy và đầm thiết kế nữ tính, thanh lịch và thời thượng'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Váy & Đầm');

-- ------------------------------------------------------------------------------
-- 5. BRANDS: 10 Thương hiệu thời trang
-- ------------------------------------------------------------------------------
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'Coolmate', 'https://www.google.com/s2/favicons?domain_url=https://coolmate.me&sz=128', 'Thương hiệu đồ nam tối giản, tiện dụng hàng đầu Việt Nam', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'Coolmate');
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'Routine', 'https://www.google.com/s2/favicons?domain_url=https://routine.vn&sz=128', 'Thời trang thường nhật phong cách hiện đại cho giới trẻ', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'Routine');
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'Canifa', 'https://www.google.com/s2/favicons?domain_url=https://canifa.com&sz=128', 'Thời trang thường ngày năng động, đa dạng cho mọi lứa tuổi', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'Canifa');
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'An Phước', 'https://www.google.com/s2/favicons?domain_url=https://anphuoc.com.vn&sz=128', 'Thời trang công sở nam cao cấp, chuẩn mực phong độ', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'An Phước');
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'Owen', 'https://www.google.com/s2/favicons?domain_url=https://owen.vn&sz=128', 'Thời trang nam lịch lãm, hiện đại và phong cách', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'Owen');
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'Gumac', 'https://www.google.com/s2/favicons?domain_url=https://gumac.vn&sz=128', 'Thời trang nữ trẻ trung, thiết kế công sở và dạo phố thời thượng', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'Gumac');
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'Elise', 'https://www.google.com/s2/favicons?domain_url=https://elise.vn&sz=128', 'Thương hiệu thời trang nữ cao cấp, sang trọng quý phái', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'Elise');
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'Levents', 'https://www.google.com/s2/favicons?domain_url=https://levents.asia&sz=128', 'Thương hiệu Streetwear hàng đầu được giới trẻ yêu thích', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'Levents');
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'DirtyCoins', 'https://www.google.com/s2/favicons?domain_url=https://dirtycoins.vn&sz=128', 'Thời trang đường phố cá tính, phá cách và nổi bật', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'DirtyCoins');
INSERT INTO brands (brand_name, logo_url, description, status)
SELECT 'Biluxury', 'https://www.google.com/s2/favicons?domain_url=https://biluxury.vn&sz=128', 'Thời trang nam thiết kế sáng tạo, sang trọng tinh tế', 1
WHERE NOT EXISTS (SELECT 1 FROM brands WHERE brand_name = 'Biluxury');

-- Refresh logo URLs for existing seeded brands without changing other brand data.
UPDATE brands
SET logo_url = CASE brand_name
    WHEN 'Coolmate' THEN 'https://www.google.com/s2/favicons?domain_url=https://coolmate.me&sz=128'
    WHEN 'Routine' THEN 'https://www.google.com/s2/favicons?domain_url=https://routine.vn&sz=128'
    WHEN 'Canifa' THEN 'https://www.google.com/s2/favicons?domain_url=https://canifa.com&sz=128'
    WHEN 'An Phước' THEN 'https://www.google.com/s2/favicons?domain_url=https://anphuoc.com.vn&sz=128'
    WHEN 'Owen' THEN 'https://www.google.com/s2/favicons?domain_url=https://owen.vn&sz=128'
    WHEN 'Gumac' THEN 'https://www.google.com/s2/favicons?domain_url=https://gumac.vn&sz=128'
    WHEN 'Elise' THEN 'https://www.google.com/s2/favicons?domain_url=https://elise.vn&sz=128'
    WHEN 'Levents' THEN 'https://www.google.com/s2/favicons?domain_url=https://levents.asia&sz=128'
    WHEN 'DirtyCoins' THEN 'https://www.google.com/s2/favicons?domain_url=https://dirtycoins.vn&sz=128'
    WHEN 'Biluxury' THEN 'https://www.google.com/s2/favicons?domain_url=https://biluxury.vn&sz=128'
    ELSE logo_url
END
WHERE brand_name IN (
    'Coolmate', 'Routine', 'Canifa', 'An Phước', 'Owen',
    'Gumac', 'Elise', 'Levents', 'DirtyCoins', 'Biluxury'
);

-- ------------------------------------------------------------------------------
-- 6. PRODUCT ATTRIBUTES & VALUES (Size, Color)
-- ------------------------------------------------------------------------------
INSERT INTO product_attributes (name, display_order)
SELECT 'Size', 1
WHERE NOT EXISTS (SELECT 1 FROM product_attributes WHERE name = 'Size');
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'S', 1
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = 'S'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'M', 2
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = 'M'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'L', 3
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = 'L'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'XL', 4
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = 'XL'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'XXL', 5
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = 'XXL'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, '28', 6
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = '28'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, '29', 7
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = '29'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, '30', 8
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = '30'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, '31', 9
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = '31'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, '32', 10
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = '32'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, '33', 11
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = '33'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, '34', 12
FROM product_attributes pa WHERE pa.name = 'Size'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Size' AND pav.value = '34'
);
INSERT INTO product_attributes (name, display_order)
SELECT 'Color', 2
WHERE NOT EXISTS (SELECT 1 FROM product_attributes WHERE name = 'Color');
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'Đen', 1
FROM product_attributes pa WHERE pa.name = 'Color'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Color' AND pav.value = 'Đen'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'Trắng', 2
FROM product_attributes pa WHERE pa.name = 'Color'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Color' AND pav.value = 'Trắng'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'Xám', 3
FROM product_attributes pa WHERE pa.name = 'Color'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Color' AND pav.value = 'Xám'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'Be', 4
FROM product_attributes pa WHERE pa.name = 'Color'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Color' AND pav.value = 'Be'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'Xanh Navy', 5
FROM product_attributes pa WHERE pa.name = 'Color'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Color' AND pav.value = 'Xanh Navy'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'Nâu', 6
FROM product_attributes pa WHERE pa.name = 'Color'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Color' AND pav.value = 'Nâu'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'Xanh Rêu', 7
FROM product_attributes pa WHERE pa.name = 'Color'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Color' AND pav.value = 'Xanh Rêu'
);
INSERT INTO product_attribute_values (attribute_id, value, display_order)
SELECT pa.id, 'Hồng Pastel', 8
FROM product_attributes pa WHERE pa.name = 'Color'
AND NOT EXISTS (
    SELECT 1 FROM product_attribute_values pav 
    JOIN product_attributes pa2 ON pav.attribute_id = pa2.id 
    WHERE pa2.name = 'Color' AND pav.value = 'Hồng Pastel'
);

-- ------------------------------------------------------------------------------
-- 7. CHÍNH XÁC 100 SẢN PHẨM THỜI TRANG (Products, Images, Inventories, Transactions)
-- ------------------------------------------------------------------------------

-- Product #1: Áo Thun Trơn Basic Cotton Compact (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun Trơn Basic Cotton Compact', 'Áo thun nam chất liệu Cotton Compact 100% mềm mịn, thoáng mát, chống nhăn xù tối ưu cho ngày dài năng động.', 189000, 100, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun Trơn Basic Cotton Compact');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&auto=format&fit=crop&q=80', 'Áo Thun Trơn Basic Cotton Compact - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun Trơn Basic Cotton Compact'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=800&auto=format&fit=crop&q=80', 'Áo Thun Trơn Basic Cotton Compact - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun Trơn Basic Cotton Compact'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 100, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun Trơn Basic Cotton Compact'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 100, 100, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun Trơn Basic Cotton Compact' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD001-S-BLK', '893001001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Trơn Basic Cotton Compact'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD001-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD001-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD001-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD001-M-BLK', '893001002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Trơn Basic Cotton Compact'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD001-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD001-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD001-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD001-M-WHT', '893001003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Trơn Basic Cotton Compact'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD001-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD001-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD001-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD001-XL-NAV', '893001004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Trơn Basic Cotton Compact'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD001-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD001-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD001-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #2: Áo Thun Graphic Phông Rộng Street Art (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun Graphic Phông Rộng Street Art', 'Thiết kế graphic cá tính đậm chất streetwear, form dáng oversize phóng khoáng phù hợp cho cả nam và nữ.', 320000, 107, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun Graphic Phông Rộng Street Art');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800&auto=format&fit=crop&q=80', 'Áo Thun Graphic Phông Rộng Street Art - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun Graphic Phông Rộng Street Art'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&auto=format&fit=crop&q=80', 'Áo Thun Graphic Phông Rộng Street Art - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun Graphic Phông Rộng Street Art'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 107, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun Graphic Phông Rộng Street Art'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 107, 107, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun Graphic Phông Rộng Street Art' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD002-S-BLK', '893002001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Graphic Phông Rộng Street Art'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD002-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD002-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD002-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD002-M-BLK', '893002002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Graphic Phông Rộng Street Art'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD002-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD002-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD002-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD002-M-WHT', '893002003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Graphic Phông Rộng Street Art'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD002-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD002-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD002-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD002-XL-NAV', '893002004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Graphic Phông Rộng Street Art'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD002-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD002-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD002-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #3: Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn', 'Thiết kế cổ vuông tôn dáng xương quai xanh quyến rũ, chất dệt kim nhẹ nhàng co giãn 4 chiều.', 219000, 114, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 114, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 114, 114, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD003-S-BLK', '893003001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD003-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD003-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD003-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD003-M-BLK', '893003002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD003-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD003-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD003-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD003-M-WHT', '893003003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD003-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD003-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD003-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD003-XL-NAV', '893003004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD003-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD003-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD003-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #4: Áo Thun Cổ Tròn QuickDry Thể Thao (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun Cổ Tròn QuickDry Thể Thao', 'Công nghệ dệt QuickDry thấm hút mồ hôi siêu tốc, giữ cơ thể luôn khô thoáng khi vận động.', 199000, 121, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun Cổ Tròn QuickDry Thể Thao');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800&auto=format&fit=crop&q=80', 'Áo Thun Cổ Tròn QuickDry Thể Thao - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun Cổ Tròn QuickDry Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format&fit=crop&q=80', 'Áo Thun Cổ Tròn QuickDry Thể Thao - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun Cổ Tròn QuickDry Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 121, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun Cổ Tròn QuickDry Thể Thao'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 121, 121, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun Cổ Tròn QuickDry Thể Thao' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD004-S-BLK', '893004001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Cổ Tròn QuickDry Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD004-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD004-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD004-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD004-M-BLK', '893004002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Cổ Tròn QuickDry Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD004-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD004-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD004-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD004-M-WHT', '893004003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Cổ Tròn QuickDry Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD004-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD004-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD004-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD004-XL-NAV', '893004004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Cổ Tròn QuickDry Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD004-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD004-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD004-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #5: Áo Thun Nữ Croptop Baby Tee In Hình (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun Nữ Croptop Baby Tee In Hình', 'Kiểu dáng baby tee tôn eo thon gọn, họa tiết in sắc nét trẻ trung theo xu hướng Gen Z.', 179000, 128, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun Nữ Croptop Baby Tee In Hình');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nữ Croptop Baby Tee In Hình - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun Nữ Croptop Baby Tee In Hình'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nữ Croptop Baby Tee In Hình - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun Nữ Croptop Baby Tee In Hình'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 128, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Croptop Baby Tee In Hình'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 128, 128, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun Nữ Croptop Baby Tee In Hình' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD005-S-BLK', '893005001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Croptop Baby Tee In Hình'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD005-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD005-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD005-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD005-M-BLK', '893005002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Croptop Baby Tee In Hình'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD005-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD005-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD005-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD005-M-WHT', '893005003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Croptop Baby Tee In Hình'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD005-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD005-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD005-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD005-XL-NAV', '893005004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Croptop Baby Tee In Hình'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD005-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD005-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD005-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #6: Áo Thun In Chữ Typography Thêu Tinh Tế (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun In Chữ Typography Thêu Tinh Tế', 'Chi tiết thêu chữ tỉ mỉ ở ngực áo, gam màu trung tính nhã nhặn dễ phối đồ.', 259000, 135, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'Routine'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun In Chữ Typography Thêu Tinh Tế');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&auto=format&fit=crop&q=80', 'Áo Thun In Chữ Typography Thêu Tinh Tế - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun In Chữ Typography Thêu Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1527719327859-c6ce80353573?w=800&auto=format&fit=crop&q=80', 'Áo Thun In Chữ Typography Thêu Tinh Tế - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun In Chữ Typography Thêu Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 135, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun In Chữ Typography Thêu Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 135, 135, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun In Chữ Typography Thêu Tinh Tế' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD006-S-BLK', '893006001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun In Chữ Typography Thêu Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD006-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD006-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD006-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD006-M-BLK', '893006002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun In Chữ Typography Thêu Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD006-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD006-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD006-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD006-M-WHT', '893006003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun In Chữ Typography Thêu Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD006-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD006-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD006-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD006-XL-NAV', '893006004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun In Chữ Typography Thêu Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD006-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD006-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD006-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #7: Áo Thun Nam Raglan Phối Màu Retro (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun Nam Raglan Phối Màu Retro', 'Thiết kế tay raglan phong cách vintage cổ điển thập niên 90, chất cotton mềm 240gsm.', 229000, 142, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'Canifa'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun Nam Raglan Phối Màu Retro');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nam Raglan Phối Màu Retro - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun Nam Raglan Phối Màu Retro'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nam Raglan Phối Màu Retro - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun Nam Raglan Phối Màu Retro'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 142, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Raglan Phối Màu Retro'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 142, 142, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun Nam Raglan Phối Màu Retro' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD007-S-BLK', '893007001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Raglan Phối Màu Retro'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD007-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD007-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD007-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD007-M-BLK', '893007002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Raglan Phối Màu Retro'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD007-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD007-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD007-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD007-M-WHT', '893007003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Raglan Phối Màu Retro'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD007-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD007-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD007-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD007-XL-NAV', '893007004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Raglan Phối Màu Retro'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD007-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD007-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD007-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #8: Áo Thun Nữ Form Rộng Thêu Hoa Nhí (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí', 'Họa tiết hoa nhí thêu tay xinh xắn trên nền vải cotton pastel dịu dàng nữ tính.', 249000, 149, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1554412933-514a83d2f3c8?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 149, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 149, 149, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD008-S-BLK', '893008001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD008-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD008-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD008-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD008-M-BLK', '893008002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD008-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD008-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD008-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD008-M-WHT', '893008003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD008-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD008-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD008-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD008-XL-NAV', '893008004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nữ Form Rộng Thêu Hoa Nhí'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD008-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD008-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD008-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #9: Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp', 'Cổ tim viền bo gân dệt tinh xảo, chất vải giữ phom dáng bền đẹp qua nhiều lần giặt.', 289000, 156, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'DirtyCoins'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800&auto=format&fit=crop&q=80', 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=800&auto=format&fit=crop&q=80', 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 156, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 156, 156, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD009-S-BLK', '893009001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD009-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD009-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD009-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD009-M-BLK', '893009002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD009-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD009-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD009-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD009-M-WHT', '893009003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD009-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD009-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD009-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD009-XL-NAV', '893009004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD009-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD009-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD009-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #10: Áo Thun Nam Sát Nách Tanktop Tập Gym (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Thun Nam Sát Nách Tanktop Tập Gym', 'Thiết kế khoét nách chuẩn form tập luyện, thoát nhiệt cực tốt hỗ trợ tối đa khi tập gym.', 159000, 163, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo thun' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Thun Nam Sát Nách Tanktop Tập Gym');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nam Sát Nách Tanktop Tập Gym - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Thun Nam Sát Nách Tanktop Tập Gym'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800&auto=format&fit=crop&q=80', 'Áo Thun Nam Sát Nách Tanktop Tập Gym - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Thun Nam Sát Nách Tanktop Tập Gym'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 163, 15, NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Sát Nách Tanktop Tập Gym'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 163, 163, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Thun Nam Sát Nách Tanktop Tập Gym' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD010-S-BLK', '893010001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Sát Nách Tanktop Tập Gym'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD010-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD010-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD010-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD010-M-BLK', '893010002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Sát Nách Tanktop Tập Gym'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD010-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD010-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD010-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD010-M-WHT', '893010003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Sát Nách Tanktop Tập Gym'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD010-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD010-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD010-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD010-XL-NAV', '893010004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Thun Nam Sát Nách Tanktop Tập Gym'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD010-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD010-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD010-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #11: Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn', 'Chất liệu sợi tre Bamboo kháng khuẩn tự nhiên, bề mặt óng mượt và hạn chế nhăn tối đa.', 450000, 170, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'Owen'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 170, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 170, 170, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD011-S-BLK', '893011001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD011-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD011-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD011-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD011-M-BLK', '893011002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD011-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD011-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD011-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD011-M-WHT', '893011003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD011-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD011-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD011-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD011-XL-NAV', '893011004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD011-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD011-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD011-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #12: Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch', 'Chất lụa ngọc trai mềm mại rủ nhẹ, chi tiết nơ thắt điệu đà chuẩn phong cách quý cô công sở.', 420000, 177, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1564257631407-4deb1299042b?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 177, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 177, 177, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD012-S-BLK', '893012001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD012-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD012-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD012-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD012-M-BLK', '893012002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD012-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD012-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD012-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD012-M-WHT', '893012003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD012-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD012-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD012-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD012-XL-NAV', '893012004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD012-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD012-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD012-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #13: Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular', 'Vải Oxford dệt tổ ong dày dặn đứng form, phù hợp cho cả đi làm lẫn dạo phố cuối tuần.', 380000, 184, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'Routine'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1620012253295-c15c429fcc71?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 184, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 184, 184, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD013-S-BLK', '893013001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD013-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD013-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD013-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD013-M-BLK', '893013002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD013-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD013-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD013-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD013-M-WHT', '893013003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD013-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD013-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD013-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD013-XL-NAV', '893013004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD013-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD013-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD013-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #14: Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian', 'Họa tiết nhiệt đới rực rỡ phóng khoáng, chất vải viscose mát lạnh lý tưởng cho kỳ nghỉ hè.', 299000, 191, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'Routine'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 191, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 191, 191, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD014-S-BLK', '893014001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD014-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD014-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD014-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD014-M-BLK', '893014002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD014-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD014-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD014-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD014-M-WHT', '893014003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD014-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD014-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD014-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD014-XL-NAV', '893014004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD014-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD014-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD014-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #15: Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro', 'Tay bồng nhẹ che khuyết điểm bắp tay, cúc bọc cùng màu tinh xảo đậm nét cổ điển.', 350000, 198, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1589902860314-e910697dea18?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1551803091-e20673f15770?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 198, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 198, 198, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD015-S-BLK', '893015001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD015-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD015-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD015-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD015-M-BLK', '893015002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD015-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD015-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD015-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD015-M-WHT', '893015003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD015-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD015-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD015-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD015-XL-NAV', '893015004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD015-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD015-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD015-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #16: Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo', 'Cổ trụ truyền thống kết hợp khuy gỗ mộc mạc, mang phong thái nho nhã thư thái.', 390000, 105, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'Biluxury'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1620012253295-c15c429fcc71?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1598032895397-b9472444bf93?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 105, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 105, 105, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD016-S-BLK', '893016001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD016-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD016-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD016-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD016-M-BLK', '893016002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD016-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD016-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD016-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD016-M-WHT', '893016003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD016-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD016-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD016-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD016-XL-NAV', '893016004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD016-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD016-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD016-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #17: Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực', 'Đường xếp ly thủ công trước ngực tạo điểm nhấn sang trọng, form suông dễ phối với chân váy.', 360000, 112, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1551803091-e20673f15770?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1589902860314-e910697dea18?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 112, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 112, 112, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD017-S-BLK', '893017001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD017-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD017-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD017-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD017-M-BLK', '893017002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD017-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD017-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD017-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD017-M-WHT', '893017003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD017-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD017-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD017-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD017-XL-NAV', '893017004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD017-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD017-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD017-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #18: Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer', 'Vải dạ nỉ flannel cào lông ấm áp, họa tiết kẻ caro kinh điển dễ mặc khoác ngoài.', 410000, 119, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'Canifa'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 119, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 119, 119, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD018-S-BLK', '893018001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD018-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD018-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD018-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD018-M-BLK', '893018002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD018-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD018-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD018-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD018-M-WHT', '893018003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD018-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD018-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD018-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD018-XL-NAV', '893018004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD018-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD018-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD018-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #19: Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng', 'Voan tơ 2 lớp bồng bềnh e ấp, cổ viền bèo mềm mại mang lại vẻ ngọt ngào.', 330000, 126, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1564257631407-4deb1299042b?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 126, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 126, 126, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD019-S-BLK', '893019001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD019-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD019-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD019-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD019-M-BLK', '893019002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD019-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD019-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD019-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD019-M-WHT', '893019003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD019-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD019-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD019-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD019-XL-NAV', '893019004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD019-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD019-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD019-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #20: Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng', 'Họa tiết sọc dọc tinh tế tạo cảm giác thon gọn, đường kim mũi chỉ đạt tiêu chuẩn xuất khẩu cao cấp.', 520000, 133, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo sơ mi' AND b.brand_name = 'An Phước'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1598032895397-b9472444bf93?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?w=800&auto=format&fit=crop&q=80', 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 133, 15, NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 133, 133, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD020-S-BLK', '893020001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD020-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD020-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD020-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD020-M-BLK', '893020002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD020-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD020-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD020-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD020-M-WHT', '893020003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD020-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD020-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD020-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD020-XL-NAV', '893020004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD020-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD020-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD020-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #21: Áo Polo Nam Cafe Khử Mùi Thoáng Khí (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí', 'Vải dệt từ sợi bã cafe có khả năng khử mùi tự nhiên, chống tia UV bảo vệ da.', 299000, 140, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1625910513413-7e44a4ebdafc?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 140, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 140, 140, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD021-S-BLK', '893021001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD021-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD021-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD021-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD021-M-BLK', '893021002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD021-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD021-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD021-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD021-M-WHT', '893021003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD021-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD021-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD021-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD021-XL-NAV', '893021004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD021-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD021-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD021-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #22: Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao', 'Bo cổ dệt sọc thể thao khỏe khoắn, form regular fit vừa vặn tôn nét năng động.', 350000, 147, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=800&auto=format&fit=crop&q=80', 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1625910513413-7e44a4ebdafc?w=800&auto=format&fit=crop&q=80', 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 147, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 147, 147, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD022-S-BLK', '893022001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD022-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD022-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD022-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD022-M-BLK', '893022002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD022-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD022-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD022-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD022-M-WHT', '893022003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD022-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD022-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD022-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD022-XL-NAV', '893022004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD022-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD022-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD022-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #23: Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai', 'Thiết kế dáng ôm nhẹ tôn vòng eo, cúc xà cừ óng ánh tạo nét cuốn hút nhã nhặn.', 279000, 154, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 154, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 154, 154, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD023-S-BLK', '893023001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD023-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD023-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD023-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD023-M-BLK', '893023002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD023-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD023-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD023-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD023-M-WHT', '893023003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD023-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD023-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD023-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD023-XL-NAV', '893023004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD023-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD023-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD023-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #24: Áo Polo Nam Vải Pique Cotton Mắt Chim (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Nam Vải Pique Cotton Mắt Chim', 'Dệt cấu trúc mắt chim dày dặn, đứng form cổ áo không bị quăn mép sau nhiều lần giặt.', 369000, 161, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'Owen'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Nam Vải Pique Cotton Mắt Chim');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1617137984095-74e4e5e3613f?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Vải Pique Cotton Mắt Chim - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Nam Vải Pique Cotton Mắt Chim'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Vải Pique Cotton Mắt Chim - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Nam Vải Pique Cotton Mắt Chim'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 161, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Vải Pique Cotton Mắt Chim'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 161, 161, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Nam Vải Pique Cotton Mắt Chim' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD024-S-BLK', '893024001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Vải Pique Cotton Mắt Chim'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD024-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD024-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD024-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD024-M-BLK', '893024002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Vải Pique Cotton Mắt Chim'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD024-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD024-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD024-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD024-M-WHT', '893024003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Vải Pique Cotton Mắt Chim'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD024-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD024-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD024-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD024-XL-NAV', '893024004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Vải Pique Cotton Mắt Chim'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD024-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD024-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD024-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #25: Áo Polo Nam Trơn Không Đường May Seamless (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Nam Trơn Không Đường May Seamless', 'Công nghệ ép nhiệt không đường may viền nách êm ái, mang lại trải nghiệm mặc nhẹ như không.', 340000, 168, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Nam Trơn Không Đường May Seamless');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Trơn Không Đường May Seamless - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Nam Trơn Không Đường May Seamless'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1617137984095-74e4e5e3613f?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Trơn Không Đường May Seamless - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Nam Trơn Không Đường May Seamless'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 168, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Trơn Không Đường May Seamless'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 168, 168, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Nam Trơn Không Đường May Seamless' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD025-S-BLK', '893025001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Trơn Không Đường May Seamless'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD025-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD025-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD025-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD025-M-BLK', '893025002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Trơn Không Đường May Seamless'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD025-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD025-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD025-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD025-M-WHT', '893025003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Trơn Không Đường May Seamless'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD025-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD025-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD025-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD025-XL-NAV', '893025004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Trơn Không Đường May Seamless'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD025-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD025-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD025-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #26: Áo Polo Nữ Croptop Cổ Bẻ Năng Động (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động', 'Biến tấu croptop trẻ trung kết hợp cổ polo cổ điển, hoàn hảo khi phối cùng quần cạp cao.', 249000, 175, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 175, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 175, 175, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD026-S-BLK', '893026001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD026-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD026-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD026-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD026-M-BLK', '893026002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD026-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD026-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD026-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD026-M-WHT', '893026003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD026-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD026-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD026-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD026-XL-NAV', '893026004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nữ Croptop Cổ Bẻ Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD026-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD026-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD026-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #27: Áo Polo Nam Phối Viền Cổ Dáng Slimfit (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit', 'Phom slimfit khoe trọn cơ bắp nam tính, điểm xuyết viền tay áo chỉn chu lịch lãm.', 399000, 182, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'Biluxury'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 182, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 182, 182, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD027-S-BLK', '893027001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD027-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD027-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD027-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD027-M-BLK', '893027002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD027-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD027-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD027-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD027-M-WHT', '893027003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD027-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD027-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD027-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD027-XL-NAV', '893027004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Phối Viền Cổ Dáng Slimfit'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD027-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD027-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD027-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #28: Áo Polo Unisex Trơn Form Rộng Tối Giản (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Unisex Trơn Form Rộng Tối Giản', 'Phong cách tối giản Minimalism chuẩn Hàn Quốc, chất vải cotton cá sấu dày mịn mát tay.', 310000, 189, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'Routine'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Unisex Trơn Form Rộng Tối Giản');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=800&auto=format&fit=crop&q=80', 'Áo Polo Unisex Trơn Form Rộng Tối Giản - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Unisex Trơn Form Rộng Tối Giản'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800&auto=format&fit=crop&q=80', 'Áo Polo Unisex Trơn Form Rộng Tối Giản - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Unisex Trơn Form Rộng Tối Giản'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 189, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Trơn Form Rộng Tối Giản'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 189, 189, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Unisex Trơn Form Rộng Tối Giản' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD028-S-BLK', '893028001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Trơn Form Rộng Tối Giản'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD028-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD028-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD028-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD028-M-BLK', '893028002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Trơn Form Rộng Tối Giản'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD028-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD028-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD028-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD028-M-WHT', '893028003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Trơn Form Rộng Tối Giản'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD028-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD028-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD028-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD028-XL-NAV', '893028004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Trơn Form Rộng Tối Giản'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD028-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD028-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD028-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #29: Áo Polo Nam Thêu Logo Ngực Sang Trọng (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Nam Thêu Logo Ngực Sang Trọng', 'Logo thêu tinh tế bằng chỉ tơ cao cấp, thích hợp cho quý ông xuất hiện nơi tiệc nhẹ và văn phòng.', 580000, 196, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'An Phước'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Nam Thêu Logo Ngực Sang Trọng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Thêu Logo Ngực Sang Trọng - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Nam Thêu Logo Ngực Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1617137984095-74e4e5e3613f?w=800&auto=format&fit=crop&q=80', 'Áo Polo Nam Thêu Logo Ngực Sang Trọng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Nam Thêu Logo Ngực Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 196, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Thêu Logo Ngực Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 196, 196, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Nam Thêu Logo Ngực Sang Trọng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD029-S-BLK', '893029001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Thêu Logo Ngực Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD029-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD029-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD029-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD029-M-BLK', '893029002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Thêu Logo Ngực Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD029-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD029-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD029-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD029-M-WHT', '893029003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Thêu Logo Ngực Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD029-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD029-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD029-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD029-XL-NAV', '893029004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Nam Thêu Logo Ngực Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD029-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD029-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD029-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #30: Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ', 'Sọc ngang navy trắng phong cách marin trẻ trung, chất vải co giãn nhẹ vận động thoải mái.', 289000, 103, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo polo' AND b.brand_name = 'Canifa'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80', 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=800&auto=format&fit=crop&q=80', 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 103, 15, NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 103, 103, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD030-S-BLK', '893030001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD030-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD030-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD030-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD030-M-BLK', '893030002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD030-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD030-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD030-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD030-M-WHT', '893030003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD030-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD030-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD030-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD030-XL-NAV', '893030004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD030-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD030-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD030-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #31: Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước', 'Chất liệu vải dù phủ màng chống thấm nước, cản gió giữ ấm vượt trội trong thời tiết mưa phùn.', 420000, 110, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 110, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 110, 110, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD031-S-BLK', '893031001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD031-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD031-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD031-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD031-M-BLK', '893031002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD031-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD031-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD031-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD031-M-WHT', '893031003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD031-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD031-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD031-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD031-XL-NAV', '893031004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD031-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD031-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD031-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #32: Áo Khoác Nữ Cardigan Len Gân Cúc Vàng (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng', 'Chất len mềm mịn không gây ngứa dặm, đính cúc kim loại vàng sang chảnh phong cách tiểu thư.', 390000, 117, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 117, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 117, 117, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD032-S-BLK', '893032001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD032-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD032-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD032-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD032-M-BLK', '893032002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD032-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD032-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD032-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD032-M-WHT', '893032003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD032-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD032-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD032-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD032-XL-NAV', '893032004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Cardigan Len Gân Cúc Vàng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD032-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD032-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD032-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #33: Áo Khoác Bomber Lót Dù Dáng Unisex (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Bomber Lót Dù Dáng Unisex', 'Thiết kế bomber kinh điển với cổ bo gân dày, lót trong trần bông ấm áp cho mùa lạnh.', 550000, 124, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Bomber Lót Dù Dáng Unisex');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Bomber Lót Dù Dáng Unisex - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Bomber Lót Dù Dáng Unisex'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Bomber Lót Dù Dáng Unisex - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Bomber Lót Dù Dáng Unisex'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 124, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Bomber Lót Dù Dáng Unisex'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 124, 124, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Bomber Lót Dù Dáng Unisex' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD033-S-BLK', '893033001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Bomber Lót Dù Dáng Unisex'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD033-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD033-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD033-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD033-M-BLK', '893033002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Bomber Lót Dù Dáng Unisex'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD033-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD033-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD033-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD033-M-WHT', '893033003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Bomber Lót Dù Dáng Unisex'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD033-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD033-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD033-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD033-XL-NAV', '893033004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Bomber Lót Dù Dáng Unisex'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD033-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD033-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD033-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #34: Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh', 'Vải tweed cao cấp viền tua rua tinh xảo, phom đứng chuẩn chỉnh tôn vinh nét đài các.', 690000, 131, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1502716119720-b23a93e5fe1b?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 131, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 131, 131, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD034-S-BLK', '893034001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD034-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD034-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD034-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD034-M-BLK', '893034002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD034-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD034-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD034-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD034-M-WHT', '893034003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD034-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD034-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD034-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD034-XL-NAV', '893034004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD034-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD034-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD034-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #35: Áo Khoác Blazer Nam Cổ Điển 1 Khuy (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy', 'Blazer thiết kế 1 khuy hiện đại, lớp lót lụa mềm mại nâng tầm phong cách cho các sự kiện trang trọng.', 790000, 138, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'Owen'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1593030761757-71fae45fa0e7?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 138, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 138, 138, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD035-S-BLK', '893035001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD035-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD035-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD035-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD035-M-BLK', '893035002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD035-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD035-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD035-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD035-M-WHT', '893035003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD035-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD035-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD035-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD035-XL-NAV', '893035004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Blazer Nam Cổ Điển 1 Khuy'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD035-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD035-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD035-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #36: Áo Khoác Jeans Denim Rách Xước Cá Tính (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Jeans Denim Rách Xước Cá Tính', 'Chất denim cotton 100% dày 12oz, hiệu ứng mài rách nhẹ tạo phong cách bụi bặm phong trần.', 490000, 145, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'DirtyCoins'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Jeans Denim Rách Xước Cá Tính');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Jeans Denim Rách Xước Cá Tính - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Jeans Denim Rách Xước Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Jeans Denim Rách Xước Cá Tính - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Jeans Denim Rách Xước Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 145, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Jeans Denim Rách Xước Cá Tính'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 145, 145, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Jeans Denim Rách Xước Cá Tính' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD036-S-BLK', '893036001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Jeans Denim Rách Xước Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD036-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD036-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD036-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD036-M-BLK', '893036002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Jeans Denim Rách Xước Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD036-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD036-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD036-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD036-M-WHT', '893036003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Jeans Denim Rách Xước Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD036-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD036-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD036-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD036-XL-NAV', '893036004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Jeans Denim Rách Xước Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD036-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD036-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD036-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #37: Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo', 'Dáng áo măng tô dài qua gối sang trọng, đai thắt tôn trọn đường cong cơ thể.', 750000, 152, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1548624149-f9b2eb85f164?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 152, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 152, 152, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD037-S-BLK', '893037001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD037-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD037-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD037-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD037-M-BLK', '893037002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD037-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD037-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD037-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD037-M-WHT', '893037003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD037-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD037-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD037-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD037-XL-NAV', '893037004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD037-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD037-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD037-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #38: Áo Khoác Dù Nam Thể Thao Phản Quang (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Dù Nam Thể Thao Phản Quang', 'Dải phản quang an toàn khi chạy bộ đêm, thiết kế thông minh gấp gọn trong túi xách.', 360000, 159, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'Canifa'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Dù Nam Thể Thao Phản Quang');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1544923246-77307dd654cb?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Dù Nam Thể Thao Phản Quang - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Dù Nam Thể Thao Phản Quang'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Dù Nam Thể Thao Phản Quang - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Dù Nam Thể Thao Phản Quang'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 159, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Dù Nam Thể Thao Phản Quang'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 159, 159, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Dù Nam Thể Thao Phản Quang' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD038-S-BLK', '893038001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Dù Nam Thể Thao Phản Quang'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD038-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD038-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD038-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD038-M-BLK', '893038002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Dù Nam Thể Thao Phản Quang'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD038-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD038-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD038-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD038-M-WHT', '893038003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Dù Nam Thể Thao Phản Quang'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD038-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD038-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD038-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD038-XL-NAV', '893038004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Dù Nam Thể Thao Phản Quang'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD038-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD038-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD038-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #39: Áo Khoác Varsity Jacket Phối Tay Da (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Varsity Jacket Phối Tay Da', 'Áo khoác bóng chày thân dạ tay da PU cao cấp, thêu phù hiệu số nổi bật phong cách học đường.', 620000, 166, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Varsity Jacket Phối Tay Da');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1521223890158-f9f7c3d5d504?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Varsity Jacket Phối Tay Da - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Varsity Jacket Phối Tay Da'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Varsity Jacket Phối Tay Da - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Varsity Jacket Phối Tay Da'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 166, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Varsity Jacket Phối Tay Da'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 166, 166, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Varsity Jacket Phối Tay Da' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD039-S-BLK', '893039001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Varsity Jacket Phối Tay Da'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD039-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD039-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD039-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD039-M-BLK', '893039002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Varsity Jacket Phối Tay Da'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD039-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD039-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD039-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD039-M-WHT', '893039003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Varsity Jacket Phối Tay Da'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD039-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD039-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD039-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD039-XL-NAV', '893039004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Varsity Jacket Phối Tay Da'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD039-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD039-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD039-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #40: Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa', 'Trọng lượng siêu nhẹ chỉ 200g, tích hợp mũ trùm sâu bảo vệ tối đa trước gió lạnh.', 440000, 173, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo khoác' AND b.brand_name = 'Biluxury'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1548883354-7622d03aca27?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&auto=format&fit=crop&q=80', 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 173, 15, NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 173, 173, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD040-S-BLK', '893040001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD040-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD040-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD040-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD040-M-BLK', '893040002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD040-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD040-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD040-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD040-M-WHT', '893040003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD040-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD040-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD040-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD040-XL-NAV', '893040004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD040-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD040-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD040-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #41: Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn', 'Nỉ bông chân cua 380gsm giữ ấm tuyệt hảo, mũ 2 lớp may đúp đứng form chuẩn streetwear.', 450000, 180, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 180, 15, NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 180, 180, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD041-S-BLK', '893041001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD041-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD041-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD041-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD041-M-BLK', '893041002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD041-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD041-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD041-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD041-M-WHT', '893041003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD041-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD041-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD041-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD041-XL-NAV', '893041004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD041-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD041-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD041-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #42: Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá', 'Chất nỉ da cá mặt trong êm ái, thấm mồ hôi tốt, kiểu dáng basic mặc đi làm hay đi học đều đẹp.', 320000, 187, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&auto=format&fit=crop&q=80', 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80', 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 187, 15, NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 187, 187, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD042-S-BLK', '893042001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD042-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD042-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD042-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD042-M-BLK', '893042002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD042-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD042-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD042-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD042-M-WHT', '893042003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD042-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD042-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD042-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD042-XL-NAV', '893042004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD042-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD042-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD042-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #43: Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn', 'Dáng croptop khoe eo năng động kết hợp mũ rộng, họa tiết thêu hoạt hình đáng yêu.', 310000, 194, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 194, 15, NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 194, 194, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD043-S-BLK', '893043001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD043-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD043-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD043-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD043-M-BLK', '893043002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD043-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD043-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD043-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD043-M-WHT', '893043003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD043-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD043-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD043-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD043-XL-NAV', '893043004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD043-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD043-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD043-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #44: Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu', 'Dây khóa kéo 2 chiều tiện lợi điều chỉnh độ mở, túi bụng tiện dụng đựng điện thoại ví tiền.', 480000, 101, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'DirtyCoins'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 101, 15, NOW()
FROM products p WHERE p.name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 101, 101, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD044-S-BLK', '893044001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD044-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD044-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD044-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD044-M-BLK', '893044002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD044-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD044-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD044-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD044-M-WHT', '893044003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD044-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD044-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD044-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD044-XL-NAV', '893044004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD044-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD044-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD044-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #45: Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon', 'Công nghệ in nổi 3D dẻo bền màu, gam màu pastel kẹo ngọt cho bạn gái yêu thích sự ngọt ngào.', 340000, 108, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800&auto=format&fit=crop&q=80', 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&auto=format&fit=crop&q=80', 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 108, 15, NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 108, 108, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD045-S-BLK', '893045001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD045-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD045-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD045-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD045-M-BLK', '893045002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD045-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD045-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD045-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD045-M-WHT', '893045003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD045-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD045-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD045-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD045-XL-NAV', '893045004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD045-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD045-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD045-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #46: Áo Hoodie Nam Phối Màu Color Block Trẻ Trung (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung', 'Sự phối hợp màu sắc tương phản độc đáo, mang đến năng lượng tươi mới mỗi ngày dạo phố.', 390000, 115, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'Canifa'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 115, 15, NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 115, 115, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD046-S-BLK', '893046001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD046-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD046-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD046-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD046-M-BLK', '893046002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD046-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD046-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD046-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD046-M-WHT', '893046003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD046-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD046-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD046-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD046-XL-NAV', '893046004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nam Phối Màu Color Block Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD046-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD046-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD046-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #47: Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye', 'Hiệu ứng nhuộm màu loang tie-dye thủ công lạ mắt, không đụng hàng tạo dấu ấn cá nhân.', 420000, 122, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'DirtyCoins'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1554412933-514a83d2f3c8?w=800&auto=format&fit=crop&q=80', 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80', 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 122, 15, NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 122, 122, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD047-S-BLK', '893047001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD047-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD047-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD047-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD047-M-BLK', '893047002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD047-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD047-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD047-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD047-M-WHT', '893047003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD047-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD047-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD047-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD047-XL-NAV', '893047004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD047-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD047-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD047-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #48: Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần', 'Thiết kế dài trùm mông thời thượng cho mốt giấu quần, vải lót nỉ bông ấm áp.', 370000, 129, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 129, 15, NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 129, 129, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD048-S-BLK', '893048001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD048-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD048-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD048-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD048-M-BLK', '893048002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD048-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD048-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD048-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD048-M-WHT', '893048003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD048-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD048-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD048-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD048-XL-NAV', '893048004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD048-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD048-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD048-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #49: Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực', 'Thêu dập chìm đồng màu tinh tế, đường may vắt sổ 4 kim bền chắc chịu lực tốt.', 360000, 136, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'Biluxury'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=800&auto=format&fit=crop&q=80', 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80', 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 136, 15, NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 136, 136, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD049-S-BLK', '893049001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD049-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD049-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD049-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD049-M-BLK', '893049002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD049-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD049-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD049-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD049-M-WHT', '893049003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD049-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD049-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD049-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD049-XL-NAV', '893049004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD049-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD049-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD049-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #50: Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy', 'Mực in chuyển nhiệt công nghệ Nhật Bản sắc nét, thể hiện cá tính tự do của giới trẻ.', 460000, 143, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Áo hoodie & Sweatshirt' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1584273143981-41c073dfe8f8?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy - Ảnh chính', 1
FROM products p WHERE p.name = 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800&auto=format&fit=crop&q=80', 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 143, 15, NOW()
FROM products p WHERE p.name = 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 143, 143, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD050-S-BLK', '893050001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD050-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD050-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD050-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD050-M-BLK', '893050002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD050-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD050-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD050-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD050-M-WHT', '893050003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD050-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD050-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD050-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD050-XL-NAV', '893050004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD050-XL-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD050-XL-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'XL'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD050-XL-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #51: Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều', 'Chất vải denim pha thun spandex co giãn thoải mái, ôm nhẹ vừa vặn tôn chiều cao đôi chân.', 390000, 150, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 150, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 150, 150, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD051-29-BLK', '893051001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD051-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD051-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD051-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD051-30-BLK', '893051002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD051-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD051-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD051-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD051-30-WHT', '893051003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD051-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD051-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD051-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD051-32-NAV', '893051004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD051-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD051-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD051-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #52: Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao', 'Cạp cao che trọn khuyết điểm eo, ống suông rộng tạo hiệu ứng kéo dài chân miên man.', 360000, 157, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 157, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 157, 157, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD052-29-BLK', '893052001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD052-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD052-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD052-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD052-30-BLK', '893052002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD052-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD052-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD052-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD052-30-WHT', '893052003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD052-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD052-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD052-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD052-32-NAV', '893052004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD052-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD052-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD052-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #53: Quần Jeans Nam Dáng Suông Straight Rửa Màu (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Nam Dáng Suông Straight Rửa Màu', 'Kỹ thuật wash enzyme tạo vệt sáng tự nhiên, phom thẳng đứng cổ điển không bao giờ lỗi mốt.', 420000, 164, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'Routine'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Nam Dáng Suông Straight Rửa Màu');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nam Dáng Suông Straight Rửa Màu - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Suông Straight Rửa Màu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nam Dáng Suông Straight Rửa Màu - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Suông Straight Rửa Màu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 164, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Suông Straight Rửa Màu'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 164, 164, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Nam Dáng Suông Straight Rửa Màu' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD053-29-BLK', '893053001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Suông Straight Rửa Màu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD053-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD053-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD053-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD053-30-BLK', '893053002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Suông Straight Rửa Màu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD053-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD053-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD053-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD053-30-WHT', '893053003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Suông Straight Rửa Màu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD053-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD053-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD053-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD053-32-NAV', '893053004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Dáng Suông Straight Rửa Màu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD053-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD053-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD053-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #54: Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng', 'Độ đàn hồi cực tốt nâng mông ôm trọn đường cong gợi cảm, cạp cao 3 khuy cá tính.', 340000, 171, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 171, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 171, 171, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD054-29-BLK', '893054001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD054-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD054-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD054-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD054-30-BLK', '893054002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD054-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD054-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD054-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD054-30-WHT', '893054003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD054-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD054-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD054-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD054-32-NAV', '893054004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD054-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD054-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD054-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #55: Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính', 'Vết cắt rách laser tinh xảo ở đầu gối, chất vải denim 13oz bền chắc chuẩn phong cách đường phố.', 460000, 178, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1508427953056-b00b8d78ebf5?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 178, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 178, 178, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD055-29-BLK', '893055001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD055-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD055-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD055-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD055-30-BLK', '893055002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD055-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD055-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD055-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD055-30-WHT', '893055003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD055-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD055-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD055-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD055-32-NAV', '893055004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD055-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD055-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD055-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #56: Quần Jeans Nữ Baggy Ống Túm Xắn Gấu (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu', 'Phom baggy rộng rãi hông và đùi bo nhẹ gấu, đem lại vẻ đẹp tinh nghịch năng động.', 330000, 185, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 185, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 185, 185, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD056-29-BLK', '893056001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD056-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD056-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD056-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD056-30-BLK', '893056002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD056-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD056-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD056-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD056-30-WHT', '893056003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD056-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD056-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD056-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD056-32-NAV', '893056004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Baggy Ống Túm Xắn Gấu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD056-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD056-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD056-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #57: Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm', 'Gấu quần cắt tưa chỉ tự nhiên raw hem, tạo phong thái phóng khoáng cực ngầu.', 450000, 192, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'DirtyCoins'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1475178626620-a4d074967452?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 192, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 192, 192, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD057-29-BLK', '893057001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD057-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD057-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD057-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD057-30-BLK', '893057002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD057-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD057-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD057-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD057-30-WHT', '893057003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD057-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD057-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD057-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD057-32-NAV', '893057004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD057-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD057-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD057-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #58: Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển', 'Dáng loe nhẹ từ đầu gối xuống gấu quần, cân đối tỷ lệ cơ thể và tôn vinh nét quyến rũ.', 380000, 199, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1506630448388-4e683c67ddb0?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 199, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 199, 199, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD058-29-BLK', '893058001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD058-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD058-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD058-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD058-30-BLK', '893058002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD058-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD058-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD058-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD058-30-WHT', '893058003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD058-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD058-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD058-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD058-32-NAV', '893058004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD058-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD058-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD058-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #59: Quần Jeans Unisex Túi Hộp Đa Năng Cargo (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo', 'Thiết kế túi hộp utility hai bên sườn khỏe khoắn, phối dây đai bản to độc đáo.', 490000, 106, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'DirtyCoins'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 106, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 106, 106, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD059-29-BLK', '893059001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD059-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD059-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD059-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD059-30-BLK', '893059002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD059-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD059-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD059-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD059-30-WHT', '893059003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD059-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD059-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD059-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD059-32-NAV', '893059004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Unisex Túi Hộp Đa Năng Cargo'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD059-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD059-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD059-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #60: Quần Jeans Nam Đen Tuyền Jet Black Không Phai (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai', 'Nhuộm đen tuyền công nghệ khóa màu cao cấp, giữ sắc đen chuẩn sau hơn 50 lần giặt.', 480000, 113, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần jeans' AND b.brand_name = 'Biluxury'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1516826957135-700dedea698c?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=800&auto=format&fit=crop&q=80', 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 113, 15, NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 113, 113, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD060-29-BLK', '893060001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD060-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD060-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD060-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD060-30-BLK', '893060002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD060-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD060-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD060-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD060-30-WHT', '893060003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD060-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD060-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD060-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD060-32-NAV', '893060004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Jeans Nam Đen Tuyền Jet Black Không Phai'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD060-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD060-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD060-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #61: Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở', 'Vải kaki cotton chải kỹ mềm mại, co giãn nhẹ không nhăn gối giúp bạn tự tin suốt ngày dài.', 390000, 120, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'Owen'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 120, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 120, 120, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD061-29-BLK', '893061001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD061-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD061-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD061-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD061-30-BLK', '893061002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD061-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD061-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD061-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD061-30-WHT', '893061003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD061-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD061-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD061-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD061-32-NAV', '893061004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD061-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD061-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD061-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #62: Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch', 'Chi tiết ly trước tạo phom đứng đứng đắn, tôn nét đoan trang lịch sự nơi công sở.', 340000, 127, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 127, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 127, 127, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD062-29-BLK', '893062001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD062-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD062-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD062-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD062-30-BLK', '893062002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD062-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD062-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD062-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD062-30-WHT', '893062003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD062-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD062-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD062-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD062-32-NAV', '893062004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD062-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD062-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD062-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #63: Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế', 'Khuy cài sừng tự nhiên cao cấp, túi sau mổ khéo léo hoàn thiện phong cách quý ông.', 370000, 134, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'Routine'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 134, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 134, 134, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD063-29-BLK', '893063001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD063-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD063-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD063-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD063-30-BLK', '893063002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD063-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD063-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD063-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD063-30-WHT', '893063003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD063-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD063-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD063-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD063-32-NAV', '893063004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD063-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD063-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD063-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #64: Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu', 'Gấu quần có dây rút tùy chỉnh ống suông hoặc ống túm jogger, biến hóa phong cách đa dạng.', 420000, 141, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 141, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 141, 141, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD064-29-BLK', '893064001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD064-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD064-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD064-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD064-30-BLK', '893064002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD064-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD064-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD064-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD064-30-WHT', '893064003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD064-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD064-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD064-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD064-32-NAV', '893064004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD064-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD064-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD064-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #65: Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng', 'Chiều dài qua bắp chân nhẹ nhàng duyên dáng, phối đồ cực chuẩn với sơ mi hoặc áo phông.', 320000, 148, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 148, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 148, 148, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD065-29-BLK', '893065001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD065-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD065-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD065-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD065-30-BLK', '893065002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD065-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD065-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD065-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD065-30-WHT', '893065003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD065-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD065-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD065-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD065-32-NAV', '893065004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD065-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD065-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD065-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #66: Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi', 'Lưng chun kết hợp dây rút ẩn bên trong, vừa vặn vòng bụng kể cả sau bữa ăn no.', 350000, 155, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1516914943479-89db7d9ae7f2?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 155, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 155, 155, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD066-29-BLK', '893066001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD066-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD066-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD066-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD066-30-BLK', '893066002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD066-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD066-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD066-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD066-30-WHT', '893066003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD066-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD066-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD066-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD066-32-NAV', '893066004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD066-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD066-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD066-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #67: Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển', 'Màu be kinh điển dễ phối giày da và sneaker, chất liệu kaki dày dặn chống sờn rách.', 410000, 162, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'Biluxury'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 162, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 162, 162, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD067-29-BLK', '893067001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD067-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD067-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD067-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD067-30-BLK', '893067002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD067-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD067-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD067-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD067-30-WHT', '893067003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD067-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD067-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD067-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD067-32-NAV', '893067004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD067-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD067-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD067-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #68: Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông', 'Khóa kéo ẩn bên sườn tinh gọn mặt trước phẳng phiu, tôn dáng thon gọn.', 310000, 169, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1523398002811-999ca8dec234?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 169, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 169, 169, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD068-29-BLK', '893068001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD068-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD068-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD068-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD068-30-BLK', '893068002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD068-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD068-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD068-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD068-30-WHT', '893068003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD068-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD068-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD068-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD068-32-NAV', '893068004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD068-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD068-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD068-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #69: Quần Kaki Unisex Cạp Chun Rộng Thoải Mái (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái', 'Phom dáng baggy ống suông vừa phải, mang lại cảm giác thoải mái khi di chuyển ngoài trời.', 330000, 176, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'Canifa'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 176, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 176, 176, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD069-29-BLK', '893069001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD069-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD069-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD069-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD069-30-BLK', '893069002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD069-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD069-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD069-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD069-30-WHT', '893069003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD069-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD069-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD069-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD069-32-NAV', '893069004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Unisex Cạp Chun Rộng Thoải Mái'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD069-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD069-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD069-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #70: Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi', 'Kỹ thuật may đo sartorial với 2 ly xếp sang trọng, đường may thủ công tỉ mỉ từng chi tiết.', 590000, 183, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần kaki' AND b.brand_name = 'An Phước'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1514327605112-b887c0e61c0a?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80', 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 183, 15, NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 183, 183, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD070-29-BLK', '893070001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD070-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD070-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD070-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD070-30-BLK', '893070002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD070-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD070-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD070-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD070-30-WHT', '893070003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD070-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD070-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD070-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD070-32-NAV', '893070004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD070-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD070-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD070-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #71: Quần Short Kaki Nam Túi Sâu Dạo Phố (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Kaki Nam Túi Sâu Dạo Phố', 'Chiều dài ngang gối lịch sự, túi xéo trước sâu đựng vừa điện thoại kích thước lớn an toàn.', 210000, 190, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'Coolmate'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Kaki Nam Túi Sâu Dạo Phố');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80', 'Quần Short Kaki Nam Túi Sâu Dạo Phố - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Kaki Nam Túi Sâu Dạo Phố'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1565084888279-aca607ecce0c?w=800&auto=format&fit=crop&q=80', 'Quần Short Kaki Nam Túi Sâu Dạo Phố - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Kaki Nam Túi Sâu Dạo Phố'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 190, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Kaki Nam Túi Sâu Dạo Phố'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 190, 190, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Kaki Nam Túi Sâu Dạo Phố' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD071-29-BLK', '893071001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Kaki Nam Túi Sâu Dạo Phố'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD071-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD071-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD071-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD071-30-BLK', '893071002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Kaki Nam Túi Sâu Dạo Phố'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD071-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD071-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD071-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD071-30-WHT', '893071003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Kaki Nam Túi Sâu Dạo Phố'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD071-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD071-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD071-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD071-32-NAV', '893071004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Kaki Nam Túi Sâu Dạo Phố'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD071-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD071-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD071-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #72: Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động', 'Cạp cao ôm gọn hông, gấu tưa chỉ tạo vẻ phóng khoáng cho những buổi dạo biển mùa hè.', 230000, 197, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1565084888279-aca607ecce0c?w=800&auto=format&fit=crop&q=80', 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80', 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 197, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 197, 197, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD072-29-BLK', '893072001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD072-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD072-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD072-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD072-30-BLK', '893072002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD072-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD072-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD072-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD072-30-WHT', '893072003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD072-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD072-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD072-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD072-32-NAV', '893072004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD072-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD072-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD072-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #73: Quần Short Unisex Dù Gió Thể Thao 2 Lớp (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp', 'Lớp trong thun ôm chống ma sát đùi, lớp ngoài vải dù nhẹ chống nước nhẹ khi chạy bộ.', 260000, 104, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=800&auto=format&fit=crop&q=80', 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80', 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 104, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 104, 104, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD073-29-BLK', '893073001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD073-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD073-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD073-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD073-30-BLK', '893073002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD073-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD073-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD073-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD073-30-WHT', '893073003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD073-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD073-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD073-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD073-32-NAV', '893073004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Dù Gió Thể Thao 2 Lớp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD073-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD073-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD073-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #74: Quần Short Nam Vải Đũi Linen Thoáng Mát (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Nam Vải Đũi Linen Thoáng Mát', 'Chất đũi tự nhiên thấm hút mồ hôi cực nhanh, mát mẻ giải nhiệt tối đa ngày oi bức.', 240000, 111, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'Routine'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Nam Vải Đũi Linen Thoáng Mát');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591195856475-472d8a07c31d?w=800&auto=format&fit=crop&q=80', 'Quần Short Nam Vải Đũi Linen Thoáng Mát - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Nam Vải Đũi Linen Thoáng Mát'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80', 'Quần Short Nam Vải Đũi Linen Thoáng Mát - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Nam Vải Đũi Linen Thoáng Mát'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 111, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Nam Vải Đũi Linen Thoáng Mát'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 111, 111, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Nam Vải Đũi Linen Thoáng Mát' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD074-29-BLK', '893074001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Vải Đũi Linen Thoáng Mát'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD074-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD074-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD074-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD074-30-BLK', '893074002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Vải Đũi Linen Thoáng Mát'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD074-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD074-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD074-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD074-30-WHT', '893074003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Vải Đũi Linen Thoáng Mát'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD074-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD074-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD074-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD074-32-NAV', '893074004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Vải Đũi Linen Thoáng Mát'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD074-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD074-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD074-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #75: Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng', 'Dáng xòe chữ A nhẹ tạo cảm giác đùi thon gọn, tặng kèm dây lưng da nhỏ xinh xắn.', 270000, 118, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1550614000-4895a10e1bfd?w=800&auto=format&fit=crop&q=80', 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1508427953056-b00b8d78ebf5?w=800&auto=format&fit=crop&q=80', 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 118, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 118, 118, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD075-29-BLK', '893075001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD075-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD075-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD075-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD075-30-BLK', '893075002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD075-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD075-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD075-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD075-30-WHT', '893075003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD075-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD075-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD075-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD075-32-NAV', '893075004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD075-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD075-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD075-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #76: Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại', 'Chất nỉ mềm mại mặc ở nhà hay ra ngoài đều tiện, dây rút dập đầu kim loại sang trọng.', 250000, 125, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'DirtyCoins'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1506152983158-b4a74a01c721?w=800&auto=format&fit=crop&q=80', 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80', 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 125, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 125, 125, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD076-29-BLK', '893076001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD076-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD076-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD076-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD076-30-BLK', '893076002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD076-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD076-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD076-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD076-30-WHT', '893076003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD076-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD076-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD076-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD076-32-NAV', '893076004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD076-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD076-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD076-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #77: Quần Short Nam Bơi Họa Tiết Mau Khô (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Nam Bơi Họa Tiết Mau Khô', 'Chất vải polyester mau khô đặc biệt, lót lưới kháng khuẩn bên trong thoải mái bơi lội.', 199000, 132, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'Canifa'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Nam Bơi Họa Tiết Mau Khô');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&auto=format&fit=crop&q=80', 'Quần Short Nam Bơi Họa Tiết Mau Khô - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Nam Bơi Họa Tiết Mau Khô'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1565084888279-aca607ecce0c?w=800&auto=format&fit=crop&q=80', 'Quần Short Nam Bơi Họa Tiết Mau Khô - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Nam Bơi Họa Tiết Mau Khô'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 132, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Nam Bơi Họa Tiết Mau Khô'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 132, 132, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Nam Bơi Họa Tiết Mau Khô' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD077-29-BLK', '893077001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Bơi Họa Tiết Mau Khô'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD077-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD077-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD077-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD077-30-BLK', '893077002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Bơi Họa Tiết Mau Khô'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD077-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD077-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD077-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD077-30-WHT', '893077003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Bơi Họa Tiết Mau Khô'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD077-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD077-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD077-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD077-32-NAV', '893077004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Bơi Họa Tiết Mau Khô'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD077-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD077-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD077-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #78: Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính', 'Dạ tweed kim tuyến nhẹ viền ren tỉ mỉ, diện cùng áo len hoặc blazer cực đẹp.', 290000, 139, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1503342394128-c104d54dba01?w=800&auto=format&fit=crop&q=80', 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1550614000-4895a10e1bfd?w=800&auto=format&fit=crop&q=80', 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 139, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 139, 139, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD078-29-BLK', '893078001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD078-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD078-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD078-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD078-30-BLK', '893078002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD078-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD078-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD078-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD078-30-WHT', '893078003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD078-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD078-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD078-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD078-32-NAV', '893078004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD078-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD078-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD078-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #79: Quần Short Nam Chinos Cắt May Chỉn Chu (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Nam Chinos Cắt May Chỉn Chu', 'Phom dáng may đo chuẩn mực, khóa đồng chắc chắn, lý tưởng khi đi đánh golf hay du lịch.', 280000, 146, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'Biluxury'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Nam Chinos Cắt May Chỉn Chu');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1529720317453-c8da503f2051?w=800&auto=format&fit=crop&q=80', 'Quần Short Nam Chinos Cắt May Chỉn Chu - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Nam Chinos Cắt May Chỉn Chu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80', 'Quần Short Nam Chinos Cắt May Chỉn Chu - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Nam Chinos Cắt May Chỉn Chu'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 146, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Nam Chinos Cắt May Chỉn Chu'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 146, 146, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Nam Chinos Cắt May Chỉn Chu' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD079-29-BLK', '893079001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Chinos Cắt May Chỉn Chu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD079-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD079-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD079-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD079-30-BLK', '893079002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Chinos Cắt May Chỉn Chu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD079-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD079-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD079-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD079-30-WHT', '893079003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Chinos Cắt May Chỉn Chu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD079-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD079-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD079-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD079-32-NAV', '893079004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Nam Chinos Cắt May Chỉn Chu'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD079-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD079-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD079-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #80: Quần Short Unisex Cargo Túi Hộp Bụi Bặm (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm', 'Túi hộp nắp gập tiện lợi phong cách dã ngoại gorpcore, chất vải canvas mỏng bền bỉ.', 290000, 153, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Quần short' AND b.brand_name = 'Levents'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1516762689617-e1cffcef479d?w=800&auto=format&fit=crop&q=80', 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=800&auto=format&fit=crop&q=80', 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 153, 15, NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 153, 153, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD080-29-BLK', '893080001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD080-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD080-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD080-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD080-30-BLK', '893080002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD080-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD080-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD080-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD080-30-WHT', '893080003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD080-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD080-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD080-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD080-32-NAV', '893080004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Short Unisex Cargo Túi Hộp Bụi Bặm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD080-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD080-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD080-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #81: Quần Tây Nam Dáng Slimfit Xếp Ly Trước (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước', 'Chất vải tuyết mưa nhập khẩu mềm rủ, phom slimfit hiện đại nâng tầm diện mạo công sở.', 490000, 160, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'Owen'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 160, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 160, 160, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD081-29-BLK', '893081001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD081-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD081-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD081-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD081-30-BLK', '893081002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD081-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD081-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD081-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD081-30-WHT', '893081003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD081-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD081-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD081-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD081-32-NAV', '893081004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Dáng Slimfit Xếp Ly Trước'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD081-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD081-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD081-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #82: Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông', 'Thiết kế ống loe thời thượng kết hợp cạp cao tôn trọn vòng 3 quyến rũ và đôi chân dài.', 420000, 167, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1550639525-c97d455acf70?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 167, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 167, 167, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD082-29-BLK', '893082001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD082-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD082-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD082-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD082-30-BLK', '893082002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD082-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD082-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD082-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD082-30-WHT', '893082003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD082-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD082-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD082-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD082-32-NAV', '893082004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD082-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD082-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD082-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #83: Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh', 'Cơ chế tăng đơ 2 bên hông mở rộng thêm 3-5cm linh hoạt, không lo chật bụng sau tiệc tùng.', 530000, 174, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'Biluxury'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1479064555552-3ce4979f8908?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 174, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 174, 174, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD083-29-BLK', '893083001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD083-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD083-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD083-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD083-30-BLK', '893083002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD083-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD083-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD083-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD083-30-WHT', '893083003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD083-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD083-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD083-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD083-32-NAV', '893083004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD083-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD083-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD083-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #84: Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng', 'Ống suông rộng bay bổng, đường ly ủi chết không mất nếp sau khi giặt là.', 390000, 181, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1508296695146-257a814070b4?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 181, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 181, 181, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD084-29-BLK', '893084001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD084-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD084-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD084-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD084-30-BLK', '893084002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD084-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD084-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD084-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD084-30-WHT', '893084003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD084-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD084-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD084-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD084-32-NAV', '893084004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD084-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD084-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD084-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #85: Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial', 'Đai khóa Gurkha kiểu quân đội Anh quý tộc, tôn vinh phong thái cổ điển của quý ông thành đạt.', 690000, 188, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'An Phước'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1489980556514-2797052a5782?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 188, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 188, 188, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD085-29-BLK', '893085001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD085-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD085-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD085-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD085-30-BLK', '893085002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD085-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD085-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD085-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD085-30-WHT', '893085003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD085-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD085-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD085-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD085-32-NAV', '893085004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD085-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD085-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD085-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #86: Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle', 'Chiều dài trên mắt cá chân khoe đôi giày cao gót tinh tế, phom baggy trẻ trung dễ chịu.', 360000, 195, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1551803091-e20673f15770?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 195, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 195, 195, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD086-29-BLK', '893086001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD086-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD086-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD086-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD086-30-BLK', '893086002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD086-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD086-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD086-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD086-30-WHT', '893086003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD086-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD086-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD086-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD086-32-NAV', '893086004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD086-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD086-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD086-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #87: Quần Tây Nam Vải Wool Pha Sợi Co Giãn (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn', 'Thành phần len tự nhiên giữ ấm thoáng khí, bề mặt vải lì cao cấp chuẩn phong cách Châu Âu.', 620000, 102, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'Owen'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1504198453319-5ce911bafc46?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 102, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 102, 102, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD087-29-BLK', '893087001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD087-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD087-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD087-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD087-30-BLK', '893087002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD087-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD087-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD087-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD087-30-WHT', '893087003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD087-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD087-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD087-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD087-32-NAV', '893087004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Vải Wool Pha Sợi Co Giãn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD087-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD087-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD087-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #88: Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính', 'Đường xẻ tà trước gấu quần tạo hiệu ứng bay bổng uyển chuyển theo từng bước chân.', 450000, 109, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 109, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 109, 109, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD088-29-BLK', '893088001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD088-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD088-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD088-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD088-30-BLK', '893088002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD088-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD088-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD088-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD088-30-WHT', '893088003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD088-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD088-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD088-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD088-32-NAV', '893088004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD088-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD088-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD088-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #89: Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng (UNISEX)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng', 'Dáng quần âu ống rộng thời thượng chuẩn phong cách Hàn Quốc, phù hợp cả nam và nữ.', 480000, 116, c.id, b.brand_id, 0, 'UNISEX'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'Routine'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1504593811423-6dd665756598?w=800&auto=format&fit=crop&q=80', 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80', 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 116, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 116, 116, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD089-29-BLK', '893089001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD089-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD089-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD089-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD089-30-BLK', '893089002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD089-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD089-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD089-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD089-30-WHT', '893089003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD089-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD089-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD089-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD089-32-NAV', '893089004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD089-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD089-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD089-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #90: Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm (MALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm', 'Họa tiết kẻ sọc chìm tôn vinh phong thái đỉnh đạc, vải ít nhăn giữ nếp hoàn hảo cả ngày.', 580000, 123, c.id, b.brand_id, 0, 'MALE'
FROM categories c, brands b
WHERE c.name = 'Quần tây' AND b.brand_name = 'An Phước'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1490114538077-ac7f12197170?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm - Ảnh chính', 1
FROM products p WHERE p.name = 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1593030761757-71fae45fa0e7?w=800&auto=format&fit=crop&q=80', 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 123, 15, NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 123, 123, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD090-29-BLK', '893090001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD090-29-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD090-29-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '29'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD090-29-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD090-30-BLK', '893090002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD090-30-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD090-30-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD090-30-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD090-30-WHT', '893090003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD090-30-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD090-30-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '30'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD090-30-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD090-32-NAV', '893090004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD090-32-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD090-32-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = '32'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD090-32-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #91: Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại', 'Phom chữ A che khuyết điểm hông to, khóa kéo giọt nước phía sau tinh tế tiện dụng.', 290000, 130, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1582142306909-195724d33ffc?w=800&auto=format&fit=crop&q=80', 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại - Ảnh chính', 1
FROM products p WHERE p.name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1550614000-4895a10e1bfd?w=800&auto=format&fit=crop&q=80', 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 130, 15, NOW()
FROM products p WHERE p.name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 130, 130, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD091-S-BLK', '893091001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD091-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD091-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD091-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD091-M-BLK', '893091002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD091-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD091-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD091-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD091-M-WHT', '893091003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD091-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD091-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD091-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD091-L-NAV', '893091004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD091-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD091-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD091-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #92: Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc', 'Chất vải gấm hoa nổi sang trọng, tùng váy xòe bồng bềnh lộng lẫy cho những đêm tiệc.', 590000, 137, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800&auto=format&fit=crop&q=80', 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc - Ảnh chính', 1
FROM products p WHERE p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=800&auto=format&fit=crop&q=80', 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 137, 15, NOW()
FROM products p WHERE p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 137, 137, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD092-S-BLK', '893092001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD092-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD092-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD092-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD092-M-BLK', '893092002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD092-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD092-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD092-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD092-M-WHT', '893092003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD092-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD092-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD092-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD092-L-NAV', '893092004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD092-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD092-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD092-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #93: Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc', 'Nếp ly dập nhiệt công nghệ cao không bị bung duỗi, lưng chun co giãn nhẹ nhàng.', 320000, 144, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800&auto=format&fit=crop&q=80', 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc - Ảnh chính', 1
FROM products p WHERE p.name = 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1582142306909-195724d33ffc?w=800&auto=format&fit=crop&q=80', 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 144, 15, NOW()
FROM products p WHERE p.name = 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 144, 144, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD093-S-BLK', '893093001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD093-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD093-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD093-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD093-M-BLK', '893093002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD093-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD093-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD093-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD093-M-WHT', '893093003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD093-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD093-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD093-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD093-L-NAV', '893093004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD093-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD093-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD093-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #94: Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung', 'Chất thun cá sấu cotton thấm mồ hôi, kiểu dáng suông thoải mái thích hợp dạo phố ngày hè.', 350000, 151, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Canifa'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=800&auto=format&fit=crop&q=80', 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung - Ảnh chính', 1
FROM products p WHERE p.name = 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=800&auto=format&fit=crop&q=80', 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 151, 15, NOW()
FROM products p WHERE p.name = 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 151, 151, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD094-S-BLK', '893094001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD094-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD094-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD094-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD094-M-BLK', '893094002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD094-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD094-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD094-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD094-M-WHT', '893094003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD094-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD094-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD094-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD094-L-NAV', '893094004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD094-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD094-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD094-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #95: Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm', 'Thiết kế ôm sát tôn trọn vòng eo và hông, đường xẻ tà sau hỗ trợ bước đi uyển chuyển.', 340000, 158, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=800&auto=format&fit=crop&q=80', 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm - Ảnh chính', 1
FROM products p WHERE p.name = 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1582142306909-195724d33ffc?w=800&auto=format&fit=crop&q=80', 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 158, 15, NOW()
FROM products p WHERE p.name = 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 158, 158, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD095-S-BLK', '893095001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD095-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD095-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD095-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD095-M-BLK', '893095002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD095-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD095-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD095-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD095-M-WHT', '893095003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD095-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD095-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD095-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD095-L-NAV', '893095004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD095-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD095-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD095-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #96: Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ', 'Thiết kế cổ yếm khoe lưng trần thon gọn, chất vải thun nhung co giãn bắt sáng nhẹ.', 420000, 165, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1612336307429-8a898d10e223?w=800&auto=format&fit=crop&q=80', 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ - Ảnh chính', 1
FROM products p WHERE p.name = 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800&auto=format&fit=crop&q=80', 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 165, 15, NOW()
FROM products p WHERE p.name = 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 165, 165, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD096-S-BLK', '893096001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD096-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD096-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD096-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD096-M-BLK', '893096002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD096-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD096-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD096-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD096-M-WHT', '893096003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD096-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD096-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD096-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD096-L-NAV', '893096004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD096-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD096-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD096-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #97: Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng', 'Đuôi cá xòe nhẹ tạo nét bay bổng trên nền vải denim bụi bặm, phá cách và hút mắt.', 360000, 172, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Routine'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1502716119720-b23a93e5fe1b?w=800&auto=format&fit=crop&q=80', 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng - Ảnh chính', 1
FROM products p WHERE p.name = 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80', 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 172, 15, NOW()
FROM products p WHERE p.name = 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 172, 172, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD097-S-BLK', '893097001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD097-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD097-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD097-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD097-M-BLK', '893097002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD097-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD097-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD097-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD097-M-WHT', '893097003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD097-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD097-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD097-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD097-L-NAV', '893097004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD097-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD097-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD097-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #98: Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng', 'Họa tiết hoa cúc nhí lãng mạn, chất voan tơ mềm mại bay bổng trong từng cơn gió thu.', 410000, 179, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Gumac'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=800&auto=format&fit=crop&q=80', 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng - Ảnh chính', 1
FROM products p WHERE p.name = 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1612336307429-8a898d10e223?w=800&auto=format&fit=crop&q=80', 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 179, 15, NOW()
FROM products p WHERE p.name = 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 179, 179, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD098-S-BLK', '893098001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD098-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD098-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD098-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD098-M-BLK', '893098002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD098-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD098-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD098-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD098-M-WHT', '893098003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD098-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD098-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD098-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD098-L-NAV', '893098004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD098-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD098-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD098-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #99: Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn', 'Chất dạ tweed dày dặn có lót trong quần bảo hộ tiện lợi, điểm xuyết cúc ngọc trai quý phái.', 370000, 186, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Elise'
AND NOT EXISTS (SELECT 1 FROM products WHERE name = 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn');
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1492707892479-7bc8d5a4ee93?w=800&auto=format&fit=crop&q=80', 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn - Ảnh chính', 1
FROM products p WHERE p.name = 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&auto=format&fit=crop&q=80', 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 186, 15, NOW()
FROM products p WHERE p.name = 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 186, 186, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD099-S-BLK', '893099001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD099-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD099-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD099-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD099-M-BLK', '893099002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD099-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD099-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD099-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD099-M-WHT', '893099003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD099-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD099-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD099-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD099-L-NAV', '893099004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD099-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD099-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD099-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- Product #100: Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp (FEMALE)
INSERT INTO products (name, description, price, quantity, category_id, brand_id, is_deleted, gender)
SELECT 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp', 'Sự kết hợp giữa nét nghiêm túc của sơ mi và sự dịu dàng của váy đầm, cực kỳ tôn dáng.', 460000, 193, c.id, b.brand_id, 0, 'FEMALE'
FROM categories c, brands b
WHERE c.name = 'Váy & Đầm' AND b.brand_name = 'Gumac'
AND NOT EXISTS (
    SELECT 1 FROM products
    WHERE name = 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp'
       OR description = 'Sự kết hợp giữa nét nghiêm túc của sơ mi và sự dịu dàng của váy đầm, cực kỳ tôn dáng.'
);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1525450824786-227cbef70703?w=800&auto=format&fit=crop&q=80', 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp - Ảnh chính', 1
FROM products p WHERE p.name = 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 1);
INSERT INTO product_images (product_id, image_url, alt_text, is_primary)
SELECT p.id, 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&auto=format&fit=crop&q=80', 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp - Ảnh chi tiết', 0
FROM products p WHERE p.name = 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp'
AND NOT EXISTS (SELECT 1 FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = 0);
INSERT INTO inventories (product_id, quantity, low_stock_threshold, updated_at)
SELECT p.id, 193, 15, NOW()
FROM products p WHERE p.name = 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp'
AND NOT EXISTS (SELECT 1 FROM inventories inv WHERE inv.product_id = p.id);
INSERT INTO inventory_transactions (product_id, quantity_change, quantity_after, reason, created_by, created_at)
SELECT p.id, 193, 193, 'Nhập kho ban đầu cho sản phẩm mới', u.user_id, NOW()
FROM products p, users u
WHERE p.name = 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (
    SELECT 1 FROM inventory_transactions it 
    WHERE it.product_id = p.id AND it.reason = 'Nhập kho ban đầu cho sản phẩm mới'
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD100-S-BLK', '893100001', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD100-S-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD100-S-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'S'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD100-S-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD100-M-BLK', '893100002', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD100-M-BLK');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD100-M-BLK' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD100-M-BLK' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Đen'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD100-M-WHT', '893100003', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD100-M-WHT');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD100-M-WHT' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'M'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD100-M-WHT' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Trắng'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variants (product_id, sku, barcode, weight, status, created_at, updated_at)
SELECT p.id, 'PRD100-L-NAV', '893100004', 0.350, 'ACTIVE', NOW(), NOW()
FROM products p WHERE p.name = 'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp'
AND NOT EXISTS (SELECT 1 FROM product_variants WHERE sku = 'PRD100-L-NAV');
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD100-L-NAV' AND pa.name = 'Size' AND pav.attribute_id = pa.id AND pav.value = 'L'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);
INSERT INTO product_variant_attributes (variant_id, attribute_value_id)
SELECT pv.id, pav.id
FROM product_variants pv, product_attribute_values pav, product_attributes pa
WHERE pv.sku = 'PRD100-L-NAV' AND pa.name = 'Color' AND pav.attribute_id = pa.id AND pav.value = 'Xanh Navy'
AND NOT EXISTS (
    SELECT 1 FROM product_variant_attributes pva 
    WHERE pva.variant_id = pv.id AND pva.attribute_value_id = pav.id
);

-- ------------------------------------------------------------------------------
-- 8. ADDRESSES (Địa chỉ cho User demo và một số User mẫu)
-- ------------------------------------------------------------------------------
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Quản Trị Viên Demo', '0901234567', 'Hà Nội', 'Số 12 phố Tràng Tiền, Phường Tràng Tiền, Quận Hoàn Kiếm'
FROM users u WHERE UPPER(u.email) = UPPER('admin@gmail.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = 'Số 12 phố Tràng Tiền, Phường Tràng Tiền, Quận Hoàn Kiếm'
);
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Trần Minh Dương', '0902345678', 'TP. Hồ Chí Minh', '123 Đường Nguyễn Huệ, Phường Bến Nghé, Quận 1'
FROM users u WHERE UPPER(u.email) = UPPER('duong@gmail.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = '123 Đường Nguyễn Huệ, Phường Bến Nghé, Quận 1'
);
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Trần Minh Dương (Văn phòng)', '0902345678', 'TP. Hồ Chí Minh', 'Tòa nhà Bitexco, số 2 Hải Triều, Bến Nghé, Quận 1'
FROM users u WHERE UPPER(u.email) = UPPER('duong@gmail.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = 'Tòa nhà Bitexco, số 2 Hải Triều, Bến Nghé, Quận 1'
);
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Nguyễn Văn Thịnh', '0903456789', 'Đà Nẵng', '456 Đường Bạch Đằng, Phường Bình Hiên, Quận Hải Châu'
FROM users u WHERE UPPER(u.email) = UPPER('thinh@gmail.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = '456 Đường Bạch Đằng, Phường Bình Hiên, Quận Hải Châu'
);
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Nhân Viên Demo', '0904567890', 'Hà Nội', 'Số 88 Cầu Giấy, Phường Quan Hoa, Quận Cầu Giấy'
FROM users u WHERE UPPER(u.email) = UPPER('staff@gmail.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = 'Số 88 Cầu Giấy, Phường Quan Hoa, Quận Cầu Giấy'
);
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Nguyễn Văn An', '0901000001', 'Hà Nội', '78 Đường Láng, Ngã Tư Sở, Đống Đa'
FROM users u WHERE UPPER(u.email) = UPPER('nguyenvanan@example.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = '78 Đường Láng, Ngã Tư Sở, Đống Đa'
);
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Trần Thị Bích', '0901000002', 'TP. Hồ Chí Minh', '24 Lê Văn Sỹ, Phường 14, Quận 3'
FROM users u WHERE UPPER(u.email) = UPPER('tranthibich@example.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = '24 Lê Văn Sỹ, Phường 14, Quận 3'
);
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Lê Hoàng Nam', '0901000003', 'Hải Phòng', '15 Lạch Tray, Quận Ngô Quyền'
FROM users u WHERE UPPER(u.email) = UPPER('lehoangnam@example.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = '15 Lạch Tray, Quận Ngô Quyền'
);
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Phạm Minh Đức', '0901000004', 'Cần Thơ', '99 Đường 30 Tháng 4, Quận Ninh Kiều'
FROM users u WHERE UPPER(u.email) = UPPER('phamminhduc@example.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = '99 Đường 30 Tháng 4, Quận Ninh Kiều'
);
INSERT INTO addresses (user_id, recipient_name, phone, province, address_line)
SELECT u.user_id, 'Vũ Thị Hương', '0901000005', 'Đà Nẵng', '12 Nguyễn Văn Linh, Quận Hải Châu'
FROM users u WHERE UPPER(u.email) = UPPER('vuthihuong@example.com')
AND NOT EXISTS (
    SELECT 1 FROM addresses addr 
    WHERE addr.user_id = u.user_id AND addr.address_line = '12 Nguyễn Văn Linh, Quận Hải Châu'
);

-- ------------------------------------------------------------------------------
-- 9. CARTS & CART ITEMS
-- ------------------------------------------------------------------------------
INSERT INTO carts (user_id, created_at, updated_at)
SELECT u.user_id, NOW(), NOW()
FROM users u
WHERE NOT EXISTS (SELECT 1 FROM carts c WHERE c.user_id = u.user_id);
INSERT INTO cart_items (cart_id, product_id, quantity, created_at)
SELECT c.cart_id, p.id, 2, NOW()
FROM carts c
JOIN users u ON c.user_id = u.user_id
JOIN products p ON p.name = 'Áo Thun Trơn Basic Cotton Compact'
WHERE UPPER(u.email) = 'DUONG@GMAIL.COM'
AND NOT EXISTS (SELECT 1 FROM cart_items ci WHERE ci.cart_id = c.cart_id AND ci.product_id = p.id);
INSERT INTO cart_items (cart_id, product_id, quantity, created_at)
SELECT c.cart_id, p.id, 1, NOW()
FROM carts c
JOIN users u ON c.user_id = u.user_id
JOIN products p ON p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều'
WHERE UPPER(u.email) = 'DUONG@GMAIL.COM'
AND NOT EXISTS (SELECT 1 FROM cart_items ci WHERE ci.cart_id = c.cart_id AND ci.product_id = p.id);
INSERT INTO cart_items (cart_id, product_id, quantity, created_at)
SELECT c.cart_id, p.id, 1, NOW()
FROM carts c
JOIN users u ON c.user_id = u.user_id
JOIN products p ON p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn'
WHERE UPPER(u.email) = 'THINH@GMAIL.COM'
AND NOT EXISTS (SELECT 1 FROM cart_items ci WHERE ci.cart_id = c.cart_id AND ci.product_id = p.id);

-- ------------------------------------------------------------------------------
-- 10. WISHLISTS
-- ------------------------------------------------------------------------------
INSERT INTO wishlists (user_id, product_id, created_at)
SELECT u.user_id, p.id, NOW()
FROM users u, products p
WHERE UPPER(u.email) = UPPER('duong@gmail.com') AND p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước'
AND NOT EXISTS (
    SELECT 1 FROM wishlists wl 
    WHERE wl.user_id = u.user_id AND wl.product_id = p.id
);
INSERT INTO wishlists (user_id, product_id, created_at)
SELECT u.user_id, p.id, NOW()
FROM users u, products p
WHERE UPPER(u.email) = UPPER('duong@gmail.com') AND p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (
    SELECT 1 FROM wishlists wl 
    WHERE wl.user_id = u.user_id AND wl.product_id = p.id
);
INSERT INTO wishlists (user_id, product_id, created_at)
SELECT u.user_id, p.id, NOW()
FROM users u, products p
WHERE UPPER(u.email) = UPPER('thinh@gmail.com') AND p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở'
AND NOT EXISTS (
    SELECT 1 FROM wishlists wl 
    WHERE wl.user_id = u.user_id AND wl.product_id = p.id
);
INSERT INTO wishlists (user_id, product_id, created_at)
SELECT u.user_id, p.id, NOW()
FROM users u, products p
WHERE UPPER(u.email) = UPPER('tranthibich@example.com') AND p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc'
AND NOT EXISTS (
    SELECT 1 FROM wishlists wl 
    WHERE wl.user_id = u.user_id AND wl.product_id = p.id
);
INSERT INTO wishlists (user_id, product_id, created_at)
SELECT u.user_id, p.id, NOW()
FROM users u, products p
WHERE UPPER(u.email) = UPPER('tranthibich@example.com') AND p.name = 'Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch'
AND NOT EXISTS (
    SELECT 1 FROM wishlists wl 
    WHERE wl.user_id = u.user_id AND wl.product_id = p.id
);
INSERT INTO wishlists (user_id, product_id, created_at)
SELECT u.user_id, p.id, NOW()
FROM users u, products p
WHERE UPPER(u.email) = UPPER('vuthihuong@example.com') AND p.name = 'Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại'
AND NOT EXISTS (
    SELECT 1 FROM wishlists wl 
    WHERE wl.user_id = u.user_id AND wl.product_id = p.id
);

-- ------------------------------------------------------------------------------
-- 11. COUPONS, COUPON_CATEGORIES, COUPON_PRODUCTS
-- ------------------------------------------------------------------------------
INSERT INTO coupons (code, name, discount_type, discount_value, apply_scope, min_order_amount, max_discount, start_at, end_at, status)
SELECT 'WELCOME10', 'Giảm 10% cho khách hàng mới', 'PERCENT', 10, 'ALL', 200000, 50000, DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL 90 DAY), 1
WHERE NOT EXISTS (SELECT 1 FROM coupons WHERE code IN ('WELCOME10', 'WELCOM10'));
INSERT INTO coupons (code, name, discount_type, discount_value, apply_scope, min_order_amount, max_discount, start_at, end_at, status)
SELECT 'FREESHIP30', 'Giảm 10% đơn hàng từ 300.000đ', 'PERCENT', 10, 'ALL', 300000, 30000, DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL 90 DAY), 1
WHERE NOT EXISTS (SELECT 1 FROM coupons WHERE code = 'FREESHIP30');
INSERT INTO coupons (code, name, discount_type, discount_value, apply_scope, min_order_amount, max_discount, start_at, end_at, status)
SELECT 'AOTHUN20K', 'Giảm 8% cho danh mục Áo thun', 'PERCENT', 8, 'CATEGORY', 250000, 20000, DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL 90 DAY), 1
WHERE NOT EXISTS (SELECT 1 FROM coupons WHERE code = 'AOTHUN20K');
INSERT INTO coupon_categories (coupon_id, category_id)
SELECT c.coupon_id, cat.id
FROM coupons c, categories cat
WHERE c.code = 'AOTHUN20K' AND cat.name = 'Áo thun'
AND NOT EXISTS (
    SELECT 1 FROM coupon_categories cc 
    WHERE cc.coupon_id = c.coupon_id AND cc.category_id = cat.id
);
INSERT INTO coupons (code, name, discount_type, discount_value, apply_scope, min_order_amount, max_discount, start_at, end_at, status)
SELECT 'VIP100K', 'Giảm 10% cho đơn hàng từ 1 triệu', 'PERCENT', 10, 'ALL', 1000000, 100000, DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL 90 DAY), 1
WHERE NOT EXISTS (SELECT 1 FROM coupons WHERE code = 'VIP100K');
INSERT INTO coupons (code, name, discount_type, discount_value, apply_scope, min_order_amount, max_discount, start_at, end_at, status)
SELECT 'COOLMATESUMMER', 'Giảm 15% cho sản phẩm mùa hè', 'PERCENT', 15, 'PRODUCT', 250000, 80000, DATE_SUB(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL 90 DAY), 1
WHERE NOT EXISTS (SELECT 1 FROM coupons WHERE code = 'COOLMATESUMMER');
INSERT INTO coupon_products (coupon_id, product_id)
SELECT c.coupon_id, p.id
FROM coupons c, products p
WHERE c.code = 'COOLMATESUMMER' AND p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (
    SELECT 1 FROM coupon_products cp2 
    WHERE cp2.coupon_id = c.coupon_id AND cp2.product_id = p.id
);

-- ------------------------------------------------------------------------------
-- 12. ORDERS, ORDER_ITEMS, PAYMENTS, SHIPMENTS, REVIEWS
-- ------------------------------------------------------------------------------

-- Order ORD-2026-001
INSERT INTO orders (order_code, user_id, coupon_id, recipient_name, recipient_phone, shipping_address, subtotal, discount_amount, shipping_fee, total_amount, status, note, created_at, updated_at)
SELECT 'ORD-2026-001', u.user_id, c.coupon_id, 'Trần Minh Dương', '0902345678', '123 Đường Nguyễn Huệ, Quận 1, TP.HCM', 840000, 50000, 30000, 820000, 'DELIVERED', 'Giao giờ hành chính', DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()
FROM users u, coupons c
WHERE UPPER(u.email) = UPPER('duong@gmail.com') AND c.code = 'WELCOME10'
AND NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'ORD-2026-001');
INSERT INTO order_items (order_id, product_id, product_name, sku, size_name, quantity, unit_price, line_total)
SELECT o.order_id, p.id, 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn', 'PRD011-M-BLK', 'M', 1, 450000, 450000
FROM orders o, products p
WHERE o.order_code = 'ORD-2026-001' AND p.name = 'Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn'
AND NOT EXISTS (
    SELECT 1 FROM order_items oi 
    WHERE oi.order_id = o.order_id AND oi.product_id = p.id AND oi.sku = 'PRD011-M-BLK'
);
INSERT INTO order_items (order_id, product_id, product_name, sku, size_name, quantity, unit_price, line_total)
SELECT o.order_id, p.id, 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở', 'PRD061-30-BLK', '30', 1, 390000, 390000
FROM orders o, products p
WHERE o.order_code = 'ORD-2026-001' AND p.name = 'Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở'
AND NOT EXISTS (
    SELECT 1 FROM order_items oi 
    WHERE oi.order_id = o.order_id AND oi.product_id = p.id AND oi.sku = 'PRD061-30-BLK'
);
INSERT INTO payments (order_id, method, amount, status, transaction_code, paid_at, created_at)
SELECT o.order_id, 'VNPAY', 820000, 'SUCCESS', 'VNP20260401001', NOW(), NOW()
FROM orders o WHERE o.order_code = 'ORD-2026-001'
AND NOT EXISTS (SELECT 1 FROM payments pm WHERE pm.order_id = o.order_id);
INSERT INTO shipments (order_id, carrier, tracking_code, status, shipped_at, delivered_at)
SELECT o.order_id, 'Giao Hàng Nhanh', 'GHN88291024VN', 'DELIVERED', DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()
FROM orders o WHERE o.order_code = 'ORD-2026-001'
AND NOT EXISTS (SELECT 1 FROM shipments sh WHERE sh.order_id = o.order_id);
INSERT INTO reviews (order_item_id, rating, content, status, created_at)
SELECT oi.order_item_id, 5, 'Chất vải sợi tre rất mát và nhẹ, quần kaki vừa vặn không cần bóp ống. Rất ưng ý!', 'APPROVED', NOW()
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_code = 'ORD-2026-001' AND oi.sku = 'PRD011-M-BLK'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.order_item_id = oi.order_item_id);
INSERT INTO reviews_image (review_id, image_url, sort_order, created_at)
SELECT r.review_id, 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500', 1, NOW()
FROM reviews r
JOIN order_items oi ON r.order_item_id = oi.order_item_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_code = 'ORD-2026-001'
AND NOT EXISTS (SELECT 1 FROM reviews_image ri WHERE ri.review_id = r.review_id);

-- Order ORD-2026-002
INSERT INTO orders (order_code, user_id, coupon_id, recipient_name, recipient_phone, shipping_address, subtotal, discount_amount, shipping_fee, total_amount, status, note, created_at, updated_at)
SELECT 'ORD-2026-002', u.user_id, c.coupon_id, 'Nguyễn Văn Thịnh', '0903456789', '456 Đường Bạch Đằng, Quận Hải Châu, Đà Nẵng', 598000, 30000, 30000, 598000, 'DELIVERED', 'Gọi trước khi giao', DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()
FROM users u, coupons c
WHERE UPPER(u.email) = UPPER('thinh@gmail.com') AND c.code = 'FREESHIP30'
AND NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'ORD-2026-002');
INSERT INTO order_items (order_id, product_id, product_name, sku, size_name, quantity, unit_price, line_total)
SELECT o.order_id, p.id, 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí', 'PRD021-L-BLK', 'L', 2, 299000, 598000
FROM orders o, products p
WHERE o.order_code = 'ORD-2026-002' AND p.name = 'Áo Polo Nam Cafe Khử Mùi Thoáng Khí'
AND NOT EXISTS (
    SELECT 1 FROM order_items oi 
    WHERE oi.order_id = o.order_id AND oi.product_id = p.id AND oi.sku = 'PRD021-L-BLK'
);
INSERT INTO payments (order_id, method, amount, status, transaction_code, paid_at, created_at)
SELECT o.order_id, 'COD', 598000, 'SUCCESS', 'COD20260402002', NOW(), NOW()
FROM orders o WHERE o.order_code = 'ORD-2026-002'
AND NOT EXISTS (SELECT 1 FROM payments pm WHERE pm.order_id = o.order_id);
INSERT INTO shipments (order_id, carrier, tracking_code, status, shipped_at, delivered_at)
SELECT o.order_id, 'Viettel Post', 'VT281920199VN', 'DELIVERED', DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()
FROM orders o WHERE o.order_code = 'ORD-2026-002'
AND NOT EXISTS (SELECT 1 FROM shipments sh WHERE sh.order_id = o.order_id);
INSERT INTO reviews (order_item_id, rating, content, status, created_at)
SELECT oi.order_item_id, 5, 'Polo mặc rất thoáng, giặt mau khô và form áo cực kỳ đứng. Đáng tiền!', 'APPROVED', NOW()
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_code = 'ORD-2026-002' AND oi.sku = 'PRD021-L-BLK'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.order_item_id = oi.order_item_id);

-- Order ORD-2026-003
INSERT INTO orders (order_code, user_id, recipient_name, recipient_phone, shipping_address, subtotal, discount_amount, shipping_fee, total_amount, status, note, created_at, updated_at)
SELECT 'ORD-2026-003', u.user_id, 'Trần Thị Bích', '0901000002', '24 Lê Văn Sỹ, Phường 14, Quận 3, TP.HCM', 590000, 0, 30000, 620000, 'SHIPPING', 'Để ở quầy lễ tân chung cư', DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()
FROM users u
WHERE UPPER(u.email) = UPPER('tranthibich@example.com')
AND NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'ORD-2026-003');
INSERT INTO order_items (order_id, product_id, product_name, sku, size_name, quantity, unit_price, line_total)
SELECT o.order_id, p.id, 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc', 'PRD092-M-BLK', 'M', 1, 590000, 590000
FROM orders o, products p
WHERE o.order_code = 'ORD-2026-003' AND p.name = 'Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc'
AND NOT EXISTS (
    SELECT 1 FROM order_items oi 
    WHERE oi.order_id = o.order_id AND oi.product_id = p.id AND oi.sku = 'PRD092-M-BLK'
);
INSERT INTO payments (order_id, method, amount, status, transaction_code, paid_at, created_at)
SELECT o.order_id, 'VNPAY', 620000, 'SUCCESS', 'VNP20260403003', NOW(), NOW()
FROM orders o WHERE o.order_code = 'ORD-2026-003'
AND NOT EXISTS (SELECT 1 FROM payments pm WHERE pm.order_id = o.order_id);
INSERT INTO shipments (order_id, carrier, tracking_code, status, shipped_at, delivered_at)
SELECT o.order_id, 'Giao Hàng Tiết Kiệm', 'GHTK9928172VN', 'SHIPPING', DATE_SUB(NOW(), INTERVAL 1 DAY), NULL
FROM orders o WHERE o.order_code = 'ORD-2026-003'
AND NOT EXISTS (SELECT 1 FROM shipments sh WHERE sh.order_id = o.order_id);

-- Order ORD-2026-004
INSERT INTO orders (order_code, user_id, recipient_name, recipient_phone, shipping_address, subtotal, discount_amount, shipping_fee, total_amount, status, note, created_at, updated_at)
SELECT 'ORD-2026-004', u.user_id, 'Nguyễn Văn An', '0901000001', '78 Đường Láng, Ngã Tư Sở, Đống Đa, Hà Nội', 420000, 0, 30000, 450000, 'CONFIRMED', 'Giao hàng buổi chiều', DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()
FROM users u
WHERE UPPER(u.email) = UPPER('nguyenvanan@example.com')
AND NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'ORD-2026-004');
INSERT INTO order_items (order_id, product_id, product_name, sku, size_name, quantity, unit_price, line_total)
SELECT o.order_id, p.id, 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước', 'PRD031-L-BLK', 'L', 1, 420000, 420000
FROM orders o, products p
WHERE o.order_code = 'ORD-2026-004' AND p.name = 'Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước'
AND NOT EXISTS (
    SELECT 1 FROM order_items oi 
    WHERE oi.order_id = o.order_id AND oi.product_id = p.id AND oi.sku = 'PRD031-L-BLK'
);
INSERT INTO payments (order_id, method, amount, status, transaction_code, paid_at, created_at)
SELECT o.order_id, 'COD', 450000, 'PENDING', 'COD20260404004', NOW(), NOW()
FROM orders o WHERE o.order_code = 'ORD-2026-004'
AND NOT EXISTS (SELECT 1 FROM payments pm WHERE pm.order_id = o.order_id);

-- Order ORD-2026-005
INSERT INTO orders (order_code, user_id, recipient_name, recipient_phone, shipping_address, subtotal, discount_amount, shipping_fee, total_amount, status, note, created_at, updated_at)
SELECT 'ORD-2026-005', u.user_id, 'Lê Hoàng Nam', '0901000003', '15 Lạch Tray, Quận Ngô Quyền, Hải Phòng', 390000, 0, 30000, 420000, 'PENDING', '', DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()
FROM users u
WHERE UPPER(u.email) = UPPER('lehoangnam@example.com')
AND NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'ORD-2026-005');
INSERT INTO order_items (order_id, product_id, product_name, sku, size_name, quantity, unit_price, line_total)
SELECT o.order_id, p.id, 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều', 'PRD051-31-BLK', '31', 1, 390000, 390000
FROM orders o, products p
WHERE o.order_code = 'ORD-2026-005' AND p.name = 'Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều'
AND NOT EXISTS (
    SELECT 1 FROM order_items oi 
    WHERE oi.order_id = o.order_id AND oi.product_id = p.id AND oi.sku = 'PRD051-31-BLK'
);
INSERT INTO payments (order_id, method, amount, status, transaction_code, paid_at, created_at)
SELECT o.order_id, 'COD', 420000, 'PENDING', 'COD20260405005', NOW(), NOW()
FROM orders o WHERE o.order_code = 'ORD-2026-005'
AND NOT EXISTS (SELECT 1 FROM payments pm WHERE pm.order_id = o.order_id);

-- Order ORD-2026-006
INSERT INTO orders (order_code, user_id, recipient_name, recipient_phone, shipping_address, subtotal, discount_amount, shipping_fee, total_amount, status, note, created_at, updated_at)
SELECT 'ORD-2026-006', u.user_id, 'Phạm Minh Đức', '0901000004', '99 Đường 30 Tháng 4, Cần Thơ', 480000, 0, 30000, 510000, 'CANCELLED', 'Khách hàng đổi ý muốn đổi size', DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()
FROM users u
WHERE UPPER(u.email) = UPPER('phamminhduc@example.com')
AND NOT EXISTS (SELECT 1 FROM orders WHERE order_code = 'ORD-2026-006');
INSERT INTO order_items (order_id, product_id, product_name, sku, size_name, quantity, unit_price, line_total)
SELECT o.order_id, p.id, 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu', 'PRD044-XL-BLK', 'XL', 1, 480000, 480000
FROM orders o, products p
WHERE o.order_code = 'ORD-2026-006' AND p.name = 'Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu'
AND NOT EXISTS (
    SELECT 1 FROM order_items oi 
    WHERE oi.order_id = o.order_id AND oi.product_id = p.id AND oi.sku = 'PRD044-XL-BLK'
);
INSERT INTO payments (order_id, method, amount, status, transaction_code, paid_at, created_at)
SELECT o.order_id, 'COD', 510000, 'FAILED', 'COD20260406006', NOW(), NOW()
FROM orders o WHERE o.order_code = 'ORD-2026-006'
AND NOT EXISTS (SELECT 1 FROM payments pm WHERE pm.order_id = o.order_id);

-- ------------------------------------------------------------------------------
-- 13. NOTIFICATIONS
-- ------------------------------------------------------------------------------
INSERT INTO notifications (user_id, title, content, link_url, is_read, created_at)
SELECT u.user_id, 'Chào mừng thành viên mới!', 'Chào mừng bạn đến với hệ thống Clothing Store. Nhập mã WELCOME10 để nhận ưu đãi 10% cho đơn đầu tiên.', '/coupons', 0, NOW()
FROM users u WHERE UPPER(u.email) = UPPER('duong@gmail.com')
AND NOT EXISTS (
    SELECT 1 FROM notifications notif 
    WHERE notif.user_id = u.user_id AND notif.title = 'Chào mừng thành viên mới!'
);
INSERT INTO notifications (user_id, title, content, link_url, is_read, created_at)
SELECT u.user_id, 'Đơn hàng ORD-2026-001 đã giao thành công', 'Kiện hàng của bạn đã được giao thành công. Đừng quên đánh giá sản phẩm để tích lũy điểm thưởng nhé!', '/orders/ORD-2026-001', 0, NOW()
FROM users u WHERE UPPER(u.email) = UPPER('duong@gmail.com')
AND NOT EXISTS (
    SELECT 1 FROM notifications notif 
    WHERE notif.user_id = u.user_id AND notif.title = 'Đơn hàng ORD-2026-001 đã giao thành công'
);
INSERT INTO notifications (user_id, title, content, link_url, is_read, created_at)
SELECT u.user_id, 'Đơn hàng ORD-2026-002 đã giao thành công', 'Cảm ơn bạn đã tin tưởng mua sắm tại Clothing Store.', '/orders/ORD-2026-002', 0, NOW()
FROM users u WHERE UPPER(u.email) = UPPER('thinh@gmail.com')
AND NOT EXISTS (
    SELECT 1 FROM notifications notif 
    WHERE notif.user_id = u.user_id AND notif.title = 'Đơn hàng ORD-2026-002 đã giao thành công'
);
INSERT INTO notifications (user_id, title, content, link_url, is_read, created_at)
SELECT u.user_id, 'Đơn hàng ORD-2026-003 đang trên đường giao', 'Đơn vị vận chuyển GHTK đang giao kiện hàng đến địa chỉ của bạn.', '/orders/ORD-2026-003', 0, NOW()
FROM users u WHERE UPPER(u.email) = UPPER('tranthibich@example.com')
AND NOT EXISTS (
    SELECT 1 FROM notifications notif 
    WHERE notif.user_id = u.user_id AND notif.title = 'Đơn hàng ORD-2026-003 đang trên đường giao'
);

-- ------------------------------------------------------------------------------
-- 14. POST CATEGORIES & POSTS (Tin tức & Blog thời trang)
-- ------------------------------------------------------------------------------
INSERT INTO post_categories (category_name, slug, status)
SELECT 'Xu hướng thời trang', 'xu-huong-thoi-trang', 1
WHERE NOT EXISTS (SELECT 1 FROM post_categories WHERE slug = 'xu-huong-thoi-trang');
INSERT INTO post_categories (category_name, slug, status)
SELECT 'Bí quyết phối đồ', 'bi-quyet-phoi-do', 1
WHERE NOT EXISTS (SELECT 1 FROM post_categories WHERE slug = 'bi-quyet-phoi-do');
INSERT INTO post_categories (category_name, slug, status)
SELECT 'Bảo quản trang phục', 'bao-quan-trang-phuc', 1
WHERE NOT EXISTS (SELECT 1 FROM post_categories WHERE slug = 'bao-quan-trang-phuc');
INSERT INTO posts (title, slug, thumbnail_url, content, status, published_at, created_at, post_category_id, author_id)
SELECT 'Top 5 Cách Phối Đồ Với Áo Sơ Mi Nam Đầy Lịch Lãm Cho Mùa Hè', 'top-5-cach-phoi-do-voi-ao-so-mi-nam', 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=600', 'Áo sơ mi nam luôn là item kinh điển trong tủ đồ của phái mạnh. Khi kết hợp cùng quần âu hoặc quần kaki chinos dáng slim, bạn sẽ có ngay set đồ công sở chỉn chu và tôn dáng...', 'PUBLISHED', NOW(), NOW(), pc.post_category_id, u.user_id
FROM post_categories pc, users u
WHERE pc.slug = 'bi-quyet-phoi-do' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (SELECT 1 FROM posts WHERE slug = 'top-5-cach-phoi-do-voi-ao-so-mi-nam');
INSERT INTO posts (title, slug, thumbnail_url, content, status, published_at, created_at, post_category_id, author_id)
SELECT 'Xu Hướng Thời Trang Streetwear Bùng Nổ Trong Năm 2026', 'xu-huong-thoi-trang-streetwear-2026', 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=600', 'Phong cách oversize, chất liệu nỉ chân cua bền bỉ cùng họa tiết typography độc đáo đang tiếp tục chiếm lĩnh sàn diễn thời trang trẻ...', 'PUBLISHED', NOW(), NOW(), pc.post_category_id, u.user_id
FROM post_categories pc, users u
WHERE pc.slug = 'xu-huong-thoi-trang' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (SELECT 1 FROM posts WHERE slug = 'xu-huong-thoi-trang-streetwear-2026');
INSERT INTO posts (title, slug, thumbnail_url, content, status, published_at, created_at, post_category_id, author_id)
SELECT 'Bí Quyết Giặt Và Bảo Quản Quần Jeans Không Bị Phai Màu Sau Nhiều Năm', 'bi-quyet-giat-bao-quan-quan-jeans', 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=600', 'Để giữ màu quần jeans luôn như mới, hãy lộn mặt trái khi giặt, sử dụng nước lạnh và hạn chế tối đa việc sấy ở nhiệt độ cao...', 'PUBLISHED', NOW(), NOW(), pc.post_category_id, u.user_id
FROM post_categories pc, users u
WHERE pc.slug = 'bao-quan-trang-phuc' AND UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (SELECT 1 FROM posts WHERE slug = 'bi-quyet-giat-bao-quan-quan-jeans');

-- ------------------------------------------------------------------------------
-- 15. PRICE LISTS, PRICE LIST ITEMS, PRICE HISTORY
-- ------------------------------------------------------------------------------
INSERT INTO price_lists (name, description, status, created_at, created_by)
SELECT 'Bảng giá Xuân Hè 2026', 'Bảng giá niêm yết chính thức áp dụng từ quý 1/2026', 1, NOW(), u.user_id
FROM users u WHERE UPPER(u.email) = 'ADMIN@GMAIL.COM'
AND NOT EXISTS (SELECT 1 FROM price_lists WHERE name = 'Bảng giá Xuân Hè 2026');
INSERT INTO price_list_items (price_list_id, product_id, price, updated_at)
SELECT pl.price_list_id, p.id, p.price, NOW()
FROM price_lists pl, products p
WHERE pl.name = 'Bảng giá Xuân Hè 2026' AND p.name = 'Áo Thun Trơn Basic Cotton Compact'
AND NOT EXISTS (
    SELECT 1 FROM price_list_items pli 
    WHERE pli.price_list_id = pl.price_list_id AND pli.product_id = p.id
);
INSERT INTO price_history (price_item_id, old_price, new_price, reason, changed_at, changed_by)
SELECT pli.price_item_id, 199000.00, 189000.00, 'Khuyến mãi khai trương mùa mới', NOW(), u.user_id
FROM price_list_items pli
JOIN price_lists pl ON pli.price_list_id = pl.price_list_id
JOIN products p ON pli.product_id = p.id
JOIN users u ON UPPER(u.email) = 'ADMIN@GMAIL.COM'
WHERE pl.name = 'Bảng giá Xuân Hè 2026' AND p.name = 'Áo Thun Trơn Basic Cotton Compact'
AND NOT EXISTS (SELECT 1 FROM price_history ph WHERE ph.price_item_id = pli.price_item_id);

-- ------------------------------------------------------------------------------
-- 16. SYSTEM SETTINGS
-- ------------------------------------------------------------------------------
INSERT INTO system_settings (setting_key, setting_value, description, updated_at)
SELECT 'store_name', 'Clothing Store Vietnam', 'Tên hiển thị của cửa hàng', NOW()
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE setting_key = 'store_name');
INSERT INTO system_settings (setting_key, setting_value, description, updated_at)
SELECT 'store_hotline', '1900 8888', 'Số điện thoại đường dây nóng hỗ trợ', NOW()
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE setting_key = 'store_hotline');
INSERT INTO system_settings (setting_key, setting_value, description, updated_at)
SELECT 'store_email', 'hotro@clothingstore.com', 'Email hỗ trợ chăm sóc khách hàng', NOW()
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE setting_key = 'store_email');
INSERT INTO system_settings (setting_key, setting_value, description, updated_at)
SELECT 'store_address', 'Số 12 phố Tràng Tiền, Hoàn Kiếm, Hà Nội', 'Địa chỉ trụ sở chính', NOW()
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE setting_key = 'store_address');
INSERT INTO system_settings (setting_key, setting_value, description, updated_at)
SELECT 'free_shipping_threshold', '500000', 'Giá trị đơn hàng tối thiểu để được miễn phí vận chuyển', NOW()
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE setting_key = 'free_shipping_threshold');
INSERT INTO system_settings (setting_key, setting_value, description, updated_at)
SELECT 'shipping_fee', '30000', 'Phí vận chuyển cho đơn dưới ngưỡng miễn phí', NOW()
WHERE NOT EXISTS (SELECT 1 FROM system_settings WHERE setting_key = 'shipping_fee');
-- ==============================================================================
-- Gắn nhãn hot cho một số sản phẩm mẫu để hiển thị ở trang chủ.
-- Chỉ bổ sung nhãn cho sản phẩm chưa có tag, không ghi đè dữ liệu tùy chỉnh.
UPDATE products
SET tag = 'hot'
WHERE name IN (
    'Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc',
    'Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung',
    'Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm',
    'Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ',
    'Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng',
    'Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng',
    'Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn',
    'Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp'
)
AND (tag IS NULL OR TRIM(tag) = '')
AND (is_deleted = 0 OR is_deleted IS NULL);

-- ==============================================================================
-- HOÀN TẤT SEEDER: 100 SẢN PHẨM THỜI TRANG ĐÃ SẴN SÀNG TRONG HỆ THỐNG!
-- ==============================================================================


-- CATALOG SEED SECTION
-- Idempotent supplemental catalog seeds; safe to execute on every application start.

INSERT INTO categories (name, description)
SELECT seeds.name, seeds.description
FROM (
    SELECT 'Áo ba lỗ' AS name, 'Áo sát nách nhẹ mát cho luyện tập và ngày hè.' AS description
    UNION ALL SELECT 'Áo len', 'Áo len dệt kim giữ ấm với nhiều kiểu dáng thanh lịch.'
    UNION ALL SELECT 'Áo cardigan', 'Cardigan dễ phối lớp cho phong cách nhẹ nhàng.'
    UNION ALL SELECT 'Áo blazer', 'Blazer hiện đại phù hợp công sở và sự kiện.'
    UNION ALL SELECT 'Áo vest', 'Áo vest chỉn chu cho những dịp trang trọng.'
    UNION ALL SELECT 'Áo croptop', 'Croptop trẻ trung với nhiều phom dáng năng động.'
    UNION ALL SELECT 'Áo hai dây', 'Áo hai dây thoáng mát cho ngày hè và kỳ nghỉ.'
    UNION ALL SELECT 'Áo dài', 'Áo dài truyền thống với đường nét duyên dáng.'
    UNION ALL SELECT 'Áo chống nắng', 'Trang phục chống nắng nhẹ và tiện dụng hằng ngày.'
    UNION ALL SELECT 'Áo giữ nhiệt', 'Áo giữ nhiệt mỏng nhẹ cho thời tiết se lạnh.'
    UNION ALL SELECT 'Quần legging', 'Quần legging co giãn phù hợp vận động và mặc thường ngày.'
    UNION ALL SELECT 'Quần jogger', 'Jogger thoải mái với phong cách thể thao hiện đại.'
    UNION ALL SELECT 'Quần cargo', 'Quần cargo nhiều túi mang nét cá tính đường phố.'
    UNION ALL SELECT 'Quần ống rộng', 'Quần ống rộng thoải mái, dễ phối đồ.'
    UNION ALL SELECT 'Quần culottes', 'Quần culottes thanh lịch với phom rộng thoáng mát.'
    UNION ALL SELECT 'Quần yếm', 'Quần yếm trẻ trung dành cho phong cách năng động.'
    UNION ALL SELECT 'Chân váy chữ A', 'Chân váy chữ A dễ mặc, phù hợp nhiều hoàn cảnh.'
    UNION ALL SELECT 'Chân váy midi', 'Chân váy midi duyên dáng cho phong cách thanh lịch.'
    UNION ALL SELECT 'Chân váy maxi', 'Chân váy maxi mềm mại cho ngày hè và chuyến đi.'
    UNION ALL SELECT 'Đầm dự tiệc', 'Đầm dự tiệc nổi bật với phom dáng tinh tế.'
    UNION ALL SELECT 'Đầm maxi', 'Đầm maxi bay bổng dành cho kỳ nghỉ và dạo phố.'
    UNION ALL SELECT 'Đồ bộ mặc nhà', 'Đồ bộ mặc nhà mềm mại, thoải mái.'
    UNION ALL SELECT 'Đồ ngủ', 'Trang phục ngủ nhẹ nhàng với chất liệu êm dịu.'
    UNION ALL SELECT 'Đồ lót', 'Đồ lót cơ bản chú trọng sự thoải mái.'
    UNION ALL SELECT 'Đồ bơi', 'Trang phục bơi tiện dụng cho kỳ nghỉ biển.'
    UNION ALL SELECT 'Đồ thể thao', 'Trang phục thể thao co giãn cho nhiều hoạt động.'
    UNION ALL SELECT 'Đồ trẻ em', 'Trang phục trẻ em mềm mại và tiện dụng.'
    UNION ALL SELECT 'Áo mưa', 'Áo mưa gọn nhẹ cho những ngày thời tiết thất thường.'
    UNION ALL SELECT 'Phụ kiện thời trang', 'Phụ kiện hoàn thiện phong cách hằng ngày.'
    UNION ALL SELECT 'Tất & Vớ', 'Tất và vớ cơ bản, êm chân khi sử dụng.'
) AS seeds
WHERE NOT EXISTS (
    SELECT 1 FROM categories existing WHERE existing.name = seeds.name
);

INSERT INTO brands (brand_name, logo_url, description, status)
SELECT seeds.brand_name, NULL, seeds.description, 1
FROM (
    SELECT 'Northline' AS brand_name, 'Phong cách tối giản lấy cảm hứng từ nhịp sống đô thị.' AS description
    UNION ALL SELECT 'Mộc Studio', 'Thiết kế gần gũi, ưu tiên chất liệu và phom dáng tự nhiên.'
    UNION ALL SELECT 'Lam Atelier', 'Trang phục thanh lịch với điểm nhấn tinh tế.'
    UNION ALL SELECT 'Vân Maison', 'Thời trang nữ nhẹ nhàng dành cho nhiều dịp.'
    UNION ALL SELECT 'Urban Loom', 'Trang phục đường phố năng động cho thế hệ trẻ.'
    UNION ALL SELECT 'Serein', 'Phong cách tối giản, thư thái và dễ ứng dụng.'
    UNION ALL SELECT 'Forme Việt', 'Thiết kế hiện đại chú trọng phom dáng.'
    UNION ALL SELECT 'Nắng Studio', 'Trang phục mùa hè tươi sáng và thoải mái.'
    UNION ALL SELECT 'Hẻm Boutique', 'Phong cách trẻ trung mang hơi thở thành thị.'
    UNION ALL SELECT 'An Nhiên Wear', 'Trang phục thường ngày nhẹ nhàng, tiện dụng.'
    UNION ALL SELECT 'Khuê Fashion', 'Thiết kế nữ tính với màu sắc trang nhã.'
    UNION ALL SELECT 'Bản Phối', 'Các thiết kế cơ bản dễ kết hợp trong tủ đồ.'
    UNION ALL SELECT 'Dệt Mây', 'Trang phục mềm mại với cảm hứng từ chất liệu tự nhiên.'
    UNION ALL SELECT 'Mono District', 'Phong cách đơn sắc dành cho tủ đồ hiện đại.'
    UNION ALL SELECT 'Thềm Nhà', 'Trang phục thoải mái cho sinh hoạt mỗi ngày.'
    UNION ALL SELECT 'Lụa Mộc', 'Thiết kế chú trọng bề mặt vải và cảm giác khi mặc.'
    UNION ALL SELECT 'Tầng Mây', 'Thời trang trẻ trung với phom dáng phóng khoáng.'
    UNION ALL SELECT 'Cỏ May', 'Trang phục thanh lịch lấy cảm hứng từ thiên nhiên.'
    UNION ALL SELECT 'Phố Nhỏ', 'Phong cách dạo phố linh hoạt và gần gũi.'
    UNION ALL SELECT 'Hạ Lam', 'Bộ sưu tập mùa hè nhẹ nhàng và tươi mới.'
    UNION ALL SELECT 'Everyday Form', 'Trang phục cơ bản cho nhịp sống hằng ngày.'
    UNION ALL SELECT 'Màu Nâu', 'Các thiết kế trầm ấm và dễ phối lớp.'
    UNION ALL SELECT 'Lá Studio', 'Phong cách tự nhiên với bảng màu dịu mắt.'
    UNION ALL SELECT 'Cedar & Co', 'Trang phục hiện đại với tinh thần bền vững.'
    UNION ALL SELECT 'Nếp Wear', 'Thiết kế chỉn chu, tiện dụng cho công việc và dạo phố.'
    UNION ALL SELECT 'Vạt Nắng', 'Trang phục nữ tươi sáng, phù hợp ngày thường.'
    UNION ALL SELECT 'Kén Studio', 'Thiết kế trẻ trung với chi tiết thủ công tinh gọn.'
    UNION ALL SELECT 'Chạm Clothing', 'Thời trang cá tính dành cho phong cách riêng.'
    UNION ALL SELECT 'Mây Trắng', 'Trang phục nhẹ nhàng với tông màu sáng.'
    UNION ALL SELECT 'Đường Kim', 'Thiết kế cơ bản chú trọng đường may gọn gàng.'
) AS seeds
WHERE NOT EXISTS (
    SELECT 1 FROM brands existing WHERE existing.brand_name = seeds.brand_name
);

INSERT INTO post_categories (category_name, slug, status)
SELECT seeds.category_name, seeds.slug, 1
FROM (
    SELECT 'Xu hướng thời trang' AS category_name, 'xu-huong-thoi-trang' AS slug
    UNION ALL SELECT 'Bí quyết phối đồ', 'bi-quyet-phoi-do'
    UNION ALL SELECT 'Bảo quản trang phục', 'bao-quan-trang-phuc'
) AS seeds
WHERE NOT EXISTS (
    SELECT 1 FROM post_categories existing WHERE existing.slug = seeds.slug
);

INSERT INTO posts (title, slug, thumbnail_url, content, status, published_at, created_at, post_category_id, author_id)
SELECT seeds.title, seeds.slug, seeds.thumbnail_url, seeds.content, 'PUBLISHED', NOW(), NOW(),
       categories.post_category_id, authors.user_id
FROM (
    SELECT 'Cách Phối Blazer Oversize Thanh Lịch Mà Không Bị Quá Khổ' AS title,
           'phoi-blazer-oversize-thanh-lich' AS slug,
           'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800' AS thumbnail_url,
           'Blazer oversize cân bằng tốt với áo trong gọn dáng và quần cạp cao. Hãy chọn một điểm nhấn màu sắc, giữ phụ kiện vừa phải và ưu tiên độ dài tay áo phù hợp để tổng thể trông chỉn chu.' AS content,
           'bi-quyet-phoi-do' AS category_slug
    UNION ALL SELECT 'Xây Dựng Tủ Đồ Capsule Với 10 Món Cơ Bản', 'tu-do-capsule-10-mon-co-ban',
           'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
           'Một tủ đồ capsule bắt đầu từ những món dễ kết hợp như áo sơ mi, áo thun trơn, quần tối màu và áo khoác cơ bản. Chọn bảng màu thống nhất giúp bạn tạo nhiều bộ trang phục mà không cần mua quá nhiều.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Vải Linen Có Gì Đặc Biệt Và Cách Mặc Đẹp Ngày Hè', 'vai-linen-va-cach-mac-dep-ngay-he',
           'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=800',
           'Linen thoáng khí và có bề mặt tự nhiên đặc trưng. Những nếp nhăn nhẹ là một phần vẻ đẹp của chất liệu; hãy phối cùng cotton hoặc phụ kiện đơn giản để tạo cảm giác thư thái.',
           'xu-huong-thoi-trang'
    UNION ALL SELECT 'Chọn Quần Jeans Theo Phom Dáng Và Nhu Cầu Sử Dụng', 'chon-quan-jeans-theo-phom-dang',
           'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800',
           'Quần jeans straight dễ mặc trong nhiều hoàn cảnh, còn dáng rộng tạo vẻ phóng khoáng. Khi thử đồ, hãy chú ý độ vừa ở eo, chiều dài gấu và cảm giác thoải mái khi ngồi hoặc di chuyển.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Phối Giày Với Trang Phục Sao Cho Cân Đối', 'phoi-giay-voi-trang-phuc-can-doi',
           'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800',
           'Giày nên hài hòa với độ trang trọng và tông màu của trang phục. Giày trắng tạo cảm giác thoải mái, trong khi giày da tối màu phù hợp hơn với bộ đồ công sở hoặc sự kiện.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Nghệ Thuật Phối Nhiều Lớp Cho Ngày Se Lạnh', 'nghe-thuat-phoi-do-nhieu-lop',
           'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=800',
           'Phối lớp hiệu quả dựa trên độ dày tăng dần từ trong ra ngoài. Kết hợp áo nền gọn nhẹ, lớp giữa giữ ấm và áo khoác ngoài vừa vặn để giữ sự linh hoạt khi thay đổi nhiệt độ.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Bảng Màu Trung Tính Dễ Ứng Dụng Trong Tủ Đồ', 'bang-mau-trung-tinh-de-ung-dung',
           'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?w=800',
           'Trắng, be, xám và xanh navy có thể kết hợp linh hoạt quanh năm. Thử phối các sắc độ cùng tông hoặc thêm một món phụ kiện nổi bật để tạo chiều sâu mà không làm bộ đồ rối mắt.',
           'xu-huong-thoi-trang'
    UNION ALL SELECT 'Streetwear Tối Giản: Ít Chi Tiết Vẫn Nổi Bật', 'streetwear-toi-gian-it-chi-tiet',
           'https://images.unsplash.com/photo-1523398002811-999ca8dec234?w=800',
           'Streetwear không nhất thiết cần nhiều họa tiết. Một chiếc áo phom rộng, quần vừa vặn và giày có điểm nhấn đã đủ tạo diện mạo cá tính; hãy giữ màu sắc có chủ đích.',
           'xu-huong-thoi-trang'
    UNION ALL SELECT 'Gợi Ý Trang Phục Công Sở Linh Hoạt Từ Sáng Đến Tối', 'trang-phuc-cong-so-linh-hoat',
           'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=800',
           'Bộ trang phục công sở linh hoạt có thể bắt đầu từ quần âu, áo sơ mi và blazer nhẹ. Thay giày hoặc thêm phụ kiện nhỏ sau giờ làm giúp diện mạo phù hợp hơn cho buổi gặp mặt buổi tối.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Giặt Và Cất Áo Len Để Hạn Chế Xù Lông', 'giat-va-cat-ao-len-han-che-xu-long',
           'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800',
           'Ưu tiên giặt nhẹ theo hướng dẫn trên nhãn và tránh vắt xoắn mạnh. Khi cất, gấp áo len thay vì treo lâu để hạn chế bai dão; giữ tủ khô thoáng giúp trang phục bền hơn.',
           'bao-quan-trang-phuc'
    UNION ALL SELECT 'Áo Sơ Mi Trắng: Món Đồ Cơ Bản Qua Nhiều Phong Cách', 'ao-so-mi-trang-qua-nhieu-phong-cach',
           'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=800',
           'Áo sơ mi trắng có thể mặc cùng quần jeans cho ngày thường hoặc phối với quần âu khi đi làm. Chọn chất liệu và độ rộng phù hợp giúp chiếc áo cơ bản luôn dễ mặc.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Quần Ống Rộng: Chọn Chiều Dài Và Phối Giày', 'quan-ong-rong-chon-chieu-dai-phoi-giay',
           'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800',
           'Gấu quần nên vừa chạm phần thân giày để tạo đường nét gọn gàng. Áo có phom vừa hoặc được sơ vin nhẹ giúp cân bằng tỷ lệ khi mặc quần ống rộng.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Phụ Kiện Nhỏ Giúp Hoàn Thiện Bộ Trang Phục', 'phu-kien-nho-hoan-thien-trang-phuc',
           'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800',
           'Thắt lưng, khăn hoặc túi có thể tạo điểm nhấn mà không cần thay đổi toàn bộ trang phục. Chọn một món làm tâm điểm và tiết chế các phụ kiện còn lại để tổng thể hài hòa.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Chọn Đầm Mùa Hè Thoải Mái Và Dễ Di Chuyển', 'chon-dam-mua-he-thoai-mai',
           'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800',
           'Trong ngày nóng, chất liệu nhẹ và phom dáng thoáng giúp bạn dễ vận động. Hãy cân nhắc độ dài, lớp lót và hoàn cảnh sử dụng trước khi chọn một chiếc đầm mùa hè.',
           'xu-huong-thoi-trang'
    UNION ALL SELECT 'Bí Quyết Giữ Màu Quần Denim Sau Nhiều Lần Giặt', 'giu-mau-quan-denim-sau-nhieu-lan-giat',
           'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800',
           'Lộn mặt trái, phân loại màu và dùng chế độ giặt nhẹ giúp giảm ma sát lên bề mặt denim. Hạn chế phơi trực tiếp dưới nắng gắt để màu vải bền hơn.',
           'bao-quan-trang-phuc'
    UNION ALL SELECT 'Cách Đưa Màu Sắc Nổi Bật Vào Bộ Đồ Hằng Ngày', 'dua-mau-sac-noi-bat-vao-bo-do',
           'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=800',
           'Nếu chưa quen mặc màu nổi, hãy bắt đầu bằng một món nhỏ như khăn, túi hoặc áo trong. Kết hợp cùng nền trung tính giúp điểm màu trở nên có chủ đích và dễ ứng dụng.',
           'xu-huong-thoi-trang'
    UNION ALL SELECT 'Áo Polo Mặc Đẹp Từ Cuối Tuần Đến Công Sở', 'ao-polo-tu-cuoi-tuan-den-cong-so',
           'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=800',
           'Áo polo mang lại sự cân bằng giữa thoải mái và chỉn chu. Phối cùng quần chinos cho vẻ lịch sự hoặc quần short khi dạo phố, đồng thời chọn độ dài áo phù hợp để mặc ngoài.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Chuẩn Bị Trang Phục Cho Ngày Mưa Thất Thường', 'chuan-bi-trang-phuc-ngay-mua',
           'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800',
           'Áo khoác nhẹ chống nước, giày dễ vệ sinh và túi có khóa kéo là lựa chọn thực tế khi thời tiết thay đổi. Ưu tiên trang phục khô nhanh để luôn thoải mái khi di chuyển.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Đóng Gói Hành Lý Du Lịch Với Ít Trang Phục Hơn', 'dong-goi-hanh-ly-du-lich-gon-nhe',
           'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800',
           'Chọn các món có thể phối chéo với nhau và giới hạn bảng màu sẽ giúp hành lý gọn hơn. Cuộn trang phục mềm, đặt món nặng ở đáy vali và mang theo một lớp áo khoác đa dụng.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Nhận Biết Chất Liệu Vải Qua Nhãn Hướng Dẫn', 'nhan-biet-chat-lieu-qua-nhan-huong-dan',
           'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800',
           'Nhãn thành phần và hướng dẫn chăm sóc giúp bạn chọn cách giặt phù hợp. Hãy lưu ý tỷ lệ sợi tự nhiên, sợi tổng hợp và nhiệt độ được khuyến nghị để bảo quản trang phục đúng cách.',
           'bao-quan-trang-phuc'
    UNION ALL SELECT 'Thời Trang Bền Vững Bắt Đầu Từ Cách Chăm Sóc Quần Áo', 'thoi-trang-ben-vung-tu-cach-cham-soc',
           'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=800',
           'Mặc lại, sửa chữa và bảo quản tốt giúp kéo dài vòng đời của trang phục. Mua có kế hoạch và chọn món phù hợp với nhiều hoàn cảnh cũng là cách xây dựng tủ đồ có trách nhiệm hơn.',
           'xu-huong-thoi-trang'
    UNION ALL SELECT 'Chọn Đúng Kích Cỡ Khi Mua Sắm Trang Phục Trực Tuyến', 'chon-kich-co-khi-mua-sam-truc-tuyen',
           'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=800',
           'Đối chiếu số đo cơ thể với bảng kích cỡ của từng sản phẩm thay vì chỉ dựa vào size quen thuộc. Nếu ở giữa hai cỡ, hãy xem phom dáng và chất liệu co giãn để chọn phù hợp.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Trang Phục Athleisure Cho Ngày Bận Rộn', 'trang-phuc-athleisure-ngay-ban-ron',
           'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800',
           'Athleisure kết hợp sự linh hoạt của đồ thể thao với các món thường ngày. Áo khoác gọn, quần co giãn và giày tối giản có thể đồng hành từ lúc di chuyển đến những buổi gặp gỡ thoải mái.',
           'xu-huong-thoi-trang'
    UNION ALL SELECT 'Phối Đồ Đơn Sắc Có Chiều Sâu Và Điểm Nhấn', 'phoi-do-don-sac-co-chieu-sau',
           'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?w=800',
           'Trang phục đơn sắc sẽ sinh động hơn khi kết hợp nhiều sắc độ, chất liệu và bề mặt khác nhau. Một phụ kiện tương phản nhẹ có thể tạo điểm nhấn mà vẫn giữ tinh thần tối giản.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Sơ Vin Áo Đúng Cách Để Tạo Tỷ Lệ Cân Đối', 'so-vin-ao-tao-ty-le-can-doi',
           'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=800',
           'Sơ vin toàn bộ tạo vẻ chỉn chu, còn sơ vin một phần phù hợp với phong cách tự nhiên. Điều chỉnh độ phồng nhẹ ở thân áo và chọn quần đúng cạp sẽ giúp tỷ lệ trang phục hài hòa.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Bảo Quản Áo Khoác Da Để Bề Mặt Luôn Đẹp', 'bao-quan-ao-khoac-da-be-mat-luon-dep',
           'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=800',
           'Lau vết bẩn bằng khăn mềm và để áo khô tự nhiên ở nơi thoáng mát. Tránh nhiệt trực tiếp, cất áo trên móc phù hợp và tham khảo hướng dẫn riêng theo chất liệu da.',
           'bao-quan-trang-phuc'
    UNION ALL SELECT 'Layering Mùa Đông Với Ba Lớp Trang Phục Cơ Bản', 'layering-mua-dong-ba-lop-co-ban',
           'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=800&auto=format&fit=crop&q=80',
           'Lớp trong thoáng khí, lớp giữa giữ ấm và lớp ngoài chắn gió tạo nên cách mặc nhiều lớp dễ điều chỉnh. Chọn phom vừa vặn để các lớp không gây cảm giác nặng nề.',
           'xu-huong-thoi-trang'
    UNION ALL SELECT 'Smart Casual Là Gì Và Phối Sao Cho Phù Hợp', 'smart-casual-la-gi-va-cach-phoi',
           'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=800',
           'Smart casual nằm giữa trang phục công sở trang trọng và đồ mặc thường ngày. Áo sơ mi, quần chinos và giày tối giản là những lựa chọn dễ bắt đầu cho nhiều buổi gặp mặt.',
           'bi-quyet-phoi-do'
    UNION ALL SELECT 'Giặt Áo Cotton Đúng Cách Để Giữ Phom Dáng', 'giat-ao-cotton-giu-phom-dang',
           'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800',
           'Giặt áo cotton với nhiệt độ vừa phải, tránh sấy quá nóng và phơi theo hướng dẫn trên nhãn. Gấp áo sau khi khô giúp hạn chế bai vai và giữ phom tốt hơn.',
           'bao-quan-trang-phuc'
    UNION ALL SELECT 'Chân Váy Midi Phối Cùng Áo Gì Cho Ngày Đi Làm', 'chan-vay-midi-phoi-ao-ngay-di-lam',
           'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800',
           'Chân váy midi kết hợp tốt với sơ mi gọn, áo len mỏng hoặc áo thun tối giản. Chọn độ dài phù hợp và giày thoải mái để bộ đồ vừa thanh lịch vừa thuận tiện trong ngày làm việc.',
           'bi-quyet-phoi-do'
) AS seeds
JOIN post_categories categories ON categories.slug = seeds.category_slug AND categories.status = 1
JOIN users authors ON UPPER(authors.email) = 'ADMIN@GMAIL.COM'
WHERE NOT EXISTS (
    SELECT 1 FROM posts existing WHERE existing.slug = seeds.slug
);

UPDATE posts
SET thumbnail_url = 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=800&auto=format&fit=crop&q=80'
WHERE slug = 'layering-mua-dong-ba-lop-co-ban';
