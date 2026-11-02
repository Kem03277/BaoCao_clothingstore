package com.tranminhduong.clothingstore.mapper;

import com.tranminhduong.clothingstore.dto.AddressResponse;
import com.tranminhduong.clothingstore.entity.Address;
import org.springframework.stereotype.Component;

@Component
public class AddressMapper {

    public AddressResponse toResponse(Address address) {
        if (address == null) {
            return null;
        }
        return new AddressResponse(
                address.getId(),
                address.getRecipientName(),
                address.getPhone(),
                address.getProvince(),
                address.getAddressLine());
    }
}
