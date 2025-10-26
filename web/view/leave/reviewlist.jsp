<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.LeaveRequest" %>
<%@ page import="model.Employee" %>

<%
    ArrayList<LeaveRequest> requests = (ArrayList<LeaveRequest>) request.getAttribute("requests");
    String roleName = (String) request.getAttribute("roleName");

    if (requests == null || requests.isEmpty()) {
        out.println("<h3 style='color:red;text-align:center;'>No requests found!</h3>");
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
        <title>Review Leave Requests</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f6f8;
                padding: 40px;
            }
            h2 {
                text-align: center;
            }
            table {
                width: 90%;
                margin: auto;
                border-collapse: collapse;
                background: white;
                box-shadow: 0 3px 8px rgba(0,0,0,0.1);
            }
            th, td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: center;
            }
            th {
                background: #007bff;
                color: white;
            }
            tr:hover {
                background-color: #f1f1f1;
            }
            a {
                color: #007bff;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
            .dashboard {
                display: block;
                width: fit-content;
                margin: 30px auto;
                background: #28a745;
                color: white;
                padding: 10px 20px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: bold;
            }
            .dashboard:hover {
                background: #218838;
            }
        </style>
    </head>
    <body>
        <h2>Leave Requests to Review</h2>

        <table>
            <tr>
                <th>ID</th>
                <th>Employee</th>
                <th>From</th>
                <th>To</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <% if (requests != null && !requests.isEmpty()) { 
               for (LeaveRequest r : requests) { %>
            <tr>
                <td><%= r.getId() %></td>
                <td><%= r.getCreatedBy().getName() %></td>
                <td><%= r.getFromDate() %></td>
                <td><%= r.getToDate() %></td>
                <td><%= r.getReason() %></td>
                <td>
                    <%= (r.getStatus() == 0 ? "Pending" : r.getStatus() == 1 ? "Approved" : "Rejected") %>
                </td>
                <!--                <td>
                                    <a href="<%= request.getContextPath() %>/request/review?id=<%= r.getId() %>">Review</a>
                                </td>-->
                <td>
                    <% if (r.getStatus() == 0) { %>
                    <a href="<%= request.getContextPath() %>/request/review?id=<%= r.getId() %>">Review</a>
                    <% } else { %>
                    <span style="color: gray;">Processed</span>
                    <% } %>
                </td>

            </tr>
            <%   } 
           } else { %>
            <tr><td colspan="7">No requests to review.</td></tr>
            <% } %>
        </table>

        <a href="<%= dashboardLink %>" class="dashboard">🏠 Back to Dashboard</a>
    </body>
</html>
