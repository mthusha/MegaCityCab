package com.megacitycab.auth;
import com.megacitycab.config.JwtTokenProvider;
import com.megacitycab.dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter(urlPatterns = { "/admin/*", "/user/*"})
public class AuthFilter implements Filter{
    private final UserDAO userDAO = new UserDAO();
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String token = null;

        // Check token in cookies
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("token".equals(cookie.getName())) {
                    token = cookie.getValue();
                    break;
                }
            }
        }

        System.out.println("token: " + token);
        // Validate token
        if (token == null || !JwtTokenProvider.getInstance().validateToken(token)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String username = JwtTokenProvider.getInstance().getUsernameFromToken(token);
        Users user = userDAO.findByUsername(username);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (request.getRequestURI().contains("/admin/") && !"admin".equals(user.getRoles())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        chain.doFilter(request, response);

    }
}
