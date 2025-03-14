//package com.megacitycab.services;

import com.megacitycab.dao.CabDao;
import com.megacitycab.dao.DriverDao;
import com.megacitycab.enums.DriverStatus;
import com.megacitycab.model.Drivers;
import com.megacitycab.services.DriverServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import java.io.PrintWriter;
import java.io.StringWriter;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class DriverServletTest {
    private DriverServlet driverServlet;

    @Mock
    private DriverDao driverDao;
    @Mock
    private CabDao cabDao;
    @Mock
    private HttpServletRequest request;
    @Mock
    private HttpServletResponse response;

    private StringWriter responseWriter;

    @BeforeEach
    void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        driverServlet = new DriverServlet();

        responseWriter = new StringWriter();
        PrintWriter printWriter = new PrintWriter(responseWriter);
        when(response.getWriter()).thenReturn(printWriter);
    }

    @Test
    void testCreateDriver() throws Exception {
        when(request.getParameter("name")).thenReturn("John Doe");
        when(request.getParameter("email")).thenReturn("john.doe@example.com");
        when(request.getParameter("phone")).thenReturn("1234567890");
        when(request.getParameter("address")).thenReturn("123 Main St");
        when(request.getParameter("status")).thenReturn("AVAILABLE");
        when(request.getParameter("username")).thenReturn("johndoe");
        when(request.getParameter("password")).thenReturn("password123");

        driverServlet.creatUser(request, response);

        verify(driverDao, times(1)).save(any(Drivers.class));
    }

    @Test
    void testUpdateDriverStatus() throws Exception {
        when(request.getParameter("id")).thenReturn("1");
        when(request.getParameter("status")).thenReturn("ON_DUTY");

        driverServlet.doPost(request, response);

        verify(driverDao, times(1)).updateStatus(1L, "ON_DUTY");
        assertEquals("Success", responseWriter.toString().trim());
    }

    @Test
    void testAssignDriverSuccess() throws Exception {
        when(request.getParameter("cabId")).thenReturn("1");
        when(request.getParameter("driverId")).thenReturn("2");

        Drivers driver = new Drivers();
        driver.setStatus(DriverStatus.ON_DUTY);
        when(driverDao.findById(2L)).thenReturn(driver);

        driverServlet.assignDriver(request, response);

        verify(cabDao, times(1)).assignDriver(1L, 2L);
        assertEquals("Vehicle assigned successfully", responseWriter.toString().trim());
    }

    @Test
    void testAssignDriverFailureNotOnDuty() throws Exception {
        when(request.getParameter("cabId")).thenReturn("1");
        when(request.getParameter("driverId")).thenReturn("2");

        Drivers driver = new Drivers();
        driver.setStatus(DriverStatus.OFF_DUTY);
        when(driverDao.findById(2L)).thenReturn(driver);

        driverServlet.assignDriver(request, response);

        verify(cabDao, never()).assignDriver(anyLong(), anyLong());
        assertEquals("Driver must be ON_DUTY to assign a vehicle", responseWriter.toString().trim());
    }

    @Test
    void testDeleteDriver() throws Exception {
        when(request.getParameter("id")).thenReturn("3");

        driverServlet.doDelete(request, response);

        verify(driverDao, times(1)).delete(3L);
        assertEquals("Success", responseWriter.toString().trim());
    }
}