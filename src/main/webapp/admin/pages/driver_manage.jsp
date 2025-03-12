<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Driver List</title>
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
        h4 {
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
        .btn-assign {
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
            padding: 5px;
            border-radius: 5px;
            cursor: pointer;
        }
        .add-btn {
            border: none;
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #edc553;
            color: white;
            padding: 10px 15px;
            border-radius: 50%;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.2);
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: #f0f0f0;
        }
        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 20px;
            border-radius: 10px;
            width: 80%;
            max-width: 500px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
        .close-btn {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close-btn:hover {
            color: #000;
        }
        .modal-content h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .modal-content label {
            display: block;
            margin: 10px 0 5px;
            color: #444;
        }
        .modal-content input, .modal-content select {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .modal-content button {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
        }
        .modal-content button.deallocate {
            background-color: #dc3545;
        }
        .modal-content button:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <h4>Driver List</h4>

    <div class="table-container">
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Address</th>
                        <th>Assigned Cab</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${drivers}" var="driver">
                        <tr>
                            <td>${driver.id}</td>
                            <td>${driver.name}</td>
                            <td>${driver.email}</td>
                            <td>${driver.phone}</td>
                            <td>${driver.address}</td>
                            <td>${driver.cabs != null ? driver.cabs : 'Not Assigned'}</td>
                            <td>
                                <select class="status-dropdown" onchange="updateStatus(${driver.id}, this.value); changeDropdownColor(this)">
                                    <option value="ON_DUTY" ${driver.status == 'ON_DUTY' ? 'selected' : ''}>On Duty</option>
                                    <option value="OFF_DUTY" ${driver.status == 'OFF_DUTY' ? 'selected' : ''}>Off Duty</option>
                                </select>
                            </td>
                            <td class="actions">
                                <a onclick="confirmDelete(${driver.id})" class="btn btn-delete">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                                <a onclick="openAllocationModal(${driver.id}, '${driver.cabs}', '${driver.status}')" class="btn btn-assign">
                                    <i class="fa-solid fa-car"
                                       style="${driver.cabs == null || driver.cabs == 'Not Assigned' ? 'color: #bcbcbc;' : 'color: #28a745;'}">
                                    </i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <c:if test="${empty drivers}">
        <p style="text-align: center; color: #666;">No drivers found.</p>
    </c:if>

    <button class="add-btn" onclick="openModal()">
        <i class="fa-solid fa-plus"></i>
    </button>

    <!-- Add Driver Modal -->
    <div id="addDriverModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal()">×</span>
            <h2>Add New Driver</h2>
            <form id="addDriverForm" onsubmit="return false;">
                <c:if test="${not empty error}">
                    <div style="color: red; text-align: center; padding: 10px;" id="error-message">
                        ${error}
                    </div>
                </c:if>
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
                <label for="phone">Phone:</label>
                <input type="tel" id="phone" name="phone" required>
                <label for="address">Address:</label>
                <input type="text" id="address" name="address" required>
                <label for="status">Status:</label>
                <select id="status" name="status" required>
                    <option value="ON_DUTY">On Duty</option>
                    <option value="OFF_DUTY">Off Duty</option>
                </select>
                <button type="submit" id="submitBtn">Add Driver</button>
            </form>
        </div>
    </div>

    <!-- Allocation Modal -->
    <div id="allocationModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeAllocationModal()">×</span>
            <h2 id="allocationTitle">Vehicle Allocation</h2>
            <form id="allocationForm" onsubmit="return false;">
                <div id="allocationStatus"></div>
                <input type="hidden" id="driverId" name="driverId">
                <div id="currentVehicle" style="display: none;">
                    <label>Current Vehicle:</label>
                    <p id="currentVehicleText" style="margin: 5px 0;"></p>
                    <button type="button" id="deallocateBtn" class="deallocate" onclick="deallocateVehicle()">Deallocate</button>
                </div>
                <div id="allocateSection" style="margin-top: 10px;">
                    <label for="cabId">Select Vehicle:</label>
                    <select id="cabId" name="cabId" required>
                        <option value="">-- Select a Vehicle --</option>
                        <c:forEach items="${availableCabs}" var="cab">
                            <option value="${cab.id}">${cab.name} (${cab.id})</option>
                        </c:forEach>
                    </select>
                    <button type="submit" id="allocateBtn">Allocate Vehicle</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        const baseUrl = window.location.origin + window.location.pathname.split("/admin")[0];

        function updateStatus(driverId, newStatus) {
            fetch(baseUrl + "/admin/drivers/update", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "id=" + driverId + "&status=" + newStatus
            })
            .then(response => response.ok ? response.text() : Promise.reject("Failed to update status"))
            .then(data => {
                alert("Status updated successfully");
                location.reload();
            })
            .catch(error => {
                alert("Failed to update status");
                console.error("Error:", error);
            });
        }

        function confirmDelete(driverId) {
            if (confirm("Are you sure you want to delete this driver?")) {
                fetch(baseUrl + '/admin/drivers/delete?id=' + driverId, {
                    method: 'DELETE'
                })
                .then(response => response.ok ? "Driver deleted successfully" : Promise.reject("Failed to delete driver"))
                .then(data => {
                    alert(data);
                    location.reload();
                })
                .catch(error => alert("Error: " + error));
            }
        }

        function openAllocationModal(driverId, currentCab, status) {
            const modal = document.getElementById("allocationModal");
            const driverIdInput = document.getElementById("driverId");
            const currentVehicleDiv = document.getElementById("currentVehicle");
            const currentVehicleText = document.getElementById("currentVehicleText");
            const allocateSection = document.getElementById("allocateSection");
            const allocateBtn = document.getElementById("allocateBtn");
            const allocationStatus = document.getElementById("allocationStatus");

            driverIdInput.value = driverId;
            allocationStatus.innerHTML = "";

            if (currentCab && currentCab !== "Not Assigned") {
                currentVehicleDiv.style.display = "block";
                currentVehicleText.textContent = currentCab;
                allocateSection.style.display = "block";
                allocateBtn.textContent = "Change Vehicle";
            } else {
                currentVehicleDiv.style.display = "none";
                if (status === "ON_DUTY") {
                    allocateSection.style.display = "block";
                    allocateBtn.textContent = "Allocate Vehicle";
                } else {
                    allocateSection.style.display = "none";
                    allocationStatus.innerHTML = '<p style="color: red; text-align: center;">Driver must be ON_DUTY to allocate a vehicle.</p>';
                }
            }

            modal.style.display = "block";
        }

        function closeAllocationModal() {
            document.getElementById("allocationModal").style.display = "none";
        }

        function deallocateVehicle() {
            const driverId = document.getElementById("driverId").value;
            fetch(baseUrl + '/admin/cabs/remove-driver', {
                method: 'POST',
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: `driverId=${driverId}`
            })
            .then(response => response.ok ? response.text() : Promise.reject("Failed to deallocate vehicle"))
            .then(data => {
                alert(data);
                location.reload();
            })
            .catch(error => alert("Error: " + error));
        }

        document.getElementById('allocationForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const driverId = formData.get("driverId");
            const cabId = formData.get("cabId");

            try {
                const response = await fetch(baseUrl + '/admin/cabs/assign-driver', {
                    method: 'POST',
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: `cabId=${cabId}&driverId=${driverId}`
                 });
                if (response.ok) {
                    alert(await response.text());
                    closeAllocationModal();
                    location.reload();
                } else {
                    alert("Failed to allocate vehicle");
                }
            } catch (error) {
                alert("Error: " + error.message);
            }
         });

        function openModal() {
            document.getElementById("addDriverModal").style.display = "block";
        }

        function closeModal() {
            document.getElementById("addDriverModal").style.display = "none";
        }

        document.getElementById('addDriverForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const submitBtn = document.getElementById('submitBtn');
            const errorMessage = document.getElementById('error-message') || document.createElement('div');

            if (!errorMessage.id) {
                errorMessage.id = 'error-message';
                errorMessage.style.cssText = 'color: red; text-align: center; padding: 10px; display: none;';
                this.insertBefore(errorMessage, this.firstChild);
            }

            const formData = new FormData(this);

            try {
                submitBtn.disabled = true;
                submitBtn.textContent = 'Adding...';
                const response = await fetch(baseUrl + '/admin/drivers', {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    errorMessage.style.display = 'none';
                    errorMessage.textContent = '';
                    closeModal();
                    location.reload();
                } else {
                    const errorText = await response.text();
                    errorMessage.textContent = errorText || 'Failed to add driver';
                    errorMessage.style.display = 'block';
                }
            } catch (error) {
                errorMessage.textContent = 'Error: ' + error.message;
                errorMessage.style.display = 'block';
            } finally {
                submitBtn.disabled = false;
                submitBtn.textContent = 'Add Driver';
            }
        });

        function changeDropdownColor(selectElement) {
            let status = selectElement.value;
            switch (status) {
                case "AVAILABLE":
                    selectElement.style.backgroundColor = "rgb(211 255 221)";
                    break;
                case "ON_DUTY":
                    selectElement.style.backgroundColor = "rgb(255 235 153)";
                    break;
                case "OFF_DUTY":
                    selectElement.style.backgroundColor = "rgb(255 185 185)";
                    break;
                default:
                    selectElement.style.backgroundColor = "#cce6ff";
            }
            selectElement.style.color = "#000";
        }

        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".status-dropdown").forEach(function (dropdown) {
                changeDropdownColor(dropdown);
            });
        });
    </script>
</body>
</html>