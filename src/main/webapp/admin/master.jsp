<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Master Layout</title>

    <style>
    body {
        margin: 0;
        padding: 0;
        font-family: sans-serif;
    }
    .content {
        margin-left: 200px;
        min-height: 86vh;
        padding: 8px;
        box-sizing: border-box;
        background-color: #f0f0f0;
        border-radius: 10px;
    }
       .footer {
           font-size: 12px;
           height: 28px;
           background-color: #ffffff;
           color: #f5c335;
           text-align: center;
           padding: 10px;
           position: fixed;
           width: 100%;
           bottom: 0;
        }
    @media (max-width: 768px) {
        .content {
            margin-left: 0;
        }
    }
    </style>
</head>
<body>
    <%@ include file="components/header.jsp" %>
    <%@ include file="components/sidebar.jsp" %>
    <div class="content">
        <iframe name="contentFrame" src="pages/dashboard.jsp" style="border:none; width:100%; height:100%;"></iframe>
    </div>
     <%@ include file="components/footer.jsp" %>

     <div id="notification-area" style="position: fixed; bottom: 10px; left: 10px; background: #fff; padding: 10px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.2); display: none;">
             <p id="notification-message"></p>
     </div>
</body>
<script>

        const ws = new WebSocket('ws://localhost:8092/Gradle___com_MegaCityCab___notify_server_1_0_SNAPSHOT_war/websocket/bookings');

        ws.onopen = function() {
            console.log('WebSocket connection established');
        };

        ws.onmessage = function(event) {
            const notification = JSON.parse(event.data);
            if (notification.type === 'BOOKING_CREATED') {
                showNotification(
                    `New booking created (ID: ${notification.bookingId}) for cab ${notification.cabId} by ${notification.customerName}`
                );
            }
        };

        ws.onerror = function(error) {
            console.error('WebSocket error:', error);
        };

        ws.onclose = function() {
            console.log('WebSocket connection closed');
        };

        function showNotification(message) {
            const notificationArea = document.getElementById('notification-area');
            const notificationMessage = document.getElementById('notification-message');
            notificationMessage.textContent = message;
            notificationArea.style.display = 'block';

            setTimeout(() => {
                notificationArea.style.display = 'none';
            }, 5000);
        }
    </script>
</html>
