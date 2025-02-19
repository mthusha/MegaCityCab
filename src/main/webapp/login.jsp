<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
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

        .login-container {
            width: 100%;
            max-width: 400px;
        }

        h1 {
            text-align: center;
            color: #1877f2;
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
            border-radius: 4px;
            box-sizing: border-box;
        }

        button {
            width: 100%;
            padding: 0.8rem;
            background-color: #1877f2;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            margin-top: 1rem;
        }

        button:hover {
            background-color: #166fe5;
        }

        .register-link {
            text-align: center;
            margin-top: 1rem;
        }

        a {
            color: #1877f2;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .right-panel {
            width: 50%;
            background: url('your-image.jpg') no-repeat center center;
            background-size: cover;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="left-panel">
            <div class="login-container">
                <h1>Login</h1>
                 <% String errorMessage = request.getParameter("error"); %>
                 <% if (errorMessage != null) { %>
                     <p style="color: red;"><%= errorMessage %></p>
                 <% } %>
                <form method="post" action="login">
                    <div class="form-group">
                        <label for="username">Username:</label>
                        <input type="text" id="username" name="username" required placeholder="Enter your username">
                    </div>
                    <div class="form-group">
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" required placeholder="Enter your password">
                    </div>
                    <button type="submit">Login</button>
                </form>
                <div class="register-link">
                    <span>Don't have an account? </span>
                    <a href="register.jsp">Register here</a>
                </div>
            </div>
        </div>
        <div class="right-panel"></div>
    </div>

</body>
</html>
