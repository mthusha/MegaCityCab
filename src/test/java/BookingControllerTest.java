import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.megacitycab.dao.BookingDao;
import com.megacitycab.model.Booking;
import com.megacitycab.services.BookingServlet;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import java.io.IOException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;

class BookingControllerTest {

    @InjectMocks
    private BookingServlet bookingController;

    @Mock
    private BookingDao bookingDAO;

    @Mock
    private KafkaProducer<String, String> kafkaProducer;

    @Mock
    private ObjectMapper objectMapper;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private PrintWriter writer;

    @BeforeEach
    void setUp() throws IOException {
        MockitoAnnotations.openMocks(this);
        when(response.getWriter()).thenReturn(writer);
    }
    @Test
    void testCreateBooking_Success() throws IOException {
        when(request.getReader()).thenReturn(new java.io.BufferedReader(new java.io.StringReader(
                "{ \"customerId\": 1, \"cabId\": 2, \"pickupTime\": \"2025-03-14T10:00:00\" }"
        )));
        bookingController.createBooking(request, response);
        verify(bookingDAO, times(1)).save(any(Booking.class));
        ArgumentCaptor<ProducerRecord<String, String>> kafkaCaptor = ArgumentCaptor.forClass(ProducerRecord.class);
        verify(kafkaProducer, times(1)).send(kafkaCaptor.capture(), any());
        String sentMessage = kafkaCaptor.getValue().value();
        assertTrue(sentMessage.contains("\"BOOKING_CREATED\""));
        verify(response).setStatus(HttpServletResponse.SC_CREATED);
    }

    @Test
    void testCreateBooking_InvalidRequest() throws IOException {
        when(request.getReader()).thenReturn(new java.io.BufferedReader(new java.io.StringReader(
                "{ \"customerId\": \"\", \"cabId\": 2, \"pickupTime\": \"\" }"
        )));
        bookingController.createBooking(request, response);
        verify(response).sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking data");
    }
    @Test
    void testCreateBooking_KafkaFailure() throws IOException {
        when(request.getReader()).thenReturn(new java.io.BufferedReader(new java.io.StringReader(
                "{ \"customerId\": 1, \"cabId\": 2, \"pickupTime\": \"2025-03-14T10:00:00\" }"
        )));

        doThrow(new RuntimeException("Kafka error")).when(kafkaProducer).send(any(), any());
        bookingController.createBooking(request, response);
        verify(response).setStatus(HttpServletResponse.SC_CREATED);
        verify(kafkaProducer, times(1)).send(any(), any());
    }
}
