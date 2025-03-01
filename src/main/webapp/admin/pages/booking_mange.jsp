<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Booking List</title>
    <style>
body{
    overflow: hidden;
}
    .table-container {
        width: 100%;
        margin: 10px auto;
        border-radius: 10px;
        overflow: hidden;
        background: white;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    }

    .table-wrapper {
        scrollbar-width: thin;
        max-height: 700px;
        overflow-y: auto;
        display: block;
    }
        h1 {
            color: #333;
        }
        table {
                width: 100%;
                /* margin: 0 auto; */
                border-collapse: collapse;
                background: white;
                border-radius: 10px;
                overflow: hidden;

        }
        tbody{
            overflow: auto;
            max-height: 300px;
        }
        th, td {
                padding: 12px;
                text-align: center;
                border-bottom: 1px solid #ddd;
                font-size: smaller;
        }
          th {
              background-color: #444444;
              color: #edc553;
              font-weight: bold;
              font-size: 13px;
          }
          tbody tr {
              transition: transform 0.2s ease-in-out;
          }
          tbody tr:hover {
              transform: scale(1.02);
          }

        .btn {
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-delete {
            background-color: white;
            color: #dc3545;
            margin: 5px;
        }
        .btn-update {
            background-color: white;
            color: #28a745;
            margin: 5px;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .actions {
            margin: 5px;
            justify-content: center;
        }
        .status-dropdown{
            border: none;

            padding: 7px;
            border-radius: 7px;
        }
    </style>
    <script>
    const baseUrl = window.location.origin + window.location.pathname.split("/admin")[0];
            function updateStatus(bookingId, newStatus) {

                fetch(baseUrl + "/admin/booking-status", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "id=" + bookingId + "&status=" + newStatus
                })
                .then(response => {
                    if (response.ok) {
                        return response.text();
                    }
                    throw new Error("Failed to update status");
                })
                .then(data => {
                    alert("Status updated successfully");
                    location.reload();
                })
                .catch(error => {
                    alert("Failed to update status");
                    console.error("Error:", error);
                });
            }
            // delete
            function confirmDelete(bookingId) {
                if (confirm("Are you sure you want to delete this booking?")) {
                    fetch(baseUrl + '/admin/booking/delete?id=' + bookingId, {
                        method: 'GET'
                    })
                    .then(response => {
                        if (response.ok) {
                            alert("Booking deleted successfully");
                            location.reload();
                        } else {
                            alert("Failed to delete booking");
                        }
                    })
                    .catch(error => {
                        alert("Error: " + error.message);
                    });
                }
            }


    </script>
</head>
<body>
    <h4>Booking List</h4>

    <div class="table-container">

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>From</th>
                        <th>To</th>
                        <th>Passengers</th>
                        <th>Booking DateTime</th>
                        <th>Distance (km)</th>
                        <th>Duration (min)</th>
                        <th>Customer Name</th>
                        <th>Cab</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                 <tbody>
                                    <c:forEach items="${bookings}" var="booking">
                                        <tr>
                                            <td>${booking.fromDestination}</td>
                                            <td>${booking.toDestination}</td>
                                            <td>${booking.numberOfPassengers}</td>
                                            <td>${booking.bookingDateTime}</td>
                                            <td>${booking.distance}</td>
                                            <td>${booking.duration}</td>
                                            <td>${booking.customerName}</td>
                                            <td>${booking.cabModelName}</td>
                                           <td>
                                               <select class="status-dropdown" onchange="updateStatus(${booking.id}, this.value); changeDropdownColor(this)"
                                                       onload="changeDropdownColor(this)">
                                                   <option value="PENDING" ${booking.bookingStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                                   <option value="CONFIRMED" ${booking.bookingStatus == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                                   <option value="CANCELLED" ${booking.bookingStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                               </select>
                                           </td>

                                            <td class="actions">
                                                <a  onclick="confirmDelete(${booking.id})" class="btn btn-delete">
                                                    <i class="fa-solid fa-trash"></i>
                                                </a>
                                                <a class="btn btn-bill" href="viewBill?id=${booking.billId}"><i class="fa-solid fa-receipt"></i></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
            </table>
        </div>
    </div>


    <c:if test="${empty bookings}">
        <p style="text-align: center; color: #666;">No bookings found.</p>
    </c:if>
</body>
<script>
function changeDropdownColor(selectElement) {
    let status = selectElement.value;

    switch (status) {
        case "PENDING":
            selectElement.style.backgroundColor = "#FFD700";
            break;
        case "CONFIRMED":
            selectElement.style.backgroundColor = "#28a745";
            selectElement.style.color = "#fff";
            break;
        case "CANCELLED":
            selectElement.style.backgroundColor = "#dc3545";
            selectElement.style.color = "#fff";
            break;
        default:
            selectElement.style.backgroundColor = "#cce6ff";
            selectElement.style.color = "#000";
    }
}

document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".status-dropdown").forEach(function (dropdown) {
        changeDropdownColor(dropdown);
    });
});

</script>

</html>
