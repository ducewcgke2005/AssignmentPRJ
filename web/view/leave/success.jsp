<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.iam.User" %>
<%
    User user = (User) session.getAttribute("auth");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Leave Request Result</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .box {
            background: #fff;
            border-radius: 10px;
            padding: 30px 40px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #28a745;
        }
        p {
            font-size: 18px;
            color: #333;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }
        a:hover {
            background-color: #0056b3;
        }
        .error h2 {
            color: #dc3545;
        }
    </style>
</head>
<body>
<div class="box <%= "Submit Failed. Please try again!".equals(request.getAttribute("message")) ? "error" : "" %>">
    <h2><%= request.getAttribute("message") %></h2>
    <p>Thank you for submitting your leave request.</p>
    <a href="<%= request.getContextPath() %>/home">Back to Dashboard</a>
</div>
</body>
</html>
