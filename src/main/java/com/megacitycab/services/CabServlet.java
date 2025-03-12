package com.megacitycab.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.megacitycab.dao.CabDao;
import com.megacitycab.enums.CabStatus;
import com.megacitycab.model.Cabs;
import com.megacitycab.model.Customer;
import com.megacitycab.model.dtos.CabsDto;
import com.megacitycab.model.dtos.CustomerDto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet({"/user/cabs",
        "/admin/cabs",
        "/cabs",
        "/admin/cabs/delete",
        "/admin/cabs/update"}
)
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50)
public class CabServlet extends HttpServlet implements CabService {

    private final CabDao cabDAO = CabDao.getInstance();
    private static final String UPLOAD_DIR = "resource/img/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/user/cabs".equals(path)) {
            getAvailableCabs(request, response);
        }
        else if ("/admin/cabs".equals(path)) {
            getAllCabs(request, response);
        }

    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if("/admin/cabs".equals(path)){
            createCab(request,response);
        }
        if ("/admin/cabs/update".equals(path)){
            updateStatus(request,response);
        }

    }
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String path = request.getServletPath();
        if("/admin/cabs/delete".equals(path)) {
            deleteCaps(request, response);
        }
    }

    @Override
    public void createCab(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

        File uploadFolder = new File(uploadFilePath);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        Cabs cab = new Cabs();
        try {
            cab.setName(request.getParameter("name"));
            cab.setModel(request.getParameter("model"));
            cab.setNumberOfSeats(Integer.parseInt(request.getParameter("numberOfSeats")));
            cab.setFARE_PER_KM(Double.parseDouble(request.getParameter("farePerKm")));
            cab.setTIME_PER_KM(Double.parseDouble(request.getParameter("timePerKm")));
            cab.setStatus(CabStatus.valueOf(request.getParameter("status")));

            // Handle image upload
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = extractFileName(filePart);
                String filePath = "/Gradle___com_MegaCityCab___MegaCityCab_1_0_SNAPSHOT_war/"+ UPLOAD_DIR + fileName;
                filePart.write(uploadFilePath + File.separator + fileName);
                cab.setImagePath(filePath);
            }

            cabDAO.save(cab);
            response.sendRedirect("/admin/cabs");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format in input fields");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid status value");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    public void getAvailableCabs(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            LocalDateTime dateTime = parseDateTime(request);
            List<Cabs> cabList = cabDAO.getAvailableCabs(dateTime);
            String json = convertCabsToJson(cabList);
            response.getWriter().write(json);
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid dateTime format. Use ISO format (e.g., 2025-02-24T14:30:00)\"}");
        }
    }
    @Override
    public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long capsId = Long.parseLong(request.getParameter("id"));
        String status = request.getParameter("status");
        cabDAO.updateStatus(capsId, status);
        // email send
        response.getWriter().write("Success");
    }

    @Override
    public void getAllCabs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Cabs> cabDAOAll = cabDAO.findAll();
        List<CabsDto> cabs = cabDAOAll.stream().map(this::convertToDto).collect(Collectors.toList());
        request.setAttribute("cabs", cabs);
        request.getRequestDispatcher("/admin/pages/caps_manage.jsp").forward(request, response);
    }

    @Override
    public void deleteCaps(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                Long capsId = Long.parseLong(idParam);
                cabDAO.delete(capsId);
                response.getWriter().write("Success");
            } catch (NumberFormatException e) {
                response.getWriter().write("Invalid caps ID format");
            }
        } else {
            response.getWriter().write("Caps ID is required");
        }
    }

    private CabsDto convertToDto(Cabs cabs) {
        CabsDto dto = new CabsDto();
        dto.setId(cabs.getId());
        dto.setName(cabs.getName());
        dto.setModel(cabs.getModel());
        dto.setNumberOfSeats(cabs.getNumberOfSeats());
        dto.setStatus(cabs.getStatus().toString());
        dto.setDriver(cabs.getDriver() != null ? cabs.getDriver().getName() : "Not driver allocated");
        dto.setFarePerKm(cabs.getFARE_PER_KM());
        dto.setTimePerKm(cabs.getTIME_PER_KM());
        dto.setImagePath(cabs.getImagePath());
        return dto;
    }
    public LocalDateTime parseDateTime(HttpServletRequest request) throws IllegalArgumentException {
        String dateTimeParam = request.getParameter("dateTime");
        if (dateTimeParam != null && !dateTimeParam.isEmpty()) {
            try {
                return LocalDateTime.parse(dateTimeParam);
            } catch (DateTimeParseException e) {
                throw new IllegalArgumentException("Invalid dateTime format", e);
            }
        }
        return null;
    }

    public String convertCabsToJson(List<Cabs> cabList) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writeValueAsString(cabList);
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return System.currentTimeMillis() + "_" + s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}