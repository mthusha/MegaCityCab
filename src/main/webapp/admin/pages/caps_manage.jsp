<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Cab List</title>
    <style>
        body {
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
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }
        tbody {
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
        .status-dropdown {
            border: none;
            padding: 7px;
            border-radius: 7px;
        }
        .cab-image {
            max-width: 100px;
            height: auto;
        }
        .image-model-cell {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }
        .cab-image {
            max-width: 100px;
            height: auto;
        }
        .image-container {
            text-align: center;
        }

        .add-btn {
                border: none;
                position: fixed;
                bottom: 20px;
                right: 20px;
                background-color: #f5c335;
                color: #000000;
                padding: 12px 20px;
                border-radius: 50px;
                /* box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); */
                font-size: 16px;
                z-index: 1000;
        }

        /* Modal Styles */
        .modal {
                margin: 0;
                display: none;
                /* position: fixed; */
                top: 0;
                left: 0;
                /* width: 100%; */
                /* height: 100%; */

        }
        .modal-content {
            background-color: white;
            margin: 50px auto;
            padding: 20px;
            width: 400px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        .modal-content h2 {
            margin-top: 0;
            color: #333;
        }
        .modal-content label {
            display: block;
            margin: 10px 0 5px;
        }
        .modal-content input, .modal-content select {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .modal-content button {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .modal-content button:hover {
            opacity: 0.8;
        }
        .close-btn {
            float: right;
            font-size: 20px;
            cursor: pointer;
            color: #666;
        }
    </style>
    <script>
        const baseUrl = window.location.origin + window.location.pathname.split("/admin")[0];

        function updateStatus(cabId, newStatus) {
            fetch(baseUrl + "/admin/cabs/update", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "id=" + cabId + "&status=" + newStatus
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

        function confirmDelete(cabId) {
            if (confirm("Are you sure you want to delete this cab?")) {
                fetch(baseUrl + '/admin/cabs/delete?id=' + cabId, {
                    method: 'DELETE'
                })
                .then(response => {
                    if (response.ok) {
                        alert("Cab deleted successfully");
                        location.reload();
                    } else {
                        alert("Failed to delete cab");
                    }
                })
                .catch(error => {
                    alert("Error: " + error.message);
                });
            }
        }

        function openModal() {
           document.getElementById("addCabModal").style.display = "block";
            document.getElementById("table-container").style.display = "none";
            document.getElementById("add-btn").style.display = "none";

                }

        function closeModal() {
              document.getElementById("addCabModal").style.display = "none";
               document.getElementById("table-container").style.display = "block";
               document.getElementById("add-btn").style.display = "block";

            }


    </script>
</head>
<body>
    <h4>Cab List</h4>

    <div class="table-container" id="table-container">
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Model</th>
                        <th>Seats</th>
                        <th>Fare/KM</th>
                        <th>Time/KM</th>
                        <th>Driver</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${cabs}" var="cab">
                        <tr>
                            <td>${cab.id}</td>
                            <td>${cab.name}</td>
                            <td class="image-model-cell">
                                <c:if test="${not empty cab.imagePath}">
                                   <img src="${cab.imagePath}" alt="${cab.name}" class="cab-image">
                                </c:if>
                                <c:if test="${empty cab.imagePath}">
                                    <span>No Image</span>
                                </c:if>
                                    <span>${cab.model}</span>
                            </td>
                            <td>${cab.numberOfSeats}</td>
                            <td>${cab.farePerKm}</td>
                            <td>${cab.timePerKm}</td>
                           <td>${cab.driver != null ? cab.driver : "Not driver allocated"}</td>

                            <td>
                                <select class="status-dropdown" onchange="updateStatus(${cab.id}, this.value); changeDropdownColor(this)"
                                        onload="changeDropdownColor(this)">
                                    <option value="AVAILABLE" ${cab.status == 'AVAILABLE' ? 'selected' : ''}>Available</option>
                                    <option value="MAINTENANCE" ${cab.status == 'MAINTENANCE' ? 'selected' : ''}>Maintenance</option>
                                </select>
                            </td>
                            <td class="actions">
                                <a onclick="confirmDelete(${cab.id})" class="btn btn-delete">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                                <!-- <a href="updateCab?id=${cab.id}" class="btn btn-update"><i class="fa-solid fa-edit"></i></a> -->
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <c:if test="${empty cabs}">
        <p style="text-align: center; color: #666;">No cabs found.</p>
    </c:if>

    <button class="add-btn" id="add-btn" onclick="openModal()">
            <i class="fa-solid fa-plus"></i>
    </button>

    <!-- Modal Popup Form -->
       <div id="addCabModal" class="modal">
           <div class="modal-content">
               <span class="close-btn" onclick="closeModal()">×</span>
               <h2>Add New Cab</h2>
               <form id="addCabForm" enctype="multipart/form-data" onsubmit="return false;">
                   <c:if test="${not empty error}">
                       <div style="color: red; text-align: center; padding: 10px;" id="error-message">
                           ${error}
                       </div>
                   </c:if>
                   <label for="name">Name:</label>
                   <input type="text" id="name" name="name" required>

                   <label for="model">Model:</label>
                   <input type="text" id="model" name="model" required>

                   <label for="numberOfSeats">Number of Seats:</label>
                   <input type="number" id="numberOfSeats" name="numberOfSeats" required>

                   <label for="farePerKm">Fare per KM:</label>
                   <input type="number" id="farePerKm" name="farePerKm" step="0.01" required>

                   <label for="timePerKm">Time per KM (minutes):</label>
                   <input type="number" id="timePerKm" name="timePerKm" step="0.01" required>

                   <label for="status">Status:</label>
                   <select id="status" name="status" required>
                       <option value="AVAILABLE">Available</option>
                       <option value="MAINTENANCE">Maintenance</option>
                   </select>

                   <label for="image">Cab Image:</label>
                   <input type="file" id="image" name="image" accept="image/*" required>

                   <button type="submit" id="submitBtn">Add Cab</button>
               </form>
           </div>
       </div>
</body>
<script>
    function changeDropdownColor(selectElement) {
        let status = selectElement.value;
        switch (status) {
            case "AVAILABLE":
                selectElement.style.backgroundColor = "rgb(211 255 221)";
                selectElement.style.color = "rgb(0 0 0)";
                break;
            case "MAINTENANCE":
                selectElement.style.backgroundColor = "rgb(255 185 185)";
                selectElement.style.color = "rgb(0 0 0)";
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
<script>
    document.getElementById('addCabForm').addEventListener('submit', async function(e) {
        e.preventDefault();

        const submitBtn = document.getElementById('submitBtn');
        const errorMessage = document.getElementById('error-message') ||
            document.createElement('div');

        if (!errorMessage.id) {
            errorMessage.id = 'error-message';
            errorMessage.style.cssText = 'color: red; text-align: center; padding: 10px; display: none;';
            this.insertBefore(errorMessage, this.firstChild);
        }

        const formData = new FormData(this);

        try {
            submitBtn.disabled = true;
            submitBtn.textContent = 'Adding...';

            const response = await fetch('${pageContext.request.contextPath}/admin/cabs', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                errorMessage.style.display = 'none';
                errorMessage.textContent = '';

                closeModal();
                location.reload();
                // updateTableWithNewCab(await response.json());
            } else {
                const errorText = await response.text();
                errorMessage.textContent = errorText || 'Failed to add cab';
                errorMessage.style.display = 'block';
            }
        } catch (error) {
            errorMessage.textContent = 'Error: ' + error.message;
            errorMessage.style.display = 'block';
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Add Cab';
        }
    });

    function closeModal() {
        document.getElementById('addCabModal').style.display = 'none';
        document.getElementById('table-container').style.display = 'block';
        document.getElementById('add-btn').style.display = 'block';
    }
</script>
</html>