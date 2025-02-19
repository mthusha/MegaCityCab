package com.megacitycab.auth;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.megacitycab.model.Booking;
import com.megacitycab.model.Customer;
import com.megacitycab.model.Drivers;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
public class Users {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String password;
    private String roles;

    @OneToOne(mappedBy = "user",cascade = CascadeType.ALL)
    private Drivers driver;

    @OneToOne(mappedBy = "user",cascade = CascadeType.ALL)
    private Customer customer;
}
