package com.megacitycab.services;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.megacitycab.auth.Users;
import com.megacitycab.config.JwtTokenProvider;
import com.megacitycab.dao.CustomerDao;
import com.megacitycab.model.Customer;
import com.megacitycab.model.dtos.CustomerDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet({
        "/admin/customers",
        "/customer",
        "/admin/customer/delete",
        "/user/customer/update"
})
public class CustomerServlet extends HttpServlet implements CustomerService {
    private final CustomerDao customerDao = CustomerDao.getInstance();
    private final JwtTokenProvider jwtTokenProvider = JwtTokenProvider.getInstance();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/customer".equals(path)) {
            createCustomer(request, response);
        } else if ("/user/customer/update".equals(path)) {
//            updateCustomer(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "POST not allowed on this path.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/customers".equals(path)) {
            getAllCustomers(request, response);
        } else if ("/admin/customer/delete".equals(path)) {
            deleteCustomer(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "GET not allowed on this path.");
        }
    }

    @Override
    public void createCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            CustomerDto customerDto = parseCustomerRequest(request);
            Customer customer = processCustomer(customerDto);
            customerDao.save(customer);

            String token = JwtTokenProvider.getInstance().generateToken(customerDto.getUsername());
            Cookie jwtCookie = new Cookie("token", token);
            jwtCookie.setHttpOnly(true);
            jwtCookie.setPath("/");
            response.addCookie(jwtCookie);

            Users user = customer.getUser();
            request.getSession().setAttribute("loggedInUser", user);

            response.setStatus(HttpServletResponse.SC_CREATED);
            response.setContentType("application/json");
//            response.getWriter().write("{\"redirect\":\"" + request.getContextPath() + "/\"}");
            response.setStatus(HttpServletResponse.SC_CREATED);
            response.getWriter().write("Customer created successfully");
        } catch (IllegalStateException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating customer");
        }
    }
    @Override
    public void getAllCustomers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Customer> customers = customerDao.findAll();
        List<CustomerDto> customerDtoList = customers.stream().map(this::convertToDto).collect(Collectors.toList());
        request.setAttribute("customers", customerDtoList);
        request.getRequestDispatcher("/admin/pages/customer_manage.jsp").forward(request, response);
    }
    @Override
    public void deleteCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                Long customerId = Long.parseLong(idParam);
                customerDao.delete(customerId);
                response.getWriter().write("Customer deleted successfully");
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid customer ID format");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Customer ID is required");
        }
    }

    private CustomerDto convertToDto(Customer customer) {
        CustomerDto dto = new CustomerDto();
        dto.setId(customer.getId());
        dto.setName(customer.getName());
        dto.setAddress(customer.getAddress());
        dto.setPhone(customer.getPhone());
        dto.setEmail(customer.getEmail());
        dto.setNic(customer.getNic());
        dto.setUsername(customer.getUser() != null ? customer.getUser().getUsername() : null);
        return dto;
    }

    private CustomerDto parseCustomerRequest(HttpServletRequest request) throws IOException {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            return objectMapper.readValue(request.getInputStream(), CustomerDto.class);
        } catch (IOException e) {
            throw new IOException("Error parsing customer request: " + e.getMessage(), e);
        }
    }

    private Customer processCustomer(CustomerDto customerDto) throws IllegalStateException {
        if (customerDao.findCustomerByUsername(customerDto.getUsername()) != null) {
            throw new IllegalStateException("Username already exists");
        }

        Customer customer = new Customer();
        customer.setName(customerDto.getName());
        customer.setAddress(customerDto.getAddress());
        customer.setPhone(customerDto.getPhone());
        customer.setEmail(customerDto.getEmail());
        customer.setNic(customerDto.getNic());

        Users user = new Users();
        user.setUsername(customerDto.getUsername());
        user.setPassword(BCrypt.hashpw(customerDto.getPassword(), BCrypt.gensalt()));
        user.setRoles("admin");
        user.setCustomer(customer);

        customer.setUser(user);
        return customer;
    }
}
