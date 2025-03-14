package com.megacitycab.services;


import com.megacitycab.auth.Users;
import com.megacitycab.dao.BookingDao;
import com.megacitycab.dao.CabDao;
import com.megacitycab.dao.DriverDao;
import com.megacitycab.dao.UserDAO;
import com.megacitycab.enums.DriverStatus;
import com.megacitycab.model.Booking;
import com.megacitycab.model.Cabs;
import com.megacitycab.model.Drivers;
import com.megacitycab.model.dtos.CabsDto;
import com.megacitycab.model.dtos.DriverDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet({
        "/admin/drivers",
        "/admin/drivers/delete",
        "/admin/drivers/update",
        "/admin/cabs/assign-driver",
        "/driver/dashboard"
})
public class DriverServlet extends HttpServlet {
    private final DriverDao driverDao = DriverDao.getInstance();
    private final CabDao cabDao = CabDao.getInstance();
    private final UserDAO userDao = UserDAO.getInstance();
    private final BookingDao bookingDao = BookingDao.getInstance();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/drivers".equals(path)) {
            getAllDrivers(request, response);

        }
        else if ("/driver/dashboard".equals(path)) {
            driverDashboard(request, response);
        }

    }
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/cabs/assign-driver".equals(path)) {
            assignDriver(request, response);
        } else if ("/admin/drivers/update".equals(path)) {
            Long driverId = Long.parseLong(request.getParameter("id"));
            String status = request.getParameter("status");
            driverDao.updateStatus(driverId, status);
            response.getWriter().write("Success");
        }
        else if ("/admin/drivers".equals(path)) {
            creatUser(request, response);
        }
        else if ("/admin/cabs/remove-driver".equals(path)) {
            removeDriver(request, response);
        }
    }

    public void driverDashboard(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        Long driverId = (Long) request.getSession().getAttribute("userId");

        if (driverId == null) {
            response.sendRedirect("/login");
            return;
        }

        Cabs allocatedCab = cabDao.findByDriverId(driverId);
        request.setAttribute("allocatedCab", allocatedCab);

        if (allocatedCab != null) {
            List<Booking> allBookings = bookingDao.findByCabId(allocatedCab.getId());
            LocalDateTime now = LocalDateTime.now();
            List<Booking> futureBookings = allBookings.stream()
                    .filter(booking -> booking.getBookingDateTime().isAfter(now))
                    .collect(Collectors.toList());

            request.setAttribute("futureBookings", futureBookings);
        }

        request.getRequestDispatcher("/driver/driver.jsp").forward(request, response);
    }


//    @Override
    public void getAllDrivers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Drivers> driversList = driverDao.findAll();
        List<DriverDto> drivers = driversList.stream().map(this::convertToDto).collect(Collectors.toList());
        request.setAttribute("drivers", drivers);
        request.getRequestDispatcher("/admin/pages/driver_manage.jsp").forward(request, response);
    }
    @Override
    public void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long driverId = Long.parseLong(request.getParameter("id"));
        driverDao.delete(driverId);
        response.getWriter().write("Success");
    }


    public void assignDriver(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long cabId = Long.parseLong(request.getParameter("cabId"));
            Long driverId = Long.parseLong(request.getParameter("driverId"));
            Drivers driver = driverDao.findById(driverId);
            if (driver == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Driver not found");
                return;
            }
            if (!"ON_DUTY".equals(driver.getStatus().toString())) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Driver must be ON_DUTY to assign a vehicle");
                return;
            }
            cabDao.assignDriver(cabId, driverId);
            response.getWriter().write("Vehicle assigned successfully");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid cab or driver ID");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        }
    }

    public void creatUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Drivers driver = new Drivers();
        Users user = new Users();

        try {
            user.setRoles("driver");
            user.setPassword(request.getParameter("password"));
            user.setUsername(request.getParameter("username"));
            driver.setName(request.getParameter("name"));
            driver.setEmail(request.getParameter("email"));
            driver.setEmail(request.getParameter("email"));
            driver.setPhone(request.getParameter("phone"));
            driver.setAddress(request.getParameter("address"));
            driver.setStatus(DriverStatus.valueOf(request.getParameter("status")));
            driver.setUser(user);
            driverDao.save(driver);
            userDao.save(user);
        } catch (Exception e) {
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
    private void removeDriver(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long driverId = Long.parseLong(request.getParameter("driverId"));
            cabDao.removeDriver(driverId);
            response.getWriter().write("Vehicle deallocated successfully");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid driver ID");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
    private DriverDto convertToDto(Drivers drivers) {
        DriverDto dto = new DriverDto();
        dto.setId(drivers.getId());
        dto.setName(drivers.getName());
        dto.setCabs(drivers.getCabs() != null ? drivers.getCabs().getName() + " "+ drivers.getCabs().getId() : "No Set");
        dto.setEmail(drivers.getEmail());
        dto.setStatus(drivers.getStatus().toString());
        dto.setPhone(drivers.getPhone());
        dto.setAddress(drivers.getAddress());
        dto.setUser(drivers.getUser().getUsername());
        return dto;
    }

}
