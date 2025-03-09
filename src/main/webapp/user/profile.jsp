<%--
  Created by IntelliJ IDEA.
  User: THUSH
  Date: 3/7/2025
  Time: 10:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Bookings</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        table {
            width: 90%;
            border-collapse: collapse;
            margin: 20px auto;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            background-color: #fff;
        }
        th {
            background-color: #333;
            color: #fff;
            padding: 15px;
            text-align: left;
            font-weight: bold;
        }
        td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .status {
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }
        .status-available {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status-maintenance {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .cancel-btn {
            padding: 5px 10px;
            background-color: #ff4444;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .cancel-btn:hover:not(:disabled) {
            background-color: #cc0000;
        }
        .cancel-btn:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }
        img {
            width: 50px;
            height: auto;
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <%@ include file="../utilities/header.jsp" %>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Model</th>
            <th>Seats</th>
            <th>Fare/KM</th>
            <th>Time/KM</th>
            <th>Driver</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        <tr>
            <td>24</td>
            <td>audi</td>
            <td><img src="https://via.placeholder.com/50" alt="Car Image"> a2</td>
            <td>4</td>
            <td>12.0</td>
            <td>10.0</td>
            <td>mt</td>
            <td><span class="status status-available">Available</span></td>
            <td><button class="cancel-btn" onclick="cancelBooking('24')">Cancel</button></td>
        </tr>
        <tr>
            <td>25</td>
            <td>bmw</td>
            <td><img src="https://via.placeholder.com/50" alt="Car Image"> a3</td>
            <td>6</td>
            <td>15.0</td>
            <td>41.0</td>
            <td>tm</td>
            <td><span class="status status-maintenance">Maintenance</span></td>
            <td><button class="cancel-btn" disabled>Cancel</button></td>
        </tr>
        <tr>
            <td>26</td>
            <td>bmw</td>
            <td><img src="https://via.placeholder.com/50" alt="Car Image"> a4</td>
            <td>8</td>
            <td>12.0</td>
            <td>74.0</td>
            <td>vidu</td>
            <td><span class="status status-available">Available</span></td>
            <td><button class="cancel-btn" onclick="cancelBooking('26')">Cancel</button></td>
        </tr>
        <tr>
            <td>27</td>
            <td>Tesla</td>
            <td><img src="https://via.placeholder.com/50" alt="Car Image"> a5</td>
            <td>3</td>
            <td>15.0</td>
            <td>45.0</td>
            <td>shan</td>
            <td><span class="status status-available">Available</span></td>
            <td><button class="cancel-btn" onclick="cancelBooking('27')">Cancel</button></td>
        </tr>
        <tr>
            <td>28</td>
            <td>tesla</td>
            <td><img src="https://via.placeholder.com/50" alt="Car Image"> a6</td>
            <td>1</td>
            <td>18.0</td>
            <td>45.0</td>
            <td>lehazy</td>
            <td><span class="status status-available">Available</span></td>
            <td><button class="cancel-btn" onclick="cancelBooking('28')">Cancel</button></td>
        </tr>
    </table>

    <script>
        function cancelBooking(bookingId) {
            if (confirm('Are you sure you want to cancel booking ' + bookingId + '?')) {
                // Add your cancellation logic here
                alert('Booking ' + bookingId + ' cancellation requested');
            }
        }
    </script>
</body>
</html>