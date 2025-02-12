package com.megacitycab.model;

import com.megacitycab.enums.CabStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Cabs {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private Integer model;
    private Integer numberOfSeats;

    @Enumerated(EnumType.STRING)
    private CabStatus status;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "driver_id")
    private Drivers driver;

    @OneToOne(mappedBy = "cabs", cascade = CascadeType.ALL)
    private Booking booking;


}
