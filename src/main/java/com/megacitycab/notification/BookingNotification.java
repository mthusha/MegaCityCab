package com.megacitycab.notification;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
public class BookingNotification {
    private String type = "BOOKING_CREATED";
    private Long bookingId;
    private String cabId;
    private String customerName;
    private String bookingDateTime;
}
