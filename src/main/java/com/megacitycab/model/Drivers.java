package com.megacitycab.model;

import com.megacitycab.enums.DriverStatus;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
public class Drivers {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;
    private String phone;
    private String address;

    @Enumerated(EnumType.STRING)
    private DriverStatus status ;

    @OneToOne(mappedBy = "driver", cascade = CascadeType.ALL)
    public Cabs cabs;
}
