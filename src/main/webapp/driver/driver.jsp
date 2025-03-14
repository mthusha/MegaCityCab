<%--
  Created by IntelliJ IDEA.
  User: THUSH
  Date: 3/12/2025
  Time: 10:33 PM
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>My Allocated Cab & Bookings</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --success-color: #2ecc71;
            --danger-color: #e74c3c;
            --background-color: #ecf0f1;
            --card-background: #ffffff;
            --text-color: #333333;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, var(--background-color) 0%, #dfe4ea 100%);
            min-height: 100vh;
        }

        .container {
            max-width: 1300px;
            margin: 0 auto;
        }

        .section-card {
            background: var(--card-background);
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .section-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        h2 {
            color: var(--primary-color);
            margin: 0 0 20px 0;
            font-size: 24px;
            position: relative;
            padding-bottom: 10px;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: var(--secondary-color);
            border-radius: 2px;
        }

        .cab-details {
            display: flex;
            align-items: center;
            gap: 30px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            transition: background 0.3s ease;
        }

        .cab-details:hover {
            background: #e9ecef;
        }

        .cab-image {
            max-width: 250px;
            height: auto;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .cab-image:hover {
            transform: scale(1.05);
        }

        .cab-info {
            flex: 1;
        }

        .cab-info p {
            margin: 12px 0;
            font-size: 16px;
            color: var(--text-color);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .cab-info p strong {
            color: var(--primary-color);
            min-width: 100px;
        }

        .table-wrapper {
            max-height: 450px;
            overflow-y: auto;
            border-radius: 10px;
            background: #f8f9fa;
            padding: 10px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }

        th {
            background: #f5c335;
            color: white;
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 1;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        tr {
            transition: background 0.2s ease, transform 0.2s ease;
        }

        tr:hover {
            background: #eef2f6;
            transform: scale(1.01);
        }

        .no-data {
            text-align: center;
            color: #7f8c8d;
            padding: 30px;
            font-style: italic;
            font-size: 18px;
            background: #f8f9fa;
            border-radius: 10px;
            margin: 20px 0;
        }

        .status-available {
            color: var(--success-color);
            font-weight: 600;
            background: rgba(46, 204, 113, 0.1);
            padding: 5px 10px;
            border-radius: 15px;
        }

        .status-maintenance {
            color: var(--danger-color);
            font-weight: 600;
            background: rgba(231, 76, 60, 0.1);
            padding: 5px 10px;
            border-radius: 15px;
        }

        .table-wrapper::-webkit-scrollbar {
            width: 8px;
        }

        .table-wrapper::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .table-wrapper::-webkit-scrollbar-thumb {
            background: var(--secondary-color);
            border-radius: 10px;
        }

        .table-wrapper::-webkit-scrollbar-thumb:hover {
            background: #2980b9;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Driver's Allocated Cab Section -->
        <div class="section-card cab-section">
            <h2>My Allocated Cab</h2>
            <c:choose>
                <c:when test="${not empty allocatedCab}">
                    <div class="cab-details">
                        <c:if test="${not empty allocatedCab.imagePath}">
                            <img src="${allocatedCab.imagePath}" alt="${allocatedCab.name}" class="cab-image">
                        </c:if>
                        <div class="cab-info">
                            <p><strong>Name:</strong> ${allocatedCab.name}</p>
                            <p><strong>Model:</strong> ${allocatedCab.model}</p>
                            <p><strong>Seats:</strong> ${allocatedCab.numberOfSeats}</p>
                            <p><strong>Fare/KM:</strong> ${allocatedCab.farePerKm}</p>
                            <p><strong>Time/KM:</strong> ${allocatedCab.timePerKm} minutes</p>
                            <p><strong>Status:</strong>
                                <span class="${allocatedCab.status == 'AVAILABLE' ? 'status-available' : 'status-maintenance'}">
                                    ${allocatedCab.status}
                                </span>
                            </p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="no-data">
                        <i class="fas fa-car-side"></i> No cab currently allocated to you.
                    </p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Future Bookings Section -->
        <div class="section-card bookings-section">
            <h2>Future Bookings</h2>
            <c:choose>
                <c:when test="${not empty futureBookings}">
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>Booking ID</th>
                                    <th>Customer</th>
                                    <th>Pickup Location</th>
                                    <th>Drop-off Location</th>
                                    <th>Booking Date</th>
                                    <th>Distance (KM)</th>
                                    <th>Estimated Fare</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${futureBookings}" var="booking">
                                    <tr>
                                        <td>${booking.id}</td>
                                        <td>${booking.customer.name}</td>
                                        <td>${booking.toDestination}</td>
                                        <td>${booking.fromDestination}</td>
                                        <td>
                                            ${booking.bookingDateTime}
                                        </td>
                                        <td>${booking.distance}</td>
                                        <td>$${String.format("%.2f", booking.distance * allocatedCab.farePerKm)}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="no-data">
                        <i class="fas fa-calendar-times"></i> No future bookings scheduled for your cab.
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const cards = document.querySelectorAll('.section-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 200);
            });
        });
    </script>
</body>
</html>