package com.megacitycab.services;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public interface BillingService {
    void createBill(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
    void getAllBills(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
    void deleteBill(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
    void updateBill(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException;
}
