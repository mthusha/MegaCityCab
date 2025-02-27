package com.megacitycab.services;
import com.megacitycab.model.Cabs;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

public interface CabService {

    /**
     * Retrieves available cabs and sends them as a JSON response
     * @param request HTTP request potentially containing dateTime parameter
     * @param response HTTP response to send the cab list
     * @throws IOException if there's an error writing the response
     */
    void getAvailableCabs(HttpServletRequest request, HttpServletResponse response) throws IOException;

}
