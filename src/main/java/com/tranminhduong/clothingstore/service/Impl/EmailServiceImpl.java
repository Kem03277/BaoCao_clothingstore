package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.entity.OrderItem;
import com.tranminhduong.clothingstore.service.EmailService;
import jakarta.mail.internet.MimeMessage;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.concurrent.CompletableFuture;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceImpl implements EmailService {
    private static final Logger log = LoggerFactory.getLogger(EmailServiceImpl.class);
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username:}")
    private String mailFrom;

    @Value("${store.mail.admin-email:}")
    private String adminNotificationEmail;

    public EmailServiceImpl(@Autowired(required = false) JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    @Override
    public void sendOrderPaymentConfirmation(Order order) {
        if (order == null) return;

        // Chạy bất đồng bộ trong background thread để không chặn request thanh toán
        CompletableFuture.runAsync(() -> {
            try {
                if (mailSender == null) {
                    log.warn("JavaMailSender chưa được cấu hình. Bỏ qua gửi email cho đơn hàng {}", order.getOrderCode());
                    return;
                }

                if (mailFrom == null || mailFrom.isBlank()) {
                    log.warn("spring.mail.username chưa được cấu hình. Bỏ qua gửi email cho đơn hàng {}", order.getOrderCode());
                    return;
                }

                String recipientEmail = null;
                if (order.getUser() != null && order.getUser().getEmail() != null && !order.getUser().getEmail().isBlank()) {
                    recipientEmail = order.getUser().getEmail().trim();
                }

                // Địa chỉ nhận email thực tế: ưu tiên gửi đến khách và gửi kèm bản sao cho admin
                String primaryRecipient = (recipientEmail != null && !recipientEmail.isBlank()) ? recipientEmail : adminNotificationEmail;
                if (primaryRecipient == null || primaryRecipient.isBlank()) {
                    log.warn("Đơn hàng {} không có email người nhận. Bỏ qua gửi email.", order.getOrderCode());
                    return;
                }

                MimeMessage message = mailSender.createMimeMessage();
                MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

                helper.setFrom(mailFrom, "Atelier Haute Couture");
                helper.setTo(primaryRecipient);

                // Gửi bản sao cho admin nếu khác với người nhận chính
                if (adminNotificationEmail != null && !adminNotificationEmail.isBlank() && !adminNotificationEmail.equalsIgnoreCase(primaryRecipient)) {
                    helper.setBcc(adminNotificationEmail.trim());
                }

                helper.setSubject("[Atelier] Xác nhận thanh toán thành công đơn hàng #" + order.getOrderCode());

                String htmlContent = buildOrderEmailHtml(order);
                helper.setText(htmlContent, true);

                mailSender.send(message);
                log.info("Đã gửi email xác nhận thanh toán đơn hàng {} thành công đến {}", order.getOrderCode(), primaryRecipient);

            } catch (Exception ex) {
                log.error("Lỗi khi gửi email xác nhận đơn hàng {}: {}", order.getOrderCode(), ex.getMessage(), ex);
            }
        });
    }

    private String buildOrderEmailHtml(Order order) {
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(Locale.forLanguageTag("vi-VN"));

        StringBuilder itemsHtml = new StringBuilder();
        if (order.getOrderItems() != null) {
            for (OrderItem item : order.getOrderItems()) {
                String unitPriceStr = item.getUnitPrice() != null ? currencyFormat.format(item.getUnitPrice()) : "0 đ";
                String lineTotalStr = item.getLineTotal() != null ? currencyFormat.format(item.getLineTotal()) : "0 đ";
                String sizeStr = item.getSizeName() != null ? item.getSizeName() : "Tiêu chuẩn";

                itemsHtml.append("""
                    <tr style="border-bottom: 1px solid #f0ede8;">
                        <td style="padding: 12px 8px; font-size: 13px; color: #1c1917; font-weight: 600;">
                            %s
                            <span style="display: block; font-size: 11px; color: #78716c; font-weight: normal; margin-top: 2px;">
                                Kích cỡ: <strong style="color: #c6a77b;">%s</strong>
                            </span>
                        </td>
                        <td style="padding: 12px 8px; font-size: 13px; color: #44403c; text-align: center; font-weight: bold;">
                            %d
                        </td>
                        <td style="padding: 12px 8px; font-size: 13px; color: #78716c; text-align: right; font-family: monospace;">
                            %s
                        </td>
                        <td style="padding: 12px 8px; font-size: 13px; color: #1c1917; text-align: right; font-weight: bold; font-family: monospace;">
                            %s
                        </td>
                    </tr>
                """.formatted(
                    escapeHtml(item.getProductName()),
                    escapeHtml(sizeStr),
                    item.getQuantity() != null ? item.getQuantity() : 1,
                    unitPriceStr,
                    lineTotalStr
                ));
            }
        }

        String subtotalStr = order.getSubtotal() != null ? currencyFormat.format(order.getSubtotal()) : "0 đ";
        String discountStr = (order.getDiscountAmount() != null && order.getDiscountAmount().compareTo(BigDecimal.ZERO) > 0)
                ? "-" + currencyFormat.format(order.getDiscountAmount())
                : "0 đ";
        String shippingFeeStr = order.getShippingFee() != null ? currencyFormat.format(order.getShippingFee()) : "0 đ";
        String totalAmountStr = order.getTotalAmount() != null ? currencyFormat.format(order.getTotalAmount()) : "0 đ";
        String createdAtStr = order.getCreatedAt() != null ? order.getCreatedAt().format(DATE_FORMATTER) : "";

        return """
            <!DOCTYPE html>
            <html lang="vi">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Xác nhận đơn hàng</title>
            </head>
            <body style="margin: 0; padding: 0; background-color: #faf9f6; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;">
                <table width="100%%" border="0" cellspacing="0" cellpadding="0" style="background-color: #faf9f6; padding: 30px 10px;">
                    <tr>
                        <td align="center">
                            <table width="600" border="0" cellspacing="0" cellpadding="0" style="background-color: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.06); border: 1px solid #ede8e1;">
                                <!-- Header -->
                                <tr>
                                    <td style="background-color: #0b0b0d; padding: 32px 30px; text-align: center; border-bottom: 2px solid #c6a77b;">
                                        <p style="margin: 0; font-size: 11px; letter-spacing: 0.3em; text-transform: uppercase; color: #c6a77b; font-weight: bold;">
                                            ATELIER HAUTE COUTURE
                                        </p>
                                        <h1 style="margin: 8px 0 0; color: #ffffff; font-size: 24px; font-weight: 800; letter-spacing: -0.02em;">
                                            XÁC NHẬN THANH TOÁN THÀNH CÔNG
                                        </h1>
                                        <p style="margin: 6px 0 0; color: #a8a29e; font-size: 13px;">
                                            Mã đơn hàng: <strong style="color: #c6a77b; font-family: monospace;">#%s</strong>
                                        </p>
                                    </td>
                                </tr>

                                <!-- Welcome text -->
                                <tr>
                                    <td style="padding: 28px 30px 15px;">
                                        <p style="margin: 0; font-size: 15px; color: #1c1917; line-height: 1.6;">
                                            Kính chào <strong>%s</strong>,
                                        </p>
                                        <p style="margin: 8px 0 0; font-size: 14px; color: #57534e; line-height: 1.6;">
                                            Chúng tôi đã nhận được thanh toán chuyển khoản cho đơn hàng của bạn qua ngân hàng <strong>MBBank</strong>. Đơn hàng hiện đang được chuyển đến bộ phận đóng gói và sẵn sàng xuất kho.
                                        </p>
                                    </td>
                                </tr>

                                <!-- Order summary table -->
                                <tr>
                                    <td style="padding: 10px 30px;">
                                        <table width="100%%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                                            <thead>
                                                <tr style="background-color: #f5f2eb; border-top: 1px solid #e7e2d7; border-bottom: 1px solid #e7e2d7;">
                                                    <th align="left" style="padding: 10px 8px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.1em; color: #78716c;">Sản phẩm</th>
                                                    <th align="center" style="padding: 10px 8px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.1em; color: #78716c;">SL</th>
                                                    <th align="right" style="padding: 10px 8px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.1em; color: #78716c;">Đơn giá</th>
                                                    <th align="right" style="padding: 10px 8px; font-size: 11px; text-transform: uppercase; letter-spacing: 0.1em; color: #78716c;">Thành tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                %s
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>

                                <!-- Cost breakdown -->
                                <tr>
                                    <td style="padding: 15px 30px 20px;">
                                        <table width="100%%" border="0" cellspacing="0" cellpadding="0" style="font-size: 13px; color: #57534e;">
                                            <tr>
                                                <td style="padding: 4px 0;">Tạm tính sản phẩm:</td>
                                                <td align="right" style="padding: 4px 0; font-family: monospace; font-weight: 600;">%s</td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 4px 0;">Giảm giá Voucher:</td>
                                                <td align="right" style="padding: 4px 0; font-family: monospace; font-weight: 600; color: #dc2626;">%s</td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 4px 0;">Phí vận chuyển toàn quốc:</td>
                                                <td align="right" style="padding: 4px 0; font-family: monospace; font-weight: 600;">%s</td>
                                            </tr>
                                            <tr style="border-top: 1px dashed #d6d3d1;">
                                                <td style="padding: 12px 0; font-size: 15px; font-weight: 800; color: #0b0b0d;">TỔNG TIỀN ĐÃ THANH TOÁN:</td>
                                                <td align="right" style="padding: 12px 0; font-size: 18px; font-weight: 800; color: #a88452; font-family: monospace;">%s</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>

                                <!-- Delivery Information Card -->
                                <tr>
                                    <td style="padding: 0 30px 25px;">
                                        <div style="background-color: #fbf9f5; border: 1px solid #ede8de; border-radius: 14px; padding: 18px 20px;">
                                            <h3 style="margin: 0 0 10px; font-size: 12px; text-transform: uppercase; letter-spacing: 0.15em; color: #a88452; font-weight: bold;">
                                                THÔNG TIN GIAO HÀNG
                                            </h3>
                                            <p style="margin: 4px 0; font-size: 13px; color: #292524;">
                                                <strong>Người nhận:</strong> %s &bull; <strong>SĐT:</strong> %s
                                            </p>
                                            <p style="margin: 4px 0; font-size: 13px; color: #57534e; line-height: 1.5;">
                                                <strong>Địa chỉ:</strong> %s
                                            </p>
                                            <p style="margin: 4px 0; font-size: 12px; color: #78716c;">
                                                <strong>Thời gian đặt hàng:</strong> %s
                                            </p>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Footer -->
                                <tr>
                                    <td style="background-color: #141416; padding: 24px 30px; text-align: center; color: #a8a29e; font-size: 12px; line-height: 1.6;">
                                        <p style="margin: 0; color: #d6d3d1; font-weight: bold;">
                                            ATELIER CLOTHING STORE &bull; HAUTE COUTURE EDITION
                                        </p>
                                        <p style="margin: 4px 0 0;">
                                            Cần hỗ trợ đơn hàng? Vui lòng phản hồi email này hoặc liên hệ hotline cửa hàng.
                                        </p>
                                        <p style="margin: 8px 0 0; font-size: 11px; color: #78716c;">
                                            &copy; 2026 Atelier. Tất cả các quyền được bảo lưu.
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </body>
            </html>
        """.formatted(
            escapeHtml(order.getOrderCode()),
            escapeHtml(order.getRecipientName() != null ? order.getRecipientName() : "Quý khách"),
            itemsHtml.toString(),
            subtotalStr,
            discountStr,
            shippingFeeStr,
            totalAmountStr,
            escapeHtml(order.getRecipientName() != null ? order.getRecipientName() : "Khách hàng"),
            escapeHtml(order.getRecipientPhone() != null ? order.getRecipientPhone() : ""),
            escapeHtml(order.getShippingAddress() != null ? order.getShippingAddress() : "Tại cửa hàng"),
            createdAtStr
        );
    }

    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
}

