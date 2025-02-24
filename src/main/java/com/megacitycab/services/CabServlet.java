package com.megacitycab.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.megacitycab.dao.CabDao;
import com.megacitycab.model.Cabs;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/user/cabs")
public class CabServlet extends HttpServlet {

    private final CabDao cabDAO = CabDao.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        LocalDateTime dateTime = null;
        String dateTimeParam = request.getParameter("dateTime");
        if (dateTimeParam != null && !dateTimeParam.isEmpty()) {
            try {
                dateTime = LocalDateTime.parse(dateTimeParam);
            } catch (DateTimeParseException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid dateTime format. Use ISO format (e.g., 2025-02-24T14:30:00)\"}");
                return;
            }
        }

        List<Cabs> cabList = cabDAO.getAvailableCabs(dateTime);
        ObjectMapper objectMapper = new ObjectMapper();
        String json = objectMapper.writeValueAsString(cabList);

        response.getWriter().write(json);
    }
}
