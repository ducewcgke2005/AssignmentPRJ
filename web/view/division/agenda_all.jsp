<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.EmployeeAgenda, model.iam.DayStatus" %>

<%
    ArrayList<EmployeeAgenda> agendas = (ArrayList<EmployeeAgenda>) request.getAttribute("agendas");
    ArrayList<LocalDate[]> weeks = (ArrayList<LocalDate[]>) request.getAttribute("weeks");
    LocalDate weekFrom = (LocalDate) request.getAttribute("weekFrom");
    LocalDate weekTo = (LocalDate) request.getAttribute("weekTo");

    DateTimeFormatter df = DateTimeFormatter.ofPattern("dd/MM");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>All Employees Agenda</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 20px;
                background: #f4f6f9;
            }
            h2 {
                text-align: center;
                color: #1a3e72;
                margin-bottom: 20px;
            }
            table {
                border-collapse: collapse;
                width: 95%;
                margin: auto;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: center;
            }
            th {
                background: #0078D7;
                color: #fff;
            }
            .working {
                background: #92D050;
                color: #fff;
            }  /* xanh lá đậm */
            .off {
                background: #FF0000;
                color: #fff;
            }      /* đỏ đậm */
            .inactive {
                background: #e2e3e5;
                color: #666;
            } /* xám trước ngày bắt đầu */
            .future {
                background: #f0f0f0;
                color: #999;
            }   /* xám sau hiện tại */

            .dropdown {
                text-align: center;
                margin-bottom: 20px;
            }
            select {
                padding: 5px 10px;
                font-size: 16px;
            }
            .back-link {
                display: block;
                width: max-content;
                margin: 20px auto;
                padding: 10px 20px;
                text-decoration: none;
                color: #0078D7;
                border: 2px solid #0078D7;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            .back-link:hover {
                background: #0078D7;
                color: #fff;
            }
            @media screen and (max-width: 768px) {
                table {
                    font-size: 12px;
                }
            }
        </style>
    </head>
    <body>

        <h2>All Employees Agenda ( <%= df.format(weekFrom) %> - <%= df.format(weekTo) %> )</h2>

        <div class="dropdown">
            <form method="get">
                <label for="weekSelect">Chọn tuần: </label>
                <select id="weekSelect" name="week" onchange="this.form.submit()">
                    <%
                        for (LocalDate[] w : weeks) {
                            String value = w[0].toString() + "_" + w[1].toString();
                            String label = df.format(w[0]) + " - " + df.format(w[1]);
                            boolean selected = w[0].equals(weekFrom) && w[1].equals(weekTo);
                    %>
                    <option value="<%= value %>" <%= selected ? "selected" : "" %>><%= label %></option>
                    <%
                        }
                    %>
                </select>
            </form>
        </div>

        <table>
            <tr>
                <th>Employee</th>
                    <%
                        LocalDate date = weekFrom;
                        String[] thuNames = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ nhật"};
                        int thuIndex = 0;
                        while (!date.isAfter(weekTo)) {
                    %>
                <th><%= thuNames[thuIndex++] %></th>
                    <%
                            date = date.plusDays(1);
                        }
                    %>
            </tr>

            <%
                for (EmployeeAgenda ea : agendas) {
            %>
            <tr>
                <td><%= ea.getEmployee().getName() %></td>
                <%
                    for (DayStatus ds : ea.getDays()) {
                %>
                <td class="<%= ds.getStatus() %>"></td>
                <%
                    }
                %>
            </tr>
            <%
                }
            %>
        </table>

        <a href="${pageContext.request.contextPath}/division/agenda" class="back-link">Back</a>

    </body>
</html>
