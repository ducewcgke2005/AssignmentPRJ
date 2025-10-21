<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.iam.User" %>
<%
    User user = (User) session.getAttribute("auth");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Project Manager Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: linear-gradient(135deg, #e8f0fe, #ffffff);
            margin: 0;
            padding: 0;
        }
        .container {
            width: 600px;
            background: #fff;
            margin: 60px auto;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            padding: 30px 40px;
            text-align: center;
        }
        h2 {
            color: #1a1a1a;
            margin-bottom: 15px;
        }
        h3 {
            color: #666;
            margin-bottom: 25px;
        }
        ul {
            list-style: none;
            padding: 0;
        }
        li {
            margin: 15px 0;
        }
        a {
            display: inline-block;
            width: 80%;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            padding: 12px 0;
            border-radius: 6px;
            font-size: 15px;
            transition: 0.3s;
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
        .footer {
            margin-top: 25px;
            font-size: 13px;
            color: #666;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Welcome, <%= user.getDisplayname() %></h2>
    <h3>Role: IT Project Manager</h3>

    <ul>
        <li><a href="<%= request.getContextPath() %>/request/create">➕ Create Leave Request</a></li>
        <li><a href="<%= request.getContextPath() %>/leave/list">📋 View All Leave Requests</a></li>
        <li><a href="<%= request.getContextPath() %>/request/review">✅ Approve / Reject Requests</a></li>
        <li><a href="<%= request.getContextPath() %>/logout" class="logout">🚪 Logout</a></li>
    </ul>

    <div class="footer">
        © 2025 Leave Management System
    </div>
</div>

</body>
</html>
