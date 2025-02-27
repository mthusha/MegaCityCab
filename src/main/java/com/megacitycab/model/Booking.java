package com.megacitycab.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
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
    private Double distance;
    private Double duration;

    @Enumerated(EnumType.STRING)
    private BookingStatus status;

    @JsonIgnore
    @JsonManagedReference
    @ManyToOne()
    @JoinColumn(name = "cab_id")
    private Cabs cabs;

    @JsonIgnore
    @JsonManagedReference
    @ManyToOne()
    @JoinColumn(name = "customer_id")
    private Customer customer;

    @JsonIgnore
    @JsonManagedReference
    @OneToOne(mappedBy = "booking",cascade = CascadeType.ALL)
    private Bill bill;
}
