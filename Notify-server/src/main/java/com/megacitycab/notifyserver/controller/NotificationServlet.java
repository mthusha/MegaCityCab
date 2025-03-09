package com.megacitycab.notifyserver.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.megacitycab.notifyserver.config.BookingWebSocketManager;
import com.megacitycab.notifyserver.notification.BookingNotification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.serialization.StringDeserializer;
import java.io.IOException;
import java.time.Duration;
import java.util.Collections;
import java.util.Properties;
@WebServlet(value = "/websocket/bookings", loadOnStartup = 1)
public class NotificationServlet extends HttpServlet {
    private final ObjectMapper objectMapper = new ObjectMapper();
    private KafkaConsumer<String, String> kafkaConsumer;
    private volatile boolean running = true;

    @Override
    public void init() throws ServletException {
        Properties props = new Properties();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "localhost:9092");
        props.put(ConsumerConfig.GROUP_ID_CONFIG, "notification-service");
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");
        kafkaConsumer = new KafkaConsumer<>(props);
        kafkaConsumer.subscribe(Collections.singletonList("booking-events"));

        new Thread(() -> {
            while (running) {
                ConsumerRecords<String, String> records = kafkaConsumer.poll(Duration.ofMillis(100));
                for (ConsumerRecord<String, String> record : records) {
                    try {
                        BookingNotification notification = objectMapper.readValue(record.value(), BookingNotification.class);
                        BookingWebSocketManager.broadcastBookingNotification(notification);
                    } catch (Exception e) {
                        System.err.println("Error processing Kafka message: " + e.getMessage());
                    }
                }
            }
        }).start();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Use WebSocket protocol (ws://) for /websocket/bookings");
    }

    @Override
    public void destroy() {
        running = false;
        if (kafkaConsumer != null) {
            kafkaConsumer.close();
        }
    }
}
