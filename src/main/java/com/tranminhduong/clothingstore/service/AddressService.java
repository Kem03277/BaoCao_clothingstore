package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.entity.Address;
import java.util.List;

public interface AddressService {
    List<Address> getAddresses(Long userId);
    Address getAddress(Long userId, Long addressId);
    Address createAddress(Long userId, String recipientName, String phone, String province, String addressLine);
    Address updateAddress(Long userId, Long addressId, String recipientName, String phone, String province, String addressLine);
    void deleteAddress(Long userId, Long addressId);
}
