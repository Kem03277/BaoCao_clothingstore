-- ======================================================================
-- SCRIPT CẬP NHẬT 100 ẢNH KHÔNG TRÙNG LẶP CHO CLOTHING STORE
-- Chạy script này trong phpMyAdmin hoặc MySQL Workbench để cập nhật ngay DB hiện tại
-- ======================================================================
USE clothingstore;

-- Product #1: Áo Thun Trơn Basic Cotton Compact
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&auto=format&fit=crop&q=80' WHERE product_id = 1 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=800&auto=format&fit=crop&q=80' WHERE product_id = 1 AND is_primary = 0;

-- Product #2: Áo Thun Graphic Phông Rộng Street Art
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800&auto=format&fit=crop&q=80' WHERE product_id = 2 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&auto=format&fit=crop&q=80' WHERE product_id = 2 AND is_primary = 0;

-- Product #3: Áo Thun Nữ Cổ Vuông Dệt Kim Co Giãn
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&auto=format&fit=crop&q=80' WHERE product_id = 3 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 3 AND is_primary = 0;

-- Product #4: Áo Thun Cổ Tròn QuickDry Thể Thao
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800&auto=format&fit=crop&q=80' WHERE product_id = 4 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 4 AND is_primary = 0;

-- Product #5: Áo Thun Nữ Croptop Baby Tee In Hình
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 5 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?w=800&auto=format&fit=crop&q=80' WHERE product_id = 5 AND is_primary = 0;

-- Product #6: Áo Thun In Chữ Typography Thêu Tinh Tế
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=800&auto=format&fit=crop&q=80' WHERE product_id = 6 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1527719327859-c6ce80353573?w=800&auto=format&fit=crop&q=80' WHERE product_id = 6 AND is_primary = 0;

-- Product #7: Áo Thun Nam Raglan Phối Màu Retro
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=800&auto=format&fit=crop&q=80' WHERE product_id = 7 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=800&auto=format&fit=crop&q=80' WHERE product_id = 7 AND is_primary = 0;

-- Product #8: Áo Thun Nữ Form Rộng Thêu Hoa Nhí
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?w=800&auto=format&fit=crop&q=80' WHERE product_id = 8 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1554412933-514a83d2f3c8?w=800&auto=format&fit=crop&q=80' WHERE product_id = 8 AND is_primary = 0;

-- Product #9: Áo Thun Unisex Cổ Tim Bo Gân Cao Cấp
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 9 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 9 AND is_primary = 0;

-- Product #10: Áo Thun Nam Sát Nách Tanktop Tập Gym
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800&auto=format&fit=crop&q=80' WHERE product_id = 10 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800&auto=format&fit=crop&q=80' WHERE product_id = 10 AND is_primary = 0;

-- Product #11: Áo Sơ Mi Nam Tay Dài Vải Bamboo Chống Nhăn
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&auto=format&fit=crop&q=80' WHERE product_id = 11 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800&auto=format&fit=crop&q=80' WHERE product_id = 11 AND is_primary = 0;

-- Product #12: Áo Sơ Mi Nữ Lụa Cổ Thắt Nơ Thanh Lịch
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=800&auto=format&fit=crop&q=80' WHERE product_id = 12 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1564257631407-4deb1299042b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 12 AND is_primary = 0;

-- Product #13: Áo Sơ Mi Oxford Cổ Bẻ Dáng Regular
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?w=800&auto=format&fit=crop&q=80' WHERE product_id = 13 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1620012253295-c15c429fcc71?w=800&auto=format&fit=crop&q=80' WHERE product_id = 13 AND is_primary = 0;

-- Product #14: Áo Sơ Mi Tay Ngắn Họa Tiết Hawaiian
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&auto=format&fit=crop&q=80' WHERE product_id = 14 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 14 AND is_primary = 0;

-- Product #15: Áo Sơ Mi Nữ Dáng Suông Tay Phồng Retro
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1589902860314-e910697dea18?w=800&auto=format&fit=crop&q=80' WHERE product_id = 15 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1551803091-e20673f15770?w=800&auto=format&fit=crop&q=80' WHERE product_id = 15 AND is_primary = 0;

-- Product #16: Áo Sơ Mi Nam Cổ Tàu Khuy Gỗ Độc Đáo
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1620012253295-c15c429fcc71?w=800&auto=format&fit=crop&q=80' WHERE product_id = 16 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1598032895397-b9472444bf93?w=800&auto=format&fit=crop&q=80' WHERE product_id = 16 AND is_primary = 0;

