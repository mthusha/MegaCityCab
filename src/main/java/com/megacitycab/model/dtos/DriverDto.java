package com.megacitycab.model.dtos;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DriverDto {

    private Long id;
    private String name;
    private String email;
    private String phone;
    private String address;
    private String status ;
    private String user;
    public String cabs;

}
