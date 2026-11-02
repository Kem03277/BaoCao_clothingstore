package com.tranminhduong.clothingstore.dto;

public record AddressResponse(
        Long id,
        String recipientName,
        String phone,
        String province,
        String addressLine) {
}
