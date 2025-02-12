package com.megacitycab.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.megacitycab.auth.Users;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.awt.print.Book;

@Entity
@Getter
@Setter
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String address;
    private String phone;
    private String email;

    @JsonIgnore
    @OneToOne(mappedBy = "customer", cascade = CascadeType.ALL)
    private Users user;

    @OneToOne(mappedBy = "customer",cascade = CascadeType.ALL)
    private Booking booking;
}
