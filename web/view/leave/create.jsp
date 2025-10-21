<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.iam.User" %>
<%@ page import="model.Employee" %>

<%
    // Lay thong tin nguoi dung dang dang nhap
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
    <title>Create Leave Request</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: linear-gradient(135deg, #e9f3ff, #fefefe);
            margin: 0;
            padding: 0;
        }
        .container {
            width: 450px;
            margin: 60px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            padding: 35px 30px;
            transition: 0.3s ease;
        }
        .container:hover {
            transform: translateY(-3px);
        }
        h2 {
            text-align: center;
            color: #1a1a1a;
            margin-bottom: 25px;
            letter-spacing: 0.5px;
        }
        label {
            display: block;
            font-weight: 600;
            margin-top: 12px;
            color: #333;
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            transition: 0.2s;
        }
        input:focus, textarea:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 5px rgba(0,123,255,0.3);
        }
        textarea {
            resize: none;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            margin-top: 25px;
            cursor: pointer;
            transition: 0.3s ease;
        }
        button:hover {
            background-color: #0056b3;
        }
        .top-link {
            text-align: right;
            margin-bottom: 10px;
        }
        .top-link a {
            text-decoration: none;
            color: #007bff;
            font-weight: 600;
        }
        .top-link a:hover {
            color: #0056b3;
            text-decoration: underline;
        }
        .footer {
            text-align: center;
            margin-top: 15px;
            font-size: 13px;
            color: #666;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="top-link">
        <a href="<%= request.getContextPath() %>/home">← Back to Dashboard</a>
    </div>

    <h2>Create Leave Request</h2>

    <form action="<%= request.getContextPath() %>/request/create" method="post">
        <label>Employee Name:</label>
        <input type="text" name="employeeName" value="<%= emp.getName() %>" readonly>

        <label>From Date:</label>
        <input type="date" name="from" required>

        <label>To Date:</label>
        <input type="date" name="to" required>

        <label>Reason:</label>
        <textarea name="reason" rows="4" placeholder="Enter reason for leave..." required></textarea>

        <button type="submit">Submit Leave Request</button>
    </form>

    <div class="footer">
        © 2025 Leave Management System
    </div>
</div>

</body>
</html>
