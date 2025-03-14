import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.megacitycab.dao.CabDao;
import com.megacitycab.enums.CabStatus;
import com.megacitycab.model.Cabs;
import com.megacitycab.model.dtos.CabsDto;
import com.megacitycab.services.CabServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import java.io.*;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

class CabServletTest {

    @InjectMocks
    private CabServlet cabServlet;

    @Mock
    private CabDao cabDAO;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private Part filePart;

    @Captor
    private ArgumentCaptor<Cabs> cabCaptor;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }
    @Test
    void testCreateCab_Success() throws IOException, ServletException {
        when(request.getParameter("name")).thenReturn("Toyota Prius");
        when(request.getParameter("model")).thenReturn("Prius 2020");
        when(request.getParameter("numberOfSeats")).thenReturn("4");
        when(request.getParameter("farePerKm")).thenReturn("15.0");
        when(request.getParameter("timePerKm")).thenReturn("5.0");
        when(request.getParameter("status")).thenReturn("AVAILABLE");
        when(request.getPart("image")).thenReturn(filePart);
        when(filePart.getSize()).thenReturn(100L);
        when(filePart.getHeader("content-disposition")).thenReturn("form-data; name=\"image\"; filename=\"cab.jpg\"");
        cabServlet.createCab(request, response);
        verify(cabDAO, times(1)).save(cabCaptor.capture());
        Cabs savedCab = cabCaptor.getValue();
        assertEquals("Toyota Prius", savedCab.getName());
        assertEquals(4, savedCab.getNumberOfSeats());
        assertEquals(CabStatus.AVAILABLE, savedCab.getStatus());
        verify(response, times(1)).sendRedirect("/admin/cabs");
    }
    @Test
    void testCreateCab_InvalidNumberFormat() throws IOException, ServletException {
        when(request.getParameter("numberOfSeats")).thenReturn("invalid");

        cabServlet.createCab(request, response);

        verify(request).setAttribute(eq("error"), contains("Invalid number format"));
        verify(request).getRequestDispatcher("/error.jsp");
    }
    @Test
    void testGetAvailableCabs_Success() throws IOException {
        LocalDateTime mockDate = LocalDateTime.now();
        List<Cabs> mockCabs = Arrays.asList(new Cabs("Toyota", "Camry", 4, 20.0, 10.0, CabStatus.AVAILABLE, null, "/img/car.jpg"));

        when(request.getParameter("dateTime")).thenReturn(mockDate.toString());
        when(cabDAO.getAvailableCabs(mockDate)).thenReturn(mockCabs);

        StringWriter stringWriter = new StringWriter();
        PrintWriter writer = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(writer);

        cabServlet.getAvailableCabs(request, response);

        writer.flush();
        assertTrue(stringWriter.toString().contains("Toyota"));
    }
    @Test
    void testDeleteCab_InvalidId() throws IOException, ServletException {
        when(request.getParameter("id")).thenReturn("invalid");

        cabServlet.deleteCaps(request, response);

        verify(response).getWriter().write("Invalid caps ID format");
    }
}
