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
            border-radius: 4px;
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

        .register-link {
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
            background: url('your-image.jpg') no-repeat center center;
            background-size: cover;
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
