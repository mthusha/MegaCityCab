package com.megacitycab.model.dtos;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class BookingDto {

    private String toDestination;
    private String fromDestination;
    private Integer numberOfPassengers;
    private String bookingDateTime;
    private Double distance;
    private Double duration;
    private Long customerId;
    private Long cabId;
    private Long billId;

}
