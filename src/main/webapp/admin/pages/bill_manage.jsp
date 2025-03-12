<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Bill List</title>
    <style>
        /* Include same styles as in your cab JSP, adjusting where necessary */
        /* Here's a simplified version */
        .table-container {
            width: 100%;
            margin: 10px auto;
            border-radius: 10px;
            overflow: hidden;
            background: white;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
        .table-wrapper {
            max-height: 700px;
            overflow-y: auto;
            display: block;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #444444;
            color: #edc553;
        }
        .btn-delete {
            background-color: white;
            color: #dc3545;
            padding: 8px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .add-btn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #f5c335;
            color: #000000;
            padding: 12px 20px;
            border-radius: 50px;
            border: none;
        }

        .modal-content {
            background-color: white;
            margin: 50px auto;
            padding: 20px;
            width: 400px;
            border-radius: 10px;
        }
         .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;

                display: flex;
                align-items: center;
                justify-content: center;
            }

            .modal-content {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                width: 400px;
                box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
                text-align: center;
                position: relative;
            }

            .close-btn {
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 20px;
                cursor: pointer;
                color: #555;
            }

            .close-btn:hover {
                color: #d00;
            }

            form {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            label {
                font-weight: bold;
                text-align: left;
                display: block;
            }

            input {
                width: 100%;
                padding: 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            button {
                background-color: #28a745;
                color: white;
                padding: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
            }

            button:hover {
                background-color: #218838;
            }

            #error-message {
                color: red;
                font-weight: bold;
            }
    </style>
</head>
<body>
    <h4>Bill List</h4>

    <div class="table-container" id="table-container">
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Amount</th>
                        <th>Tax</th>
                        <th>Discount</th>
                        <th>Billing Date</th>
                        <th>Booking ID</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${bills}" var="bill">
                        <tr>
                            <td>${bill.id}</td>
                            <td>${bill.amount}</td>
                            <td>${bill.tax}</td>
                            <td>${bill.discountAmount}</td>
                            <td>${bill.billingDate}</td>
                            <td>${bill.bookingId != null ? bill.bookingId : "N/A"}</td>
                            <td>
                                <a onclick="confirmDelete(${bill.id})" class="btn btn-delete">
                                    <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <button class="add-btn" id="add-btn" onclick="openModal()">
        <i class="fa-solid fa-plus"></i>
    </button>

    <div style="display: none;" id="addBillModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal()">×</span>
            <h2>Add New Bill</h2>
            <form id="addBillForm" onsubmit="return false;">
                <c:if test="${not empty error}">
                    <div style="color: red; text-align: center; padding: 10px;" id="error-message">
                        ${error}
                    </div>
                </c:if>
                <label for="amount">Amount:</label>
                <input type="number" id="amount" name="amount" step="0.01" required>

                 <label for="Booking">Booking Id:</label>
                  <input type="number" id="Booking" name="Booking" step="0.01" required>

                <label for="tax">Tax:</label>
                <input type="number" id="tax" name="tax" step="0.01" required>

                <label for="discountAmount">Discount Amount:</label>
                <input type="number" id="discountAmount" name="discountAmount" step="0.01" required>

                <label for="billingDate">Billing Date:</label>
                <input type="datetime-local" id="billingDate" name="billingDate" required>

                <button type="submit" id="submitBtn">Add Bill</button>
            </form>
        </div>
    </div>

<script>
    const baseUrl = window.location.origin + window.location.pathname.split("/admin")[0];

    function confirmDelete(billId) {
        if (confirm("Are you sure you want to delete this bill?")) {
            fetch(baseUrl + '/admin/bills/delete?id=' + billId, {
                method: 'DELETE'
            })
            .then(response => {
                if (response.ok) {
                    alert("Bill deleted successfully");
                    location.reload();
                } else {
                    alert("Failed to delete bill");
                }
            })
            .catch(error => alert("Error: " + error.message));
        }
    }

    function openModal() {
        document.getElementById("addBillModal").style.display = "block";
        document.getElementById("table-container").style.display = "none";
        document.getElementById("add-btn").style.display = "none";
    }

    function closeModal() {
        document.getElementById("addBillModal").style.display = "none";
        document.getElementById("table-container").style.display = "block";
        document.getElementById("add-btn").style.display = "block";
    }

    document.getElementById('addBillForm').addEventListener('submit', async function(e) {
        e.preventDefault();
        const submitBtn = document.getElementById('submitBtn');
        const formData = new FormData(this);

        try {
            submitBtn.disabled = true;
            submitBtn.textContent = 'Adding...';

            const response = await fetch('${pageContext.request.contextPath}/admin/bills', {
                method: 'POST',
                body: new URLSearchParams(formData)
            });

            if (response.ok) {
                closeModal();
                location.reload();
            } else {
                const errorText = await response.text();
                alert(errorText || 'Failed to add bill');
            }
        } catch (error) {
            alert('Error: ' + error.message);
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Add Bill';
        }
    });
</script>
</body>
</html>