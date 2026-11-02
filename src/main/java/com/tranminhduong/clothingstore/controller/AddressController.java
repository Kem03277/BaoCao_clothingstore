package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.AddressRequest;
import com.tranminhduong.clothingstore.dto.AddressResponse;
import com.tranminhduong.clothingstore.mapper.AddressMapper;
import com.tranminhduong.clothingstore.security.AuthenticatedUser;
import com.tranminhduong.clothingstore.service.AddressService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/addresses")
public class AddressController {

    private final AddressService addressService;
    private final AddressMapper addressMapper;

    public AddressController(AddressService addressService, AddressMapper addressMapper) {
        this.addressService = addressService;
        this.addressMapper = addressMapper;
    }

    @GetMapping
    public List<AddressResponse> getOwnAddresses(@AuthenticationPrincipal AuthenticatedUser currentUser) {
        return addressService.getAddresses(currentUser.id()).stream()
                .map(addressMapper::toResponse)
                .toList();
    }

    @GetMapping("/{id}")
    public ResponseEntity<AddressResponse> getOwnAddress(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @PathVariable("id") Long id) {
        return ResponseEntity.ok(addressMapper.toResponse(addressService.getAddress(currentUser.id(), id)));
    }

    @PostMapping
    public ResponseEntity<AddressResponse> createAddress(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @RequestBody(required = false) AddressRequest request) {
        AddressResponse response = addressMapper.toResponse(addressService.createAddress(
                currentUser.id(),
                request == null ? null : request.recipientName(),
                request == null ? null : request.phone(),
                request == null ? null : request.province(),
                request == null ? null : request.addressLine()));
        return ResponseEntity.status(201).body(response);
    }

    @PutMapping("/{id}")
    public ResponseEntity<AddressResponse> updateAddress(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @PathVariable("id") Long id,
            @RequestBody(required = false) AddressRequest request) {
        return ResponseEntity.ok(addressMapper.toResponse(addressService.updateAddress(
                currentUser.id(),
                id,
                request == null ? null : request.recipientName(),
                request == null ? null : request.phone(),
                request == null ? null : request.province(),
                request == null ? null : request.addressLine())));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteAddress(
            @AuthenticationPrincipal AuthenticatedUser currentUser,
            @PathVariable("id") Long id) {
        addressService.deleteAddress(currentUser.id(), id);
        return ResponseEntity.noContent().build();
    }
}
