package com.megacitycab.auth;

import com.megacitycab.config.JwtTokenProvider;
import com.megacitycab.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/logout"})
public class AuthService  extends HttpServlet {
    private final UserDAO userDAO = UserDAO.getInstance();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else if ("/logout".equals(path)) {

            request.getSession().invalidate();

            Cookie jwtCookie = new Cookie("token", "");
            jwtCookie.setHttpOnly(true);
            jwtCookie.setPath("/");
            jwtCookie.setMaxAge(0);
            response.addCookie(jwtCookie);

            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            Users user = userDAO.findByUsername(username);

            if (user != null && BCrypt.checkpw(password, user.getPassword())) {
                String token = JwtTokenProvider.getInstance().generateToken(username);
                Cookie jwtCookie = new Cookie("token", token);
                jwtCookie.setHttpOnly(true);
                jwtCookie.setPath("/");
                response.addCookie(jwtCookie);
                request.getSession().setAttribute("loggedInUser", user);

                if (user.getRoles().equals("admin")) {
                    response.sendRedirect(request.getContextPath() + "/admin/master.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid username or password");
            }
        } else if ("/logout".equals(path)) {
            doGet(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
