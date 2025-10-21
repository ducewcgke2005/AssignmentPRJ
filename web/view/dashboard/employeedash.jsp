<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.iam.User" %>
<%@ page import="model.Employee" %>

<%
    // Lay user dang dang nhap tu session
    User user = (User) session.getAttribute("auth");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    Employee emp = user.getEmployee();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 40px;
        }
        .container {
            width: 500px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            margin: 0 auto;
            padding: 25px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        p {
            font-size: 15px;
            color: #444;
        }
        a {
            display: inline-block;
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 10px 15px;
            border-radius: 6px;
            margin-top: 10px;
        }
        a:hover {
            background-color: #0056b3;
        }
        .logout {
            background-color: #dc3545;
        }
        .logout:hover {
            background-color: #b02a37;
        }
        .links {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Welcome, <%= emp.getName() %>!</h2>
    <p><strong>Username:</strong> <%= user.getUsername() %></p>
    <p><strong>Display name:</strong> <%= user.getDisplayname() %></p>

    <div class="links">
        <a href="<%= request.getContextPath() %>/request/create">Create Leave Request</a>
        <a href="<%= request.getContextPath() %>/leave/list">View Leave Requests</a>
        <br><br>
        <a href="<%= request.getContextPath() %>/logout" class="logout">Logout</a>
    </div>
</div>

</body>
</html>