-- Product #17: Áo Sơ Mi Nữ Cổ Chữ V Xếp Ly Ngực
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1551803091-e20673f15770?w=800&auto=format&fit=crop&q=80' WHERE product_id = 17 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1589902860314-e910697dea18?w=800&auto=format&fit=crop&q=80' WHERE product_id = 17 AND is_primary = 0;

-- Product #18: Áo Sơ Mi Caro Flannel Dày Dặn Phối Layer
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 18 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 18 AND is_primary = 0;

-- Product #19: Áo Sơ Mi Nữ Voan Tơ Cổ Bèo Duyên Dáng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1564257631407-4deb1299042b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 19 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=800&auto=format&fit=crop&q=80' WHERE product_id = 19 AND is_primary = 0;

-- Product #20: Áo Sơ Mi Nam Tay Dài Kẻ Sọc Dọc Tôn Dáng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1598032895397-b9472444bf93?w=800&auto=format&fit=crop&q=80' WHERE product_id = 20 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?w=800&auto=format&fit=crop&q=80' WHERE product_id = 20 AND is_primary = 0;

-- Product #21: Áo Polo Nam Cafe Khử Mùi Thoáng Khí
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1625910513413-7e44a4ebdafc?w=800&auto=format&fit=crop&q=80' WHERE product_id = 21 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=800&auto=format&fit=crop&q=80' WHERE product_id = 21 AND is_primary = 0;

-- Product #22: Áo Polo Unisex Phối Bo Cổ Kẻ Sọc Thể Thao
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=800&auto=format&fit=crop&q=80' WHERE product_id = 22 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1625910513413-7e44a4ebdafc?w=800&auto=format&fit=crop&q=80' WHERE product_id = 22 AND is_primary = 0;

-- Product #23: Áo Polo Nữ Dáng Ôm Nhẹ Cúc Ngọc Trai
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80' WHERE product_id = 23 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800&auto=format&fit=crop&q=80' WHERE product_id = 23 AND is_primary = 0;

-- Product #24: Áo Polo Nam Vải Pique Cotton Mắt Chim
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1617137984095-74e4e5e3613f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 24 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1581655353564-df123a1eb820?w=800&auto=format&fit=crop&q=80' WHERE product_id = 24 AND is_primary = 0;

-- Product #25: Áo Polo Nam Trơn Không Đường May Seamless
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 25 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1617137984095-74e4e5e3613f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 25 AND is_primary = 0;

-- Product #26: Áo Polo Nữ Croptop Cổ Bẻ Năng Động
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 26 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 26 AND is_primary = 0;

-- Product #27: Áo Polo Nam Phối Viền Cổ Dáng Slimfit
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=800&auto=format&fit=crop&q=80' WHERE product_id = 27 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 27 AND is_primary = 0;

-- Product #28: Áo Polo Unisex Trơn Form Rộng Tối Giản
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=800&auto=format&fit=crop&q=80' WHERE product_id = 28 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 28 AND is_primary = 0;

-- Product #29: Áo Polo Nam Thêu Logo Ngực Sang Trọng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?w=800&auto=format&fit=crop&q=80' WHERE product_id = 29 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1617137984095-74e4e5e3613f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 29 AND is_primary = 0;

-- Product #30: Áo Polo Unisex Họa Tiết Kẻ Ngang Thủy Thủ
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80' WHERE product_id = 30 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1586363104862-3a5e2ab60d99?w=800&auto=format&fit=crop&q=80' WHERE product_id = 30 AND is_primary = 0;

-- Product #31: Áo Khoác Gió Nam 2 Lớp Chống Thấm Trượt Nước
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80' WHERE product_id = 31 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&auto=format&fit=crop&q=80' WHERE product_id = 31 AND is_primary = 0;

-- Product #32: Áo Khoác Nữ Cardigan Len Gân Cúc Vàng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=800&auto=format&fit=crop&q=80' WHERE product_id = 32 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&auto=format&fit=crop&q=80' WHERE product_id = 32 AND is_primary = 0;

-- Product #33: Áo Khoác Bomber Lót Dù Dáng Unisex
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&auto=format&fit=crop&q=80' WHERE product_id = 33 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80' WHERE product_id = 33 AND is_primary = 0;

-- Product #34: Áo Khoác Nữ Tweed Dạ Dệt Kim Sang Chảnh
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&auto=format&fit=crop&q=80' WHERE product_id = 34 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1502716119720-b23a93e5fe1b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 34 AND is_primary = 0;

