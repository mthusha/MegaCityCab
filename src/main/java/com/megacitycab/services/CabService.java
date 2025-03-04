package com.megacitycab.services;
import com.megacitycab.model.Cabs;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

public interface CabService {

    void getAvailableCabs(HttpServletRequest request, HttpServletResponse response) throws IOException;

    void createCab(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
    void getAllCabs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
    void deleteCaps(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
    void updateStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
}
