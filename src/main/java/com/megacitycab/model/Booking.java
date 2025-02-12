package com.megacitycab.model;

import com.megacitycab.enums.BookingStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String toDestination;
    private String fromDestination;
    private Double fareAmount;
    private LocalDateTime bookingDateTime;
    private Integer numberOfPassengers;

    @Enumerated(EnumType.STRING)
    private BookingStatus status;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "cab_id")
    private Cabs cabs;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "customer_id")
    private Customer customer;

    @OneToOne(mappedBy = "booking",cascade = CascadeType.ALL)
    private Bill bill;
}
