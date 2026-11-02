package com.tranminhduong.clothingstore.service.Impl;

import com.tranminhduong.clothingstore.entity.Address;
import com.tranminhduong.clothingstore.entity.User;
import com.tranminhduong.clothingstore.exception.BadRequestException;
import com.tranminhduong.clothingstore.exception.ResourceNotFoundException;
import com.tranminhduong.clothingstore.repository.AddressRepository;
import com.tranminhduong.clothingstore.repository.CustomerRepository;
import com.tranminhduong.clothingstore.service.AddressService;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AddressServiceImpl implements AddressService {

    private final AddressRepository addressRepository;
    private final CustomerRepository customerRepository;

    public AddressServiceImpl(AddressRepository addressRepository, CustomerRepository customerRepository) {
        this.addressRepository = addressRepository;
        this.customerRepository = customerRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Address> getAddresses(Long userId) {
        return addressRepository.findByUser_IdOrderByIdAsc(userId);
    }

    @Override
    @Transactional(readOnly = true)
    public Address getAddress(Long userId, Long addressId) {
        Address address = addressRepository.findById(addressId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy địa chỉ có id = " + addressId));
        if (!address.getUser().getId().equals(userId)) {
            throw new BadRequestException("Bạn không có quyền truy cập địa chỉ này");
        }
        return address;
    }

    @Override
    @Transactional
    public Address createAddress(
            Long userId,
            String recipientName,
            String phone,
            String province,
            String addressLine) {
        User user = customerRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Không tìm thấy người dùng có id = " + userId));
        if (recipientName == null || recipientName.isBlank()) {
            throw new BadRequestException("Tên người nhận không được để trống");
        }
        if (phone == null || phone.isBlank()) {
            throw new BadRequestException("Số điện thoại người nhận không được để trống");
        }
        if (province == null || province.isBlank()) {
            throw new BadRequestException("Tỉnh/thành phố không được để trống");
        }
        if (addressLine == null || addressLine.isBlank()) {
            throw new BadRequestException("Địa chỉ chi tiết không được để trống");
        }

        Address address = new Address();
        address.setUser(user);
        address.setRecipientName(recipientName.trim());
        address.setPhone(phone.trim());
        address.setProvince(province.trim());
        address.setAddressLine(addressLine.trim());
        return addressRepository.save(address);
    }

    @Override
    @Transactional
    public Address updateAddress(
            Long userId,
            Long addressId,
            String recipientName,
            String phone,
            String province,
            String addressLine) {
        Address address = getAddress(userId, addressId);
        if (recipientName != null && !recipientName.isBlank()) {
            address.setRecipientName(recipientName.trim());
        }
        if (phone != null && !phone.isBlank()) {
            address.setPhone(phone.trim());
        }
        if (province != null && !province.isBlank()) {
            address.setProvince(province.trim());
        }
        if (addressLine != null && !addressLine.isBlank()) {
            address.setAddressLine(addressLine.trim());
        }
        return addressRepository.save(address);
    }

    @Override
    @Transactional
    public void deleteAddress(Long userId, Long addressId) {
        Address address = getAddress(userId, addressId);
        addressRepository.delete(address);
    }
}
