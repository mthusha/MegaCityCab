package com.megacitycab.auth;

import com.megacitycab.config.JwtTokenProvider;
import com.megacitycab.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/login")
public class AuthService  extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        Users user = userDAO.findByUsername(username);

        if (user != null && user.getPassword().equals(password)) {
            String token = JwtTokenProvider.getInstance().generateToken(username);
            Cookie jwtCookie = new Cookie("token", token);
            jwtCookie.setHttpOnly(true);
            jwtCookie.setPath("/");
            response.addCookie(jwtCookie);
            request.getSession().setAttribute("loggedInUser", user);

            if(user.getRoles().equals("admin")){
                response.sendRedirect("admin/master.jsp");
            }
            else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        }else {
            response.sendRedirect("login.jsp?error=Invalid username or password");
        }
    }
}
