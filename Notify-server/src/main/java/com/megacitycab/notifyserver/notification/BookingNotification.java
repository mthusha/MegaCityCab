package com.megacitycab.notifyserver.notification;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
public class BookingNotification {
    private String type;
    private Long bookingId;
    private String cabName;
    private String customerName;
    private String bookingDateTime;

}
