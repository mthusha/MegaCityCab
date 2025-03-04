package com.megacitycab.model.dtos;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CabsDto {

    private Long id;
    private String name;
    private String model;
    private Integer numberOfSeats;
    private Double farePerKm;
    private Double timePerKm;
    private String status;
    private Long driverId;
    private String driver;
    private String imagePath;
}
