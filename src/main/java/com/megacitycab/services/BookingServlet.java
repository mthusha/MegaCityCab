package com.megacitycab.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.kafka.common.serialization.StringSerializer;
import com.megacitycab.config.EmailService;
import com.megacitycab.config.JwtTokenProvider;
import com.megacitycab.dao.BookingDao;
import com.megacitycab.dao.CabDao;
import com.megacitycab.dao.CustomerDao;
import com.megacitycab.enums.BookingStatus;
import com.megacitycab.enums.CabStatus;
import com.megacitycab.model.Booking;
import com.megacitycab.model.Cabs;
import com.megacitycab.model.Customer;
import com.megacitycab.model.dtos.BookingDto;
import com.megacitycab.model.dtos.BookingGetDto;
import com.megacitycab.notification.BookingNotification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;

@WebServlet({"/admin/booking", "/user/booking","/admin/booking-status","/admin/booking/delete"})
public class BookingServlet extends HttpServlet implements BookingService {
    private final BookingDao bookingDAO = BookingDao.getInstance();
    private final CabDao cabDAO = CabDao.getInstance();
    private final CustomerDao customerDao = CustomerDao.getInstance();
    private final EmailService emailService = new EmailService();
    private static final ExecutorService executor = Executors.newFixedThreadPool(5);
    private KafkaProducer<String, String> kafkaProducer;
    private final ObjectMapper objectMapper = new ObjectMapper();
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/user/booking".equals(path)) {
            createBooking(request, response);
        }
        else if("/admin/booking-status".equals(path)) {
            updateStatus(request, response);
        }
        else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "POST not allowed on this path.");
        }
    }
    @Override
    public void init() throws ServletException {
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        kafkaProducer = new KafkaProducer<>(props);
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/admin/booking".equals(path)) {
            getAllBookings(request, response);
        } else if ("/admin/booking/delete".equals(path)) {
            deleteBooking(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "GET not allowed on this path.");
        }
    }

    @Override
    public void createBooking(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            BookingDto bookingDto = parseBookingRequest(request);
            Booking booking = processBooking(bookingDto, request);
            bookingDAO.save(booking);
            BookingNotification notification = new BookingNotification(
                    "BOOKING_CREATED",
                    booking.getId(),
                    booking.getCabs().getName(),
                    booking.getCustomer().getName(),
                    "Date Time Not Available"
            );

            // Send to Kafka topic
            String jsonNotification = objectMapper.writeValueAsString(notification);
            ProducerRecord<String, String> record = new ProducerRecord<>("booking-events", jsonNotification);
            kafkaProducer.send(record, (metadata, exception) -> {
                if (exception != null) {
                    System.err.println("Error sending to Kafka: " + exception.getMessage());
                } else {
                    System.out.println("Message sent to Kafka: " + metadata);
                }
            });

            response.setStatus(HttpServletResponse.SC_CREATED);
        } catch (IllegalStateException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing booking");
        }
    }
    @Override
    public void getAllBookings(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Booking> bookings = bookingDAO.findAll();
        List<BookingGetDto> bookingDtoList = bookings.stream().map(this::convertToDto).collect(Collectors.toList());
        request.setAttribute("bookings", bookingDtoList);
        request.getRequestDispatcher("/admin/pages/booking_mange.jsp").forward(request, response);

    }

    @Override
    public void updateStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long bookingId = Long.parseLong(request.getParameter("id"));
        String status = request.getParameter("status");
        bookingDAO.updateStatus(bookingId, status);
        // email send
//        String customerEmail = customerDao.getCustomerEmailByBookingId(bookingId);
//        if (customerEmail != null) {
//            executor.submit(() -> emailService.sendBookingStatusEmail(customerEmail, bookingId, status));
//        }
        response.getWriter().write("Success");
    }

    public void deleteBooking(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                Long bookingId = Long.parseLong(idParam);
                bookingDAO.deleteBooking(bookingId);
                response.getWriter().write("Success");
            } catch (NumberFormatException e) {
                response.getWriter().write("Invalid booking ID format");
            }
        } else {
            response.getWriter().write("Booking ID is required");
        }
    }

    private BookingGetDto convertToDto(Booking booking) {
        BookingGetDto dto = new BookingGetDto();
        dto.setId(booking.getId());
        dto.setToDestination(booking.getToDestination());
        dto.setFromDestination(booking.getFromDestination());
        dto.setNumberOfPassengers(booking.getNumberOfPassengers());
        dto.setBookingDateTime(booking.getBookingDateTime().toString());
        dto.setDistance(booking.getDistance());
        dto.setDuration(booking.getDuration());
        dto.setBookingStatus(booking.getStatus().name());
        dto.setCustomerName(booking.getCustomer() != null ? booking.getCustomer().getName() : null);
        dto.setCabModelName(booking.getCabs() != null ? booking.getCabs().getName() +" "+ booking.getCabs().getModel(): null);
        dto.setBillId(booking.getBill() != null ? booking.getBill().getId() : null);
        return dto;
    }

    //

    public BookingDto parseBookingRequest(HttpServletRequest request) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            return objectMapper.readValue(request.getInputStream(), BookingDto.class);
        } catch (IOException e) {
            throw new RuntimeException("Error parsing request body: " + e.getMessage(), e);
        }
    }

    public Booking processBooking(BookingDto bookingDto, HttpServletRequest request) throws IllegalStateException {
        Cabs cab = cabDAO.findCabById(bookingDto.getCabId());
        if (cab == null || cab.getStatus() != CabStatus.AVAILABLE) {
            throw new IllegalStateException("Cab is not available");
        }

        String token = JwtTokenProvider.getTokenFromCookies(request);
        if (token == null) {
            throw new IllegalStateException("Missing or invalid token in cookies");
        }

        JwtTokenProvider jwtTokenProvider = JwtTokenProvider.getInstance();
        String username = jwtTokenProvider.getUsernameFromToken(token);
        if (username == null) {
            throw new IllegalStateException("Invalid token");
        }

        Customer customer = customerDao.findCustomerByUsername(username);
        if (customer == null) {
            throw new IllegalStateException("Customer with username " + username + " not found");
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

        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        LocalDateTime bookingDateTime = LocalDateTime.parse(bookingDto.getBookingDateTime(), formatter);
        booking.setBookingDateTime(bookingDateTime);

        booking.setStatus(BookingStatus.PENDING);
        booking.setCustomer(customer);
        booking.setCabs(cab);

        return booking;
    }
}