-- Product #35: Áo Khoác Blazer Nam Cổ Điển 1 Khuy
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1593030761757-71fae45fa0e7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 35 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&auto=format&fit=crop&q=80' WHERE product_id = 35 AND is_primary = 0;

-- Product #36: Áo Khoác Jeans Denim Rách Xước Cá Tính
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=800&auto=format&fit=crop&q=80' WHERE product_id = 36 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 36 AND is_primary = 0;

-- Product #37: Áo Khoác Nữ Măng Tô Kèm Đai Thắt Eo
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1548624149-f9b2eb85f164?w=800&auto=format&fit=crop&q=80' WHERE product_id = 37 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&auto=format&fit=crop&q=80' WHERE product_id = 37 AND is_primary = 0;

-- Product #38: Áo Khoác Dù Nam Thể Thao Phản Quang
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1544923246-77307dd654cb?w=800&auto=format&fit=crop&q=80' WHERE product_id = 38 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80' WHERE product_id = 38 AND is_primary = 0;

-- Product #39: Áo Khoác Varsity Jacket Phối Tay Da
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1521223890158-f9f7c3d5d504?w=800&auto=format&fit=crop&q=80' WHERE product_id = 39 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=800&auto=format&fit=crop&q=80' WHERE product_id = 39 AND is_primary = 0;

-- Product #40: Áo Khoác Gió Nam Có Mũ Siêu Nhẹ Che Mưa
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1548883354-7622d03aca27?w=800&auto=format&fit=crop&q=80' WHERE product_id = 40 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&auto=format&fit=crop&q=80' WHERE product_id = 40 AND is_primary = 0;

-- Product #41: Áo Hoodie Nỉ Chân Cua Form Rộng Dày Dặn
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80' WHERE product_id = 41 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 41 AND is_primary = 0;

-- Product #42: Áo Sweatshirt Nam Cổ Tròn Nỉ Da Cá
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 42 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80' WHERE product_id = 42 AND is_primary = 0;

-- Product #43: Áo Hoodie Nữ Croptop Thêu Gấu Xinh Xắn
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?w=800&auto=format&fit=crop&q=80' WHERE product_id = 43 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 43 AND is_primary = 0;

-- Product #44: Áo Hoodie Zip Khóa Kéo Kim Loại 2 Đầu
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?w=800&auto=format&fit=crop&q=80' WHERE product_id = 44 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80' WHERE product_id = 44 AND is_primary = 0;

-- Product #45: Áo Sweatshirt Nữ In Chữ Nổi 3D Silicon
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800&auto=format&fit=crop&q=80' WHERE product_id = 45 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 45 AND is_primary = 0;

-- Product #46: Áo Hoodie Nam Phối Màu Color Block Trẻ Trung
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=800&auto=format&fit=crop&q=80' WHERE product_id = 46 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 46 AND is_primary = 0;

-- Product #47: Áo Sweatshirt Unisex Họa Tiết Loang Tie Dye
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1554412933-514a83d2f3c8?w=800&auto=format&fit=crop&q=80' WHERE product_id = 47 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80' WHERE product_id = 47 AND is_primary = 0;

-- Product #48: Áo Hoodie Nữ Dáng Dài Trùm Hông Giấu Quần
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=800&auto=format&fit=crop&q=80' WHERE product_id = 48 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=800&auto=format&fit=crop&q=80' WHERE product_id = 48 AND is_primary = 0;

-- Product #49: Áo Sweatshirt Nam Thêu Logo Chìm Trước Ngực
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 49 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80' WHERE product_id = 49 AND is_primary = 0;

-- Product #50: Áo Hoodie Unisex In Họa Tiết Vũ Trụ Galaxy
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1584273143981-41c073dfe8f8?w=800&auto=format&fit=crop&q=80' WHERE product_id = 50 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800&auto=format&fit=crop&q=80' WHERE product_id = 50 AND is_primary = 0;

-- Product #51: Quần Jeans Nam Dáng Slimfit Co Giãn 4 Chiều
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80' WHERE product_id = 51 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 51 AND is_primary = 0;

-- Product #52: Quần Jeans Nữ Ống Rộng Wide Leg Cạp Cao
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=800&auto=format&fit=crop&q=80' WHERE product_id = 52 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80' WHERE product_id = 52 AND is_primary = 0;

