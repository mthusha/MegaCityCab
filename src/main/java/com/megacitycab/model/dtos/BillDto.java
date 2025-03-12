package com.megacitycab.model.dtos;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BillDto {
    private Long id;
    private Double amount;
    private Double tax;
    private Double discountAmount;
    private String billingDate;
    private Long bookingId;
}
