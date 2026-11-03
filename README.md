# BaoCao_clothingstore

## Cấu hình môi trường

Sau khi clone, tạo file `.env` từ mẫu ở thư mục gốc:

```powershell
Copy-Item .env.example .env
```

Thanh toán COD dùng được mà không cần cấu hình VNPay. Để bật VNPay, điền
`VNPAY_TMN_CODE` và `VNPAY_HASH_SECRET` do VNPay cấp vào `.env`, sau đó khởi
động lại backend. Không commit file `.env` hoặc chia sẻ các giá trị bí mật.

`JWT_SECRET` có thể để trống khi chạy local; ứng dụng sẽ tạo khóa tạm và các
token đăng nhập sẽ mất hiệu lực sau khi khởi động lại.