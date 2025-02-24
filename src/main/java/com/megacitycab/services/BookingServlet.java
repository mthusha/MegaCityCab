package com.megacitycab.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.megacitycab.dao.BookingDao;
import com.megacitycab.dao.CabDao;
import com.megacitycab.dao.CustomerDoa;
import com.megacitycab.enums.BookingStatus;
import com.megacitycab.enums.CabStatus;
import com.megacitycab.model.Booking;
import com.megacitycab.model.Cabs;
import com.megacitycab.model.Customer;
import com.megacitycab.model.dtos.BookingDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/user/booking")
public class BookingServlet extends HttpServlet{
    private final BookingDao bookingDAO = BookingDao.getInstance();
    private final CabDao cabDAO = CabDao.getInstance();
    private final CustomerDoa customerDoa = CustomerDoa.getInstance();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            BookingDto bookingDto = parseRequest(request);

            Cabs cab = cabDAO.findCabById(bookingDto.getCabId());
            if (cab == null || cab.getStatus() != CabStatus.AVAILABLE) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Cab is not available");
                return;
            }

            double duration = bookingDto.getDistance() * cab.getTIME_PER_KM();
            double fareAmount = bookingDto.getDistance() * cab.getFARE_PER_KM();

            Booking booking = new Booking();
            booking.setToDestination(bookingDto.getToDestination());
            booking.setFromDestination(bookingDto.getFromDestination());
            booking.setNumberOfPassengers(bookingDto.getNumberOfPassengers());
            booking.setDistance(bookingDto.getDistance());
            booking.setDuration(duration);
            booking.setFareAmount(fareAmount);
            booking.setBookingDateTime(LocalDateTime.now());
            booking.setStatus(BookingStatus.PENDING);

            Customer customer = customerDoa.findCustomerById(bookingDto.getCustomerId());
            booking.setCustomer(customer);
            booking.setCabs(cab);

            bookingDAO.save(booking);
            response.setStatus(HttpServletResponse.SC_CREATED);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing booking");
        }
    }



    private BookingDto parseRequest(HttpServletRequest request) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            return objectMapper.readValue(request.getInputStream(), BookingDto.class);
        } catch (IOException e) {
            throw new RuntimeException("Error parsing request body: " + e.getMessage(), e);
        }
    }


}
