package com.megacitycab.services;

import com.megacitycab.model.Booking;
import com.megacitycab.model.dtos.BookingDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface BookingService {

    /**
     * Handles the creation of a new booking
     * @param request HTTP request containing booking details
     * @param response HTTP response to send back to client
     * @throws IOException if there's an error handling the request/response
     */
    void createBooking(HttpServletRequest request, HttpServletResponse response) throws IOException;

    void getAllBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;

    void updateStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;

}
