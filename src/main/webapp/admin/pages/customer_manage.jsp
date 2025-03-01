<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Customer List</title>
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
                /* margin: 0 auto; */
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
    </style>
    <script>
        const baseUrl = window.location.origin + window.location.pathname.split("/admin")[0];

        function confirmDelete(customerId) {
            if (confirm("Are you sure you want to delete this customer?")) {
                fetch(baseUrl + '/admin/customer/delete?id=' + customerId, {
                    method: 'GET'
                })
                .then(response => {
                    if (response.ok) {
                        alert("Customer deleted successfully");
                        location.reload();
                    } else {
                        alert("Failed to delete customer");
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
    <h4>Customer List</h4>

    <div class="table-container">
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>NIC</th>
                        <th>Username</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${customers}" var="customer">
                        <tr>
                            <td>${customer.id}</td>
                            <td>${customer.name}</td>
                            <td>${customer.address}</td>
                            <td>${customer.phone}</td>
                            <td>${customer.email}</td>
                            <td>${customer.nic}</td>
                            <td>${customer.username}</td>
                            <td class="actions">
                                <a onclick="confirmDelete(${customer.id})" class="btn btn-delete">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                                <!-- Add update functionality if needed -->
                                <!--
                                <a href="updateCustomer?id=${customer.id}" class="btn btn-update">
                                    <i class="fa-solid fa-edit"></i>
                                </a>
                                -->
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <c:if test="${empty customers}">
        <p style="text-align: center; color: #666;">No customers found.</p>
    </c:if>
</body>
</html>