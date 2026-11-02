package com.tranminhduong.clothingstore.controller;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import com.tranminhduong.clothingstore.service.VnpayPaymentService;
import java.util.Map;
import org.junit.jupiter.api.Test;
import org.springframework.web.servlet.view.RedirectView;

class VnpayPaymentControllerTest {

    @Test
    void returnFromVnpayProcessesSignedResultBeforeRedirecting() {
        VnpayPaymentService paymentService = mock(VnpayPaymentService.class);
        VnpayPaymentController controller =
                new VnpayPaymentController(paymentService, "http://localhost:5173/");
        Map<String, String> parameters = Map.of(
                "vnp_TxnRef", "ORD-123",
                "vnp_ResponseCode", "00",
                "vnp_TransactionStatus", "00",
                "vnp_SecureHash", "signed-value");

        RedirectView redirect = controller.returnFromVnpay(parameters);

        verify(paymentService).handleIpn(parameters);
        assertTrue(redirect.getUrl().contains("vnp_order=ORD-123"));
    }
}
