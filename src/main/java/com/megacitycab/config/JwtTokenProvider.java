package com.megacitycab.config;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;

import java.util.Date;

public class JwtTokenProvider {

    private static JwtTokenProvider instance;
    private final String SECRET_KEY = "4e9ad88684aaa187ba9fc4bdf9f9c0ff598966f006d7a80da003b5e093ae446dd4317737a5877b09ae8ac1d3cadd259ab5784d40a8f6d4bd1063e837b787cef4ffefa3fdebbaef026b082bd3b890a6374685223909ebac56a91058322ef731d05e74faa36b73afaf7a8b969a7d1b040d1dca3d6b5923b5a1ca64833d03799b669e1e854eb962f34ea37cdeaf4da368c20987c0e5a008928abb786343c182301af878d3cdf23bb1d620a944534332804fb9092303a3cdb241d858d70019e140925910d207e47da85393eeb7e3dd6bf418c154e921d622f101a61f9dd1740130997ef18b5168dda992273f9854938b4cea66373e4fab6a9e3b176ebb35e08367bd";
    private final long EXPIRATION_TIME = 864_000_00;
    private final Algorithm algorithm;

    private JwtTokenProvider() {
        this.algorithm =  Algorithm.HMAC256(SECRET_KEY);
    }

    public static JwtTokenProvider getInstance() {
        if (instance == null) {
            synchronized (JwtTokenProvider.class) {
                if (instance == null) {
                    instance = new JwtTokenProvider();
                }
            }
        }
        return instance;
    }

    public String generateToken(String username) {
        return JWT.create()
                .withSubject(username)
                .withIssuedAt(new Date())
                .withExpiresAt(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                .sign(algorithm);
    }

    public boolean validateToken(String token) {
        try {
            JWT.require(algorithm).build().verify(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public String getUsernameFromToken(String token) {
        DecodedJWT decodedJWT = JWT.require(algorithm).build().verify(token);
        return decodedJWT.getSubject();
    }

    public static String getTokenFromCookies(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("token".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
}
