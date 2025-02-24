package com.megacitycab.model.dtos;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class BookingDto {

    private String toDestination;
    private String fromDestination;
    private Integer numberOfPassengers;
    private Double distance;
    private Double duration;
    private Long customerId;
    private Long cabId;
    private Long billId;

}
