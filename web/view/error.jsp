<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f6f6f6;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .error-box {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
            max-width: 450px;
        }
        .error-box h1 {
            color: #e74c3c;
            font-size: 28px;
            margin-bottom: 15px;
        }
        .error-box p {
            color: #333;
            font-size: 16px;
            margin-bottom: 25px;
        }
        .btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            transition: background-color 0.2s;
        }
        .btn:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <div class="error-box">
        <h1>Error!!!</h1>
        <p><%= request.getAttribute("message") != null ? request.getAttribute("message") : "Have a error!" %></p>
    </div>
</body>
</html>
