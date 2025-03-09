package com.megacitycab.notifyserver.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.megacitycab.notifyserver.notification.BookingNotification;
import jakarta.websocket.Session;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

public class BookingWebSocketManager {
    private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
    private static final ObjectMapper objectMapper = new ObjectMapper();

    public static void addSession(Session session) {
        sessions.add(session);
    }
    public static void removeSession(Session session) {
        sessions.remove(session);
    }
    public static void broadcastBookingNotification(BookingNotification notification) {
        String jsonMessage;
        try {
            jsonMessage = objectMapper.writeValueAsString(notification);
            synchronized (sessions) {
                for (Session session : sessions) {
                    if (session.isOpen()) {
                        session.getAsyncRemote().sendText(jsonMessage);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error broadcasting notification: " + e.getMessage());
        }
    }
}