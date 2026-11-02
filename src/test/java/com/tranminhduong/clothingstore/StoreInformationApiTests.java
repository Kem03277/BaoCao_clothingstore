package com.tranminhduong.clothingstore;

import com.tranminhduong.clothingstore.entity.SystemSetting;
import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.entity.Payment;
import com.tranminhduong.clothingstore.entity.Role;
import com.tranminhduong.clothingstore.entity.Shipment;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.repository.SystemSettingRepository;
import com.tranminhduong.clothingstore.service.StoreInformationService;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import jakarta.persistence.EntityManager;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.security.test.context.support.WithAnonymousUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
class StoreInformationApiTests {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private SystemSettingRepository settingsRepository;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private StoreInformationService storeInformationService;

    @Test
    @WithAnonymousUser
    void publicInformationEndpointReturnsCurrentDatabaseSettings() throws Exception {
        createPaymentAndShipment("VNPAY", "SUCCESS", "Viettel Post", "SHIPPING");
        setSetting("shipping_fee", "42000");
        setSetting("free_shipping_threshold", "750000");

        mockMvc.perform(get("/api/store-information"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.paymentMethods[0]", is("VNPAY")))
                .andExpect(jsonPath("$.paymentStatuses[0]", is("SUCCESS")))
                .andExpect(jsonPath("$.shippingCarriers[0]", is("Viettel Post")))
                .andExpect(jsonPath("$.shippingStatuses[0]", is("SHIPPING")))
                .andExpect(jsonPath("$.shippingFee", is(42000)))
                .andExpect(jsonPath("$.freeShippingThreshold", is(750000)));
    }

    @Test
    void orderShippingCalculationUsesDatabaseSettings() {
        setSetting("shipping_fee", "42000");
        setSetting("free_shipping_threshold", "750000");

        org.assertj.core.api.Assertions.assertThat(
                storeInformationService.calculateShippingFee(new BigDecimal("749999")))
                .isEqualByComparingTo("42000");
        org.assertj.core.api.Assertions.assertThat(
                storeInformationService.calculateShippingFee(new BigDecimal("750000")))
                .isEqualByComparingTo("0");
    }

    private void setSetting(String key, String value) {
        SystemSetting setting = settingsRepository.findBySettingKey(key).orElseGet(SystemSetting::new);
        setting.setSettingKey(key);
        setting.setSettingValue(value);
        setting.setDescription(key);
        setting.setUpdatedAt(LocalDateTime.now());
        settingsRepository.save(setting);
    }

    private void createPaymentAndShipment(
            String method,
            String paymentStatus,
            String carrier,
            String shipmentStatus) {
        Role role = new Role();
        role.setRoleCode("USER");
        role.setRoleName("Customer");
        entityManager.persist(role);

        User user = new User();
        user.setEmail("store-info@example.test");
        user.setFullName("Store information test");
        user.setPasswordHash("test");
        user.setStatus("ACTIVE");
        user.setRole(role);
        entityManager.persist(user);

        Order order = new Order();
        order.setOrderCode("STORE-INFO-TEST");
        order.setUser(user);
        order.setStatus("SHIPPING");
        entityManager.persist(order);

        Payment payment = new Payment();
        payment.setOrder(order);
        payment.setMethod(method);
        payment.setStatus(paymentStatus);
        entityManager.persist(payment);

        Shipment shipment = new Shipment();
        shipment.setOrder(order);
        shipment.setCarrier(carrier);
        shipment.setStatus(shipmentStatus);
        entityManager.persist(shipment);
        entityManager.flush();
    }
}
