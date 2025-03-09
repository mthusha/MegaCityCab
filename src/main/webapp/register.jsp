<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - MegaCity Cab</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            display: flex;
            height: 100vh;
        }

        .container {
            display: flex;
            width: 100%;
        }

        .left-panel {
            width: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #fff;
            padding: 2rem;
        }

        .register-container {
            width: 100%;
            max-width: 400px;
        }

        h1 {
            text-align: center;
            color: #f2d318;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #606770;
        }

        input {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #dddfe2;
            border-radius: 8px;
            box-sizing: border-box;
        }

        button {
                border: 1px solid !important;
                width: 100%;
                padding: 0.8rem;
                background-color: transparent;
                color: #f2d318;
                border: none;
                border-radius: 4px;
                font-size: 1rem;
                font-weight: bold;
                cursor: pointer;
                margin-top: 1rem;
        }

        button:hover {
            background-color: #f2d318;
            color: white;
        }

        .login-link {
            text-align: center;
            margin-top: 1rem;
        }

        a {
            color: #f2d318;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .right-panel {
            width: 50%;
            background: url('resource/img/log.jpg') no-repeat center center;
            background-size: cover;
        }

        .error {
            color: red;
            text-align: center;
            margin-bottom: 1rem;
            display: none;
        }
         @media (max-width: 768px), (max-device-width: 768px) {
          .right-panel {
                     display:none
                 }
          .left-panel {
              width: 100%;
           }
         }
    </style>
</head>
<body>
    <div class="container">
        <div class="left-panel">
            <div class="register-container">
                <h1>Register</h1>
                <div id="errorMessage" class="error"></div>
                <form id="registerForm">
                    <div class="form-group">
                        <label for="name">Full Name:</label>
                        <input type="text" id="name" name="name" required placeholder="Enter your full name">
                    </div>
                    <div class="form-group">
                        <label for="address">Address:</label>
                        <input type="text" id="address" name="address" required placeholder="Enter your address">
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone Number:</label>
                        <input type="tel" id="phone" name="phone" required placeholder="Enter your phone number">
                    </div>
                    <div class="form-group">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required placeholder="Enter your email">
                    </div>
                    <div class="form-group">
                        <label for="nic">NIC Number:</label>
                        <input type="text" id="nic" name="nic" required placeholder="Enter your NIC number">
                    </div>
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" required placeholder="Choose a username">
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" required placeholder="Create a password">
                    </div>
                    <button type="submit">Register</button>
                </form>
                <div class="login-link">
                    <span>Already have an account? </span>
                    <a href="login.jsp">Login here</a>
                </div>
            </div>
        </div>
        <div class="right-panel"></div>
    </div>
<script>
        document.getElementById('registerForm').addEventListener('submit', async function(e) {
            e.preventDefault();

            const formData = {
                name: document.getElementById('name').value,
                address: document.getElementById('address').value,
                phone: document.getElementById('phone').value,
                email: document.getElementById('email').value,
                nic: document.getElementById('nic').value,
                username: document.getElementById('username').value,
                password: document.getElementById('password').value
            };

            try {
                const response = await fetch('/Gradle___com_MegaCityCab___MegaCityCab_1_0_SNAPSHOT_war/customer', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(formData)
                });

                const errorDiv = document.getElementById('errorMessage');

                if (response.ok) {
                    errorDiv.style.display = 'none';
                     window.location.href = '/Gradle___com_MegaCityCab___MegaCityCab_1_0_SNAPSHOT_war/';
                } else {
                    const errorText = await response.text();
                    errorDiv.textContent = errorText || 'Registration failed';
                    errorDiv.style.display = 'block';
                }
            } catch (error) {
                const errorDiv = document.getElementById('errorMessage');
                errorDiv.textContent = 'An error occurred. Please try again.';
                errorDiv.style.display = 'block';
            }
        });
    </script>

</body>
</html>