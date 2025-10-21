<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.LeaveRequest" %>
<%@ page import="model.iam.User" %>
<%@ page import="model.iam.Role" %>
<%
    // Lấy user đăng nhập
    User user = (User) session.getAttribute("auth");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
        return;
    }

    ArrayList<LeaveRequest> list = (ArrayList<LeaveRequest>) request.getAttribute("requests");
    String viewType = (String) request.getAttribute("viewType");


    String roleName = user.getRoles() != null && !user.getRoles().isEmpty()
            ? user.getRoles().get(0).getName()
            : "Employee";

    // Xác định dashboard URL tương ứng với role
    String dashboardUrl = request.getContextPath() + "/home";
    if (roleName.equalsIgnoreCase("IT Head")) {
        dashboardUrl = request.getContextPath() + "/view/dashboard/head.jsp";
    } else if (roleName.equalsIgnoreCase("IT PM") || roleName.equalsIgnoreCase("Head")) {
        dashboardUrl = request.getContextPath() + "/view/dashboard/pmdash.jsp";
    } else {
        dashboardUrl = request.getContextPath() + "/view/dashboard/employeedash.jsp";
    }

    // Kiểm tra quyền: chỉ Manager hoặc Head mới được xem cấp dưới
    boolean canViewSubordinates = roleName.equalsIgnoreCase("IT Head") || roleName.equalsIgnoreCase("IT PM") || roleName.equalsIgnoreCase("DivisionHead");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Leave Requests</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            color: #333;
            margin: 0;
            padding: 40px;
        }
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        h2 {
            color: #2c3e50;
            margin: 0;
        }
        a.back {
            text-decoration: none;
            background-color: #3498db;
            color: white;
            padding: 8px 14px;
            border-radius: 6px;
        }
        a.back:hover {
            background-color: #217dbb;
        }
        form {
            text-align: center;
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
            margin-right: 8px;
        }
        select {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
            background-color: #fff;
            cursor: pointer;
        }
        table {
            width: 90%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            border-radius: 6px;
            overflow: hidden;
        }
        th, td {
            padding: 10px 14px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }
        th {
            background-color: #2c3e50;
            color: white;
            text-transform: uppercase;
            font-size: 13px;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        tr:hover {
            background-color: #eaf2ff;
        }
        td:last-child a {
            background-color: #3498db;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            text-decoration: none;
        }
        td:last-child a:hover {
            background-color: #217dbb;
        }
    </style>
</head>
<body>
<div class="top-bar">
    <h2>Leave Requests</h2>
    <a href="<%= dashboardUrl %>" class="back">← Back to Dashboard</a>
</div>

<form method="get" action="<%=request.getContextPath()%>/request/list">
    <label>View:</label>
    <select name="view" onchange="this.form.submit()">
        <option value="mine" <%= "mine".equals(viewType)?"selected":"" %>>My Requests</option>
        <% if (canViewSubordinates) { %>
            <option value="subordinates" <%= "subordinates".equals(viewType)?"selected":"" %>>Subordinates' Requests</option>
        <% } %>
    </select>
</form>

<table>
    <tr>
        <th>ID</th>
        <th>Employee</th>
        <th>From</th>
        <th>To</th>
        <th>Reason</th>
        <th>Status</th>
        <th>Processed By</th>
    </tr>
    <% if (list != null && !list.isEmpty()) { 
        for (LeaveRequest r : list) { %>
        <tr>
            <td><%=r.getId()%></td>
            <td><%=r.getCreatedBy().getName()%></td>
            <td><%=r.getFromDate()%></td>
            <td><%=r.getToDate()%></td>
            <td><%=r.getReason()%></td>
            <td>
                <% if (r.getStatus() == 0) { %>
                    <span class="status-pending">Pending</span>
                <% } else if (r.getStatus() == 1) { %>
                    <span class="status-approved">Approved</span>
                <% } else { %>
                    <span class="status-rejected">Rejected</span>
                <% } %>
            </td>
            <td><%=r.getProcessedBy() != null ? r.getProcessedBy().getName() : "-" %></td>
        </tr>
    <% } } else { %>
        <tr><td colspan="8">No requests found.</td></tr>
    <% } %>
</table>
</body>
</html>
