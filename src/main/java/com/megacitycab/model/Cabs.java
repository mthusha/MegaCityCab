package com.megacitycab.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.megacitycab.enums.CabStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
public class Cabs {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String model;
    private Integer numberOfSeats;
    private Double FARE_PER_KM;
    private Double TIME_PER_KM;

    @Enumerated(EnumType.STRING)
    private CabStatus status;
    @Column(name = "image_path")
    private String imagePath;

    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "driver_id")
    @JsonManagedReference
    private Drivers driver;

    @OneToMany(mappedBy = "cabs", cascade = CascadeType.ALL)
    @JsonIgnore
    @JsonManagedReference
    private List<Booking> bookings = new ArrayList<>();


}
