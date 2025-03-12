package com.megacitycab.services;

import com.megacitycab.dao.BillDao;
import com.megacitycab.model.Bill;
import com.megacitycab.model.dtos.BillDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet({
        "/admin/bills",
        "/bills",
        "/admin/bills/delete",
        "/admin/bills/update"
})
public class BillingServlet extends HttpServlet implements BillingService {
    private final BillDao billDAO = BillDao.getInstance();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/bills".equals(path)) {
            getAllBills(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/bills".equals(path)) {
//            createBill(request, response);
        }
        if ("/admin/bills/update".equals(path)) {
//            updateBill(request, response);
        }
    }

    @Override
    public void createBill(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Bill bill = new Bill();
        try {
            bill.setAmount(Double.parseDouble(request.getParameter("amount")));
            bill.setTax(Double.parseDouble(request.getParameter("tax")));
            bill.setDiscountAmount(Double.parseDouble(request.getParameter("discountAmount")));
            bill.setBillingDate(parseDateTime(request.getParameter("billingDate")));

            billDAO.save(bill);
            response.sendRedirect("/admin/bills");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format in input fields");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    public void getAllBills(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Bill> billDAOAll = billDAO.findAll();
        List<BillDto> bills = billDAOAll.stream().map(this::convertToDto).collect(Collectors.toList());
        request.setAttribute("bills", bills);
        request.getRequestDispatcher("/admin/pages/bill_manage.jsp").forward(request, response);
    }

    @Override
    public void deleteBill(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    public void updateBill(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            Bill bill = billDAO.findById(id);
            if (bill != null) {
                bill.setAmount(Double.parseDouble(request.getParameter("amount")));
                bill.setTax(Double.parseDouble(request.getParameter("tax")));
                bill.setDiscountAmount(Double.parseDouble(request.getParameter("discountAmount")));
                billDAO.update(bill);
                response.getWriter().write("Success");
            } else {
                response.getWriter().write("Bill not found");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("Invalid number format");
        }
    }

    private BillDto convertToDto(Bill bill) {
        BillDto dto = new BillDto();
        dto.setId(bill.getId());
        dto.setAmount(bill.getAmount());
        dto.setTax(bill.getTax());
        dto.setDiscountAmount(bill.getDiscountAmount());
        dto.setBillingDate(bill.getBillingDate() != null ? bill.getBillingDate().toString() : null);
        dto.setBookingId(bill.getBooking() != null && bill.getBooking().getId() != null ? bill.getBooking().getId() : 1L);
        return dto;
    }

    private LocalDateTime parseDateTime(String dateTimeStr) throws IllegalArgumentException {
        if (dateTimeStr != null && !dateTimeStr.isEmpty()) {
            try {
                return LocalDateTime.parse(dateTimeStr);
            } catch (DateTimeParseException e) {
                throw new IllegalArgumentException("Invalid dateTime format", e);
            }
        }
        return LocalDateTime.now();
    }
}