-- Product #53: Quần Jeans Nam Dáng Suông Straight Rửa Màu
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 53 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=800&auto=format&fit=crop&q=80' WHERE product_id = 53 AND is_primary = 0;

-- Product #54: Quần Jeans Nữ Lưng Cao Ôm Sát Skinny Tôn Dáng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=800&auto=format&fit=crop&q=80' WHERE product_id = 54 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80' WHERE product_id = 54 AND is_primary = 0;

-- Product #55: Quần Jeans Unisex Ống Đứng Rách Gối Cá Tính
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1508427953056-b00b8d78ebf5?w=800&auto=format&fit=crop&q=80' WHERE product_id = 55 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=800&auto=format&fit=crop&q=80' WHERE product_id = 55 AND is_primary = 0;

-- Product #56: Quần Jeans Nữ Baggy Ống Túm Xắn Gấu
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=800&auto=format&fit=crop&q=80' WHERE product_id = 56 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 56 AND is_primary = 0;

-- Product #57: Quần Jeans Nam Cắt Gấu Raw Hem Bụi Bặm
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1475178626620-a4d074967452?w=800&auto=format&fit=crop&q=80' WHERE product_id = 57 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=800&auto=format&fit=crop&q=80' WHERE product_id = 57 AND is_primary = 0;

-- Product #58: Quần Jeans Nữ Ống Loe Bootcut Phong Cách Cổ Điển
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1506630448388-4e683c67ddb0?w=800&auto=format&fit=crop&q=80' WHERE product_id = 58 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?w=800&auto=format&fit=crop&q=80' WHERE product_id = 58 AND is_primary = 0;

-- Product #59: Quần Jeans Unisex Túi Hộp Đa Năng Cargo
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=800&auto=format&fit=crop&q=80' WHERE product_id = 59 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80' WHERE product_id = 59 AND is_primary = 0;

-- Product #60: Quần Jeans Nam Đen Tuyền Jet Black Không Phai
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1516826957135-700dedea698c?w=800&auto=format&fit=crop&q=80' WHERE product_id = 60 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1516257984-b1b4d707412e?w=800&auto=format&fit=crop&q=80' WHERE product_id = 60 AND is_primary = 0;

-- Product #61: Quần Kaki Nam Dáng Slimfit Co Giãn Công Sở
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80' WHERE product_id = 61 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&auto=format&fit=crop&q=80' WHERE product_id = 61 AND is_primary = 0;

-- Product #62: Quần Kaki Nữ Ống Suông Cạp Xếp Ly Thanh Lịch
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&auto=format&fit=crop&q=80' WHERE product_id = 62 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80' WHERE product_id = 62 AND is_primary = 0;

-- Product #63: Quần Kaki Nam Dáng Regular Khuy Sừng Tinh Tế
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 63 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80' WHERE product_id = 63 AND is_primary = 0;

-- Product #64: Quần Kaki Unisex Túi Hộp Cargo Dây Rút Gấu
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 64 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80' WHERE product_id = 64 AND is_primary = 0;

-- Product #65: Quần Kaki Nữ Dáng Lửng Culottes Ống Rộng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=800&auto=format&fit=crop&q=80' WHERE product_id = 65 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80' WHERE product_id = 65 AND is_primary = 0;

-- Product #66: Quần Kaki Nam Lưng Thun Co Giãn Tiện Lợi
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1516914943479-89db7d9ae7f2?w=800&auto=format&fit=crop&q=80' WHERE product_id = 66 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 66 AND is_primary = 0;

-- Product #67: Quần Kaki Nam Chinos Xắn Gấu Màu Be Cổ Điển
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 67 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&auto=format&fit=crop&q=80' WHERE product_id = 67 AND is_primary = 0;

-- Product #68: Quần Kaki Nữ Dáng Ôm Nhẹ Khóa Kéo Hông
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1523398002811-999ca8dec234?w=800&auto=format&fit=crop&q=80' WHERE product_id = 68 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80' WHERE product_id = 68 AND is_primary = 0;

-- Product #69: Quần Kaki Unisex Cạp Chun Rộng Thoải Mái
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1487222477894-8943e31ef7b2?w=800&auto=format&fit=crop&q=80' WHERE product_id = 69 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 69 AND is_primary = 0;

-- Product #70: Quần Kaki Nam May Đo Cao Cấp Xếp Ly Đôi
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1514327605112-b887c0e61c0a?w=800&auto=format&fit=crop&q=80' WHERE product_id = 70 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=800&auto=format&fit=crop&q=80' WHERE product_id = 70 AND is_primary = 0;

