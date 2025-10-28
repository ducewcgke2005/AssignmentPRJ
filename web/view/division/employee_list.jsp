<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Employee" %>

<%
    ArrayList<Employee> employees = (ArrayList<Employee>) request.getAttribute("employees");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Division Employees</title>
    <style>
        /* Reset cơ bản */
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #eef2f7, #d6e0f0);
            color: #333;
            padding: 50px 20px;
        }

        h2 {
            text-align: center;
            font-size: 36px;
            color: #1a3e72;
            margin-bottom: 40px;
            letter-spacing: 1px;
        }

        .table-container {
            width: 80%;
            max-width: 900px;
            margin: 0 auto;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 16px;
        }

        th, td {
            padding: 15px 20px;
            text-align: left;
        }

        th {
            background: #0078D7;
            color: #fff;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        tr {
            transition: all 0.3s ease;
        }

        tr:nth-child(even) {
            background: #f7f9fc;
        }

        tr:hover {
            background: #e1f0ff;
            transform: scale(1.01);
        }

        a.button {
            display: inline-block;
            padding: 8px 16px;
            background: #0078D7;
            color: #fff;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        a.button:hover {
            background: #005fa3;
            transform: translateY(-2px);
        }

        .no-data {
            text-align: center;
            padding: 20px;
            font-style: italic;
            color: #666;
        }

        .back-link {
            display: block;
            width: max-content;
            margin: 40px auto 0;
            padding: 10px 20px;
            text-decoration: none;
            color: #0078D7;
            font-weight: 500;
            border: 2px solid #0078D7;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            background: #0078D7;
            color: #fff;
        }

        @media screen and (max-width: 768px) {
            .table-container {
                width: 95%;
            }

            th, td {
                padding: 12px 10px;
            }

            h2 {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
    <h2>Employees</h2>

    <div class="table-container">
        <table>
            <tr>
                <th>Employee ID</th>
                <th>Employee Name</th>
                <th></th>
            </tr>

            <%
                if (employees == null || employees.isEmpty()) {
            %>
            <tr>
                <td colspan="3" class="no-data">Khong co nhan vien nao trong danh sach.</td>
            </tr>
            <%
                } else {
                    for (Employee e : employees) {
            %>
            <tr>
                <td><%= e.getId() %></td>
                <td><%= e.getName() %></td>
                <td><a class="button" href="agenda?eid=<%= e.getId() %>">View Agenda</a></td>
            </tr>
            <%
                    }
                }
            %>
        </table>
    </div>

    <a href="${pageContext.request.contextPath}/home" class="back-link">Back to dashboard</a>
</body>
</html>
