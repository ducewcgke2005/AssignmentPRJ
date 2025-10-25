<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.LeaveRequest" %>
<%@ page import="model.Employee" %>

<%
    LeaveRequest r = (LeaveRequest) request.getAttribute("request");
    String roleName = (String) request.getAttribute("roleName");
    if (r == null) {
        out.println("<h3 style='color:red;text-align:center;'>No request found!</h3>");
        return;
    }

    String dashboardLink = "#";
    if (roleName != null) {
        if (roleName.equalsIgnoreCase("Employee")) {
            dashboardLink = request.getContextPath() + "/view/dashboard/employeedash.jsp";
        } else if (roleName.equalsIgnoreCase("IT PM")) {
            dashboardLink = request.getContextPath() + "/view/dashboard/pmdash.jsp";
        } else if (roleName.equalsIgnoreCase("IT Head")) {
            dashboardLink = request.getContextPath() + "/view/dashboard/head.jsp";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Review Leave Request</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f8fa;
            padding: 40px;
        }
        .container {
            width: 500px;
            margin: auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            padding: 25px;
        }
        h2 { text-align: center; color: #333; }
        p { font-size: 15px; margin: 8px 0; }
        .actions { text-align: center; margin-top: 20px; }
        button {
            padding: 10px 20px; border: none; border-radius: 6px;
            font-size: 14px; cursor: pointer; margin: 5px;
        }
        .approve { background-color: #28a745; color: white; }
        .reject { background-color: #dc3545; color: white; }
        .back, .dashboard {
            display: block; text-align: center; margin-top: 15px;
            color: #007bff; text-decoration: none;
        }
        .back:hover, .dashboard:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <h2>Review Leave Request</h2>

    <p><b>Employee:</b> <%= r.getCreatedBy().getName() %></p>
    <p><b>From:</b> <%= r.getFromDate() %></p>
    <p><b>To:</b> <%= r.getToDate() %></p>
    <p><b>Reason:</b> <%= r.getReason() %></p>
    <p><b>Status:</b> 
        <%= (r.getStatus() == 0 ? "Pending" : r.getStatus() == 1 ? "Approved" : "Rejected") %>
    </p>
    <% if (r.getProcessedBy() != null) { %>
        <p><b>Processed By:</b> <%= r.getProcessedBy().getName() %></p>
    <% } %>

    <form action="<%= request.getContextPath() %>/request/review" method="post" class="actions">
        <input type="hidden" name="id" value="<%= r.getId() %>">
        <button type="submit" name="action" value="approve" class="approve">Approve</button>
        <button type="submit" name="action" value="reject" class="reject">Reject</button>
    </form>

    <a href="<%= request.getContextPath() %>/request/review" class="back">← Back to Review List</a>
</div>
</body>
</html>
