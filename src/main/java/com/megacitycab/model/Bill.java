package com.megacitycab.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Setter
@Getter
public class Bill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Double amount;
    private Double tax;
    private Double discountAmount;
    private LocalDateTime billingDate;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "booking_id")
    private Booking booking;
}
