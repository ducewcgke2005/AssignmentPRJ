<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.iam.User" %>
<%@ page import="model.Employee" %>
<%
    User user = (User) request.getAttribute("user");
    Employee emp = user.getEmployee();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>
    <h2>Welcome, <%= emp.getName() %>!</h2>
    <p>Username: <%= user.getUsername() %></p>
    <p>Display name: <%= user.getDisplayname() %></p>

    <a href="<%= request.getContextPath() %>/leave/list">View Leave Requests</a>
    <br><br>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
</body>
</html>
