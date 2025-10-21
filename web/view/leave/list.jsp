<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.LeaveRequest" %>
<%
    ArrayList<LeaveRequest> list = (ArrayList<LeaveRequest>) request.getAttribute("requests");
    String viewType = (String) request.getAttribute("viewType");
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
        h2 {
            text-align: center;
            color: #2c3e50;
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
        a {
            text-decoration: none;
            color: #2980b9;
            font-weight: bold;
        }
        a:hover {
            color: #1a5276;
        }
        td:last-child a {
            background-color: #3498db;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
        }
        td:last-child a:hover {
            background-color: #217dbb;
        }
        .status-pending {
            color: #f39c12;
            font-weight: bold;
        }
        .status-approved {
            color: #27ae60;
            font-weight: bold;
        }
        .status-rejected {
            color: #e74c3c;
            font-weight: bold;
        }
    </style>
</head>
<body>
<h2>Leave Requests</h2>
<form method="get" action="<%=request.getContextPath()%>/request/list">
    <label>View:</label>
    <select name="view" onchange="this.form.submit()">
        <option value="mine" <%= "mine".equals(viewType)?"selected":"" %>>My Requests</option>
        <option value="subordinates" <%= "subordinates".equals(viewType)?"selected":"" %>>Subordinates' Requests</option>
    </select>
</form>
<br>
<table border="1" cellpadding="6" cellspacing="0">
    <tr><th>ID</th><th>Employee</th><th>From</th><th>To</th><th>Reason</th><th>Status</th><th>Processed By</th><th>Action</th></tr>
    <% for(LeaveRequest r : list) { %>
    <tr>
        <td><%=r.getId()%></td>
        <td><%=r.getCreatedBy().getName()%></td>
        <td><%=r.getFromDate()%></td>
        <td><%=r.getToDate()%></td>
        <td><%=r.getReason()%></td>
        <td><%=r.getStatus()==0?"Pending":r.getStatus()==1?"Approved":"Rejected"%></td>
        <td><%=r.getProcessedBy()!=null?r.getProcessedBy().getName():"-"%></td>
        <td><a href="<%=request.getContextPath()%>/request/review?id=<%=r.getId()%>">Review</a></td>
    </tr>
    <% } %>
</table>
</body>
</html>
