<%-- 
    Document   : login
    Created on : Oct 18, 2025
    Author     : sonnt
--%>

<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login | Leave Management System</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: linear-gradient(135deg, #e3f2fd, #ffffff);
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            width: 380px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            padding: 35px 40px;
            text-align: center;
        }
        h2 {
            color: #333;
            margin-bottom: 25px;
            font-weight: 600;
        }
        label {
            display: block;
            text-align: left;
            margin-top: 12px;
            color: #444;
            font-weight: 600;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            transition: 0.3s;
        }
        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 5px rgba(0,123,255,0.3);
        }
        input[type="submit"] {
            width: 100%;
            background-color: #007bff;
            color: #fff;
            font-size: 16px;
            font-weight: 600;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 25px;
            transition: 0.3s;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .footer {
            margin-top: 20px;
            font-size: 13px;
            color: #777;
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Leave Management Login</h2>
    <form action="${pageContext.request.contextPath}/login" method="POST">
        <label for="txtUsername">Username:</label>
        <input type="text" name="username" id="txtUsername" required />

        <label for="txtPassword">Password:</label>
        <input type="password" name="password" id="txtPassword" required />

        <input type="submit" id="btnLogin" value="Login" />
    </form>

    <div class="footer">
        © 2025 Leave Management System
    </div>
</div>

</body>
</html>