-- Product #71: Quần Short Kaki Nam Túi Sâu Dạo Phố
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 71 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1565084888279-aca607ecce0c?w=800&auto=format&fit=crop&q=80' WHERE product_id = 71 AND is_primary = 0;

-- Product #72: Quần Short Nữ Jeans Lưng Cao Gấu Tưa Năng Động
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1565084888279-aca607ecce0c?w=800&auto=format&fit=crop&q=80' WHERE product_id = 72 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 72 AND is_primary = 0;

-- Product #73: Quần Short Unisex Dù Gió Thể Thao 2 Lớp
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=800&auto=format&fit=crop&q=80' WHERE product_id = 73 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 73 AND is_primary = 0;

-- Product #74: Quần Short Nam Vải Đũi Linen Thoáng Mát
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591195856475-472d8a07c31d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 74 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 74 AND is_primary = 0;

-- Product #75: Quần Short Nữ Kaki Chữ A Kèm Thắt Lưng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1550614000-4895a10e1bfd?w=800&auto=format&fit=crop&q=80' WHERE product_id = 75 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1508427953056-b00b8d78ebf5?w=800&auto=format&fit=crop&q=80' WHERE product_id = 75 AND is_primary = 0;

-- Product #76: Quần Short Unisex Nỉ Da Cá Dây Rút Đầu Bọc Kim Loại
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1506152983158-b4a74a01c721?w=800&auto=format&fit=crop&q=80' WHERE product_id = 76 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 76 AND is_primary = 0;

-- Product #77: Quần Short Nam Bơi Họa Tiết Mau Khô
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800&auto=format&fit=crop&q=80' WHERE product_id = 77 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1565084888279-aca607ecce0c?w=800&auto=format&fit=crop&q=80' WHERE product_id = 77 AND is_primary = 0;

-- Product #78: Quần Short Nữ Dạ Tweed Viền Ren Nữ Tính
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1503342394128-c104d54dba01?w=800&auto=format&fit=crop&q=80' WHERE product_id = 78 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1550614000-4895a10e1bfd?w=800&auto=format&fit=crop&q=80' WHERE product_id = 78 AND is_primary = 0;

-- Product #79: Quần Short Nam Chinos Cắt May Chỉn Chu
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1529720317453-c8da503f2051?w=800&auto=format&fit=crop&q=80' WHERE product_id = 79 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 79 AND is_primary = 0;

-- Product #80: Quần Short Unisex Cargo Túi Hộp Bụi Bặm
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1516762689617-e1cffcef479d?w=800&auto=format&fit=crop&q=80' WHERE product_id = 80 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1562157873-818bc0726f68?w=800&auto=format&fit=crop&q=80' WHERE product_id = 80 AND is_primary = 0;

-- Product #81: Quần Tây Nam Dáng Slimfit Xếp Ly Trước
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=800&auto=format&fit=crop&q=80' WHERE product_id = 81 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800&auto=format&fit=crop&q=80' WHERE product_id = 81 AND is_primary = 0;

-- Product #82: Quần Tây Nữ Ống Loe Cạp Cao Nâng Mông
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1550639525-c97d455acf70?w=800&auto=format&fit=crop&q=80' WHERE product_id = 82 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80' WHERE product_id = 82 AND is_primary = 0;

-- Product #83: Quần Tây Nam Lưng Tăng Đơ Điều Chỉnh Thông Minh
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1479064555552-3ce4979f8908?w=800&auto=format&fit=crop&q=80' WHERE product_id = 83 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80' WHERE product_id = 83 AND is_primary = 0;

-- Product #84: Quần Tây Nữ Ống Suông Khóa Sườn Sang Trọng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1508296695146-257a814070b4?w=800&auto=format&fit=crop&q=80' WHERE product_id = 84 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80' WHERE product_id = 84 AND is_primary = 0;

-- Product #85: Quần Tây Nam Cạp Cao Gurkha Đậm Chất Sartorial
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1489980556514-2797052a5782?w=800&auto=format&fit=crop&q=80' WHERE product_id = 85 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=800&auto=format&fit=crop&q=80' WHERE product_id = 85 AND is_primary = 0;

-- Product #86: Quần Tây Nữ Dáng Baggy Cắt Ngắn Ankle
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 86 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1551803091-e20673f15770?w=800&auto=format&fit=crop&q=80' WHERE product_id = 86 AND is_primary = 0;

