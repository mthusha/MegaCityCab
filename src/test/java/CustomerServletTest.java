import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.megacitycab.auth.Users;
import com.megacitycab.config.JwtTokenProvider;
import com.megacitycab.dao.CustomerDao;
import com.megacitycab.model.Customer;
import com.megacitycab.model.dtos.CustomerDto;
import com.megacitycab.services.CustomerServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;

class CustomerServletTest {

    @InjectMocks
    private CustomerServlet customerServlet;

    @Mock
    private CustomerDao customerDao;

    @Mock
    private JwtTokenProvider jwtTokenProvider;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private ObjectMapper objectMapper;

    @Captor
    private ArgumentCaptor<Customer> customerCaptor;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }
    @Test
    void testCreateCustomer_Success() throws IOException {
        CustomerDto mockDto = new CustomerDto();
        mockDto.setName("John Doe");
        mockDto.setAddress("123 Main St");
        mockDto.setPhone("1234567890");
        mockDto.setEmail("john@example.com");
        mockDto.setNic("987654321V");
        mockDto.setUsername("johndoe");
        mockDto.setPassword("securePass");

        String requestBody = new ObjectMapper().writeValueAsString(mockDto);
        when(request.getReader()).thenReturn(new BufferedReader(new StringReader(requestBody)));
        when(customerDao.findCustomerByUsername("johndoe")).thenReturn(null);
        when(jwtTokenProvider.generateToken("johndoe")).thenReturn("mocked-jwt-token");
        when(request.getSession()).thenReturn(session);
        customerServlet.createCustomer(request, response);
        verify(customerDao, times(1)).save(customerCaptor.capture());
        Customer savedCustomer = customerCaptor.getValue();
        assertEquals("John Doe", savedCustomer.getName());
        assertEquals("123 Main St", savedCustomer.getAddress());
        verify(response, times(1)).addCookie(argThat(cookie ->
                cookie.getName().equals("token") && cookie.getValue().equals("mocked-jwt-token")
        ));
        verify(session, times(1)).setAttribute(eq("loggedInUser"), any(Users.class));
        verify(response, times(1)).setStatus(HttpServletResponse.SC_CREATED);
    }
    @Test
    void testCreateCustomer_UsernameAlreadyExists() throws IOException {
        when(request.getReader()).thenReturn(new BufferedReader(new StringReader(
                "{ \"username\": \"johndoe\", \"password\": \"password123\" }"
        )));
        when(customerDao.findCustomerByUsername("johndoe")).thenReturn(new Customer());
        customerServlet.createCustomer(request, response);
        verify(response).sendError(HttpServletResponse.SC_BAD_REQUEST, "Username already exists");
        verify(customerDao, never()).save(any());
    }
    @Test
    void testCreateCustomer_InvalidJson() throws IOException {
        when(request.getReader()).thenReturn(new BufferedReader(new StringReader("{ invalid json }")));
        customerServlet.createCustomer(request, response);
        verify(response).sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating customer");
    }
}
