package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.dto.StoreInformationResponse;
import com.tranminhduong.clothingstore.entity.SystemSetting;
import com.tranminhduong.clothingstore.repository.PaymentRepository;
import com.tranminhduong.clothingstore.repository.ShipmentRepository;
import com.tranminhduong.clothingstore.repository.SystemSettingRepository;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StoreInformationService {

    private static final Map<String, String> DEFAULT_SETTINGS = Map.of(
            "shipping_fee", "30000",
            "free_shipping_threshold", "500000");

    private final SystemSettingRepository settingsRepository;
    private final PaymentRepository paymentRepository;
    private final ShipmentRepository shipmentRepository;

    public StoreInformationService(
            SystemSettingRepository settingsRepository,
            PaymentRepository paymentRepository,
            ShipmentRepository shipmentRepository) {
        this.settingsRepository = settingsRepository;
        this.paymentRepository = paymentRepository;
        this.shipmentRepository = shipmentRepository;
    }

    @Transactional
    public StoreInformationResponse getPublicInformation() {
        try {
            ensureDefaultSettings();
        } catch (Exception ignored) {
        }

        Map<String, String> settings = Map.of();
        try {
            settings = settingsRepository.findAll().stream()
                    .filter(setting -> setting.getSettingKey() != null && setting.getSettingValue() != null)
                    .collect(Collectors.toMap(
                            SystemSetting::getSettingKey,
                            SystemSetting::getSettingValue,
                            (first, ignored) -> first));
        } catch (Exception ignored) {
        }

        return toResponse(settings);
    }

    @Transactional
    public BigDecimal calculateShippingFee(BigDecimal subtotal) {
        StoreInformationResponse information = getPublicInformation();
        return subtotal.compareTo(information.freeShippingThreshold()) >= 0
                ? BigDecimal.ZERO
                : information.shippingFee();
    }

    private void ensureDefaultSettings() {
        for (Map.Entry<String, String> entry : DEFAULT_SETTINGS.entrySet()) {
            if (settingsRepository.findBySettingKey(entry.getKey()).isEmpty()) {
                SystemSetting setting = new SystemSetting();
                setting.setSettingKey(entry.getKey());
                setting.setSettingValue(entry.getValue());
                setting.setDescription(entry.getKey());
                setting.setUpdatedAt(LocalDateTime.now());
                settingsRepository.save(setting);
            }
        }
    }

    private StoreInformationResponse toResponse(Map<String, String> settings) {
        List<String> methods = null;
        List<String> paymentStatuses = null;
        List<String> carriers = null;
        List<String> shipmentStatuses = null;

        try {
            methods = paymentRepository.findDistinctMethods();
        } catch (Exception ignored) {
        }
        if (methods == null || methods.isEmpty()) {
            methods = List.of("COD", "VNPAY");
        }

        try {
            paymentStatuses = paymentRepository.findDistinctStatuses();
        } catch (Exception ignored) {
        }
        if (paymentStatuses == null || paymentStatuses.isEmpty()) {
            paymentStatuses = List.of("PENDING", "COMPLETED", "FAILED");
        }

        try {
            carriers = shipmentRepository.findDistinctCarriers();
        } catch (Exception ignored) {
        }
        if (carriers == null || carriers.isEmpty()) {
            carriers = List.of("Giao Hàng Nhanh", "Viettel Post");
        }

        try {
            shipmentStatuses = shipmentRepository.findDistinctStatuses();
        } catch (Exception ignored) {
        }
        if (shipmentStatuses == null || shipmentStatuses.isEmpty()) {
            shipmentStatuses = List.of("PENDING", "SHIPPED", "DELIVERED");
        }

        return new StoreInformationResponse(
                methods,
                paymentStatuses,
                carriers,
                shipmentStatuses,
                decimal(settings, "shipping_fee", new BigDecimal("30000")),
                decimal(settings, "free_shipping_threshold", new BigDecimal("500000")));
    }

    private BigDecimal decimal(Map<String, String> settings, String key, BigDecimal defaultValue) {
        String value = settings.get(key);
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        try {
            BigDecimal parsed = new BigDecimal(value.trim());
            return parsed.signum() < 0 ? defaultValue : parsed;
        } catch (Exception ignored) {
            return defaultValue;
        }
    }
}
