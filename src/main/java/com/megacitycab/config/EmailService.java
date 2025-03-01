package com.megacitycab.config;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailService {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USER = "thusha.micro@gmail.com";
    private static final String SMTP_PASSWORD = "dyeardkdjduwirmu";

    public void sendBookingStatusEmail(String toEmail, Long bookingId, String status) {
        try {
            Properties properties = new Properties();
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.host", SMTP_HOST);
            properties.put("mail.smtp.port", SMTP_PORT);

            Session session = Session.getInstance(properties, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Booking Status Update");
            message.setText("Dear Customer,\n\nYour booking (ID: " + bookingId + ") status has been updated to: " + status + ".\n\nThank you for choosing us!");

            Transport.send(message);
            System.out.println("Email sent to " + toEmail);
        } catch (Exception e) {
            System.out.println("something went wrong while sending email " + e.getMessage());
        }
    }
}
