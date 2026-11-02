package com.tranminhduong.clothingstore.controller;

import com.tranminhduong.clothingstore.dto.StoreInformationResponse;
import com.tranminhduong.clothingstore.service.StoreInformationService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/store-information")
public class StoreInformationController {

    private final StoreInformationService storeInformationService;

    public StoreInformationController(StoreInformationService storeInformationService) {
        this.storeInformationService = storeInformationService;
    }

    @GetMapping
    public StoreInformationResponse getInformation() {
        return storeInformationService.getPublicInformation();
    }
}
