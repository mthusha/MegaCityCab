package com.megacitycab.model.dtos;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CustomerDto {

    private Long id;
    private String name;
    private String address;
    private String phone;
    private String email;
    private String nic;
    private String username;
    private String password;
}
