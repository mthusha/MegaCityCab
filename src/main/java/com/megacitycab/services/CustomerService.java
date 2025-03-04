package com.megacitycab.services;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public interface CustomerService {
    void createCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException;
    void getAllCustomers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
    void deleteCustomer(HttpServletRequest request, HttpServletResponse response) throws IOException;
}
