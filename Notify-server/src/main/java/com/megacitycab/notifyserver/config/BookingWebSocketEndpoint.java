package com.megacitycab.notifyserver.config;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/websocket/bookings")
public class BookingWebSocketEndpoint {

    @OnOpen
    public void onOpen(Session session) {
        BookingWebSocketManager.addSession(session);
    }
    @OnMessage
    public void onMessage(String message, Session session) {
//        System.out.println("Message received: " + message);
    }
    @OnClose
    public void onClose(Session session, CloseReason closeReason) {
        BookingWebSocketManager.removeSession(session);
    }
    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket error: " + throwable.getMessage());
        BookingWebSocketManager.removeSession(session);
    }
}