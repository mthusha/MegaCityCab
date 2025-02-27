package com.megacitycab.model.dtos;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookingGetDto {
    private Long id;
    private String toDestination;
    private String fromDestination;
    private Integer numberOfPassengers;
    private String bookingDateTime;
    private String bookingStatus;
    private Double distance;
    private Double duration;
    private String customerName;
    private String cabModelName;
    private Long billId;
}