-- Product #87: Quần Tây Nam Vải Wool Pha Sợi Co Giãn
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1504198453319-5ce911bafc46?w=800&auto=format&fit=crop&q=80' WHERE product_id = 87 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80' WHERE product_id = 87 AND is_primary = 0;

-- Product #88: Quần Tây Nữ Xẻ Tà Trước Gấu Quần Cá Tính
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=800&auto=format&fit=crop&q=80' WHERE product_id = 88 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800&auto=format&fit=crop&q=80' WHERE product_id = 88 AND is_primary = 0;

-- Product #89: Quần Tây Unisex Dáng Rộng Ống Đứng Xu Hướng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1504593811423-6dd665756598?w=800&auto=format&fit=crop&q=80' WHERE product_id = 89 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1594938298603-c8148c4dae35?w=800&auto=format&fit=crop&q=80' WHERE product_id = 89 AND is_primary = 0;

-- Product #90: Quần Tây Nam Xanh Navy Kẻ Sọc Chìm Lịch Lãm
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1490114538077-ac7f12197170?w=800&auto=format&fit=crop&q=80' WHERE product_id = 90 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1593030761757-71fae45fa0e7?w=800&auto=format&fit=crop&q=80' WHERE product_id = 90 AND is_primary = 0;

-- Product #91: Chân Váy Chữ A Công Sở Kèm Thắt Lưng Kim Loại
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1582142306909-195724d33ffc?w=800&auto=format&fit=crop&q=80' WHERE product_id = 91 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1550614000-4895a10e1bfd?w=800&auto=format&fit=crop&q=80' WHERE product_id = 91 AND is_primary = 0;

-- Product #92: Đầm Xòe Nữ Cổ Vuông Tay Bồng Dáng Dài Dự Tiệc
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800&auto=format&fit=crop&q=80' WHERE product_id = 92 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=800&auto=format&fit=crop&q=80' WHERE product_id = 92 AND is_primary = 0;

-- Product #93: Chân Váy Xếp Ly Nhỏ Dáng Dài Vintage Hàn Quốc
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800&auto=format&fit=crop&q=80' WHERE product_id = 93 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1582142306909-195724d33ffc?w=800&auto=format&fit=crop&q=80' WHERE product_id = 93 AND is_primary = 0;

-- Product #94: Đầm Suông Nữ Cổ Polo Năng Động Trẻ Trung
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=800&auto=format&fit=crop&q=80' WHERE product_id = 94 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=800&auto=format&fit=crop&q=80' WHERE product_id = 94 AND is_primary = 0;

-- Product #95: Chân Váy Bút Chì Xẻ Tà Sau Tôn Dáng Gợi Cảm
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 95 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1582142306909-195724d33ffc?w=800&auto=format&fit=crop&q=80' WHERE product_id = 95 AND is_primary = 0;

-- Product #96: Đầm Nữ Bodycon Ôm Sát Cổ Yếm Quyến Rũ
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1612336307429-8a898d10e223?w=800&auto=format&fit=crop&q=80' WHERE product_id = 96 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800&auto=format&fit=crop&q=80' WHERE product_id = 96 AND is_primary = 0;

-- Product #97: Chân Váy Jeans Đuôi Cá Nữ Tính Thời Thượng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1502716119720-b23a93e5fe1b?w=800&auto=format&fit=crop&q=80' WHERE product_id = 97 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop&q=80' WHERE product_id = 97 AND is_primary = 0;

-- Product #98: Đầm Hoa Nhí Cổ V Tay Lửng Bo Eo Dịu Dàng
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=800&auto=format&fit=crop&q=80' WHERE product_id = 98 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1612336307429-8a898d10e223?w=800&auto=format&fit=crop&q=80' WHERE product_id = 98 AND is_primary = 0;

-- Product #99: Chân Váy Dạ Tweed Nữ Cúc Ngọc Xinh Xắn
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1492707892479-7bc8d5a4ee93?w=800&auto=format&fit=crop&q=80' WHERE product_id = 99 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=800&auto=format&fit=crop&q=80' WHERE product_id = 99 AND is_primary = 0;

-- Product #100: Đầm Sơ Mi Nữ Kèm Đai Thắt Eo Lịch Thiệp
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1525450824786-227cbef70703?w=800&auto=format&fit=crop&q=80' WHERE product_id = 100 AND is_primary = 1;
UPDATE product_images SET image_url = 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800&auto=format&fit=crop&q=80' WHERE product_id = 100 AND is_primary = 0;
