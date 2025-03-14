Mega City Cab System
Overview
The Mega City Cab System is a web-based distributed application designed to manage cab bookings and driver operations in Colombo City. Built using Jakarta EE, JSP, and Hibernate/JPA, it is deployed as a WAR file on an Apache TomEE server. This project provides an interactive platform for customers, drivers, and admins, with features like real-time tracking, email/SMS notifications, and robust validation.

Features
Customer Interface: Book rides, manage bookings, and update profiles via JSP pages.
Driver Interface: View rides, update status (ON_DUTY/OFF_DUTY), and manage cab assignments.
Admin Interface: Manage users, bookings, cabs, drivers, and generate reports.
Real-Time Tracking: Uses Google Maps API for live cab location tracking on the customer dashboard.
Email Notifications: Sends booking confirmations using the Gmail API.
SMS Notifications: Integrates with Twilio API for ride status updates.
Input Validation: Ensures data integrity with client-side (JavaScript) and server-side (Jakarta EE) validation.
Database Persistence: Stores data using Hibernate/JPA with PostgreSQL.
Prerequisites
Java 17 or higher
Apache Maven for building the project
Apache TomEE (Jakarta EE server) for deployment
PostgreSQL or MySQL for database
Git for version control
Google Maps API Key and Gmail API Key for map and email functionality
Twilio Account (optional, for SMS)

Setup Instructions
Clone the Repository
git clone https://github.com/mthusha/mega-city-cab-system.git
cd mega-city-cab-system

API Keys
Google Maps API Key: Required for real-time tracking. Obtain from Google Cloud Console. Example usage in JSP:
<script src="https://maps.googleapis.com/maps/api/js?key=your-google-maps-api-key" async defer></script>
Gmail API Key: Required for sending email notifications. Generate via Google Cloud Console with a service account. Example usage in Java:
Guidelines for Adding Google Maps API to map_view.jsp
1. Directory and File Setup
The file map_view.jsp should be located at src/main/webapp/user/map_view.jsp in your Mega City Cab project structure.
This JSP page will display a Google Map for users (likely customers) to track cab locations in real-time.
