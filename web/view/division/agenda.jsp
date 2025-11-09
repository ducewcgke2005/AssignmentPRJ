<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.iam.DayStatus" %>

<%
    ArrayList<DayStatus> days = (ArrayList<DayStatus>) request.getAttribute("days");
    int year = (int) request.getAttribute("year");
    int month = (int) request.getAttribute("month");
    model.Employee emp = (model.Employee) request.getAttribute("employee");
    YearMonth ym = YearMonth.of(year, month);

    // Chuyển java.sql.Date sang LocalDate
    LocalDate started = emp.getStartedDate() != null ? emp.getStartedDate().toLocalDate() : null;
    LocalDate today = LocalDate.now();
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Work Schedule <%= emp.getName() %></title>
        <style>
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                text-align: center;
                background: #f8f9fa;
                color: #333;
            }

            .header {
                font-size: 26px;
                margin-bottom: 15px;
                font-weight: 600;
            }

            form {
                margin-bottom: 20px;
            }

            select {
                padding: 5px 8px;
                margin-left: 5px;
                border-radius: 6px;
                border: 1px solid #ccc;
                outline: none;
                transition: all 0.3s ease;
            }

            select:hover, select:focus {
                border-color: #007bff;
                box-shadow: 0 0 3px rgba(0,123,255,0.3);
            }

            button {
                padding: 6px 12px;
                border: none;
                background: #007bff;
                color: white;
                border-radius: 6px;
                cursor: pointer;
                transition: background 0.3s, transform 0.2s;
            }

            button:hover {
                background: #0056b3;
                transform: translateY(-1px);
            }

            table {
                width: 80%;
                margin: 20px auto;
                border-collapse: collapse;
                background: #fff;
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }

            th {
                background-color: #007bff;
                color: white;
                padding: 12px 0;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            td {
                border: 1px solid #e0e0e0;
                padding: 12px 0;
                width: 14%;
                height: 80px;
                vertical-align: top;
                font-weight: 500;
                transition: 0.2s;
            }

            td:hover {
                transform: scale(1.03);
                box-shadow: 0 2px 6px rgba(0,0,0,0.15);
            }

            /* Trạng thái ngày */
            .working {
                background-color: #92D050;
                color: #FEFDFB;
            }
            .off {
                background-color: #FF0000;
                color: #800000;
            }
            .inactive {
                background-color: #f0f0f0;
                color: #888;
            }

            /* Chú thích màu */
            .legend {
                margin-top: 20px;
                font-size: 14px;
            }

            .legend span {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 1px solid #999;
                margin-right: 5px;
                vertical-align: middle;
            }

            a {
                text-decoration: none;
                color: #007bff;
                font-weight: 500;
            }

            a:hover {
                color: #0056b3;
            }

        </style>
    </head>
    <body>

        <div class="header">
            Work Schedule <strong><%= emp.getName() %></strong>
        </div>

        <form method="get" action="agenda">
            <input type="hidden" name="eid" value="<%= emp.getId() %>">
            <label>Month:
                <select name="month">
                    <% for (int m = 1; m <= 12; m++) { %>
                    <option value="<%= m %>" <%= (m == month ? "selected" : "") %>><%= m %></option>
                    <% } %>
                </select>
            </label>
            <label>Year:
                <select name="year">
                    <% int currentYear = LocalDate.now().getYear();
               for (int y = currentYear - 3; y <= currentYear + 3; y++) { %>
                    <option value="<%= y %>" <%= (y == year ? "selected" : "") %>><%= y %></option>
                    <% } %>
                </select>
            </label>
            <button type="submit">View</button>
        </form>

        <h3><%= month %>/<%= year %></h3>

        <table>
            <tr>
                <th>Su</th>
                <th>Mo</th>
                <th>Tu</th>
                <th>We</th>
                <th>Th</th>
                <th>Fr</th>
                <th>Sa</th>
            </tr>

            <%
                LocalDate firstDay = LocalDate.of(year, month, 1);
                int dayOfWeekValue = firstDay.getDayOfWeek().getValue() % 7;
                int totalDays = ym.lengthOfMonth();
                int dayCounter = 1;

                out.print("<tr>");
                for (int i = 0; i < dayOfWeekValue; i++) {
                    out.print("<td></td>");
                }

                for (int i = dayOfWeekValue; i < 7; i++) {
                    LocalDate date = LocalDate.of(year, month, dayCounter);
                    String status = "inactive";

                    if ((started != null && !date.isBefore(started)) && !date.isAfter(today)) {
                        for (DayStatus ds : days) {
                            if (ds.getDate().equals(date)) {
                                status = ds.getStatus(); // off hoặc working
                                break;
                            }
                        }
                    }

                    out.print("<td class='" + status + "'>" + dayCounter + "</td>");
                    dayCounter++;
                    if (dayCounter > totalDays) break;
                }
                out.print("</tr>");

                while (dayCounter <= totalDays) {
                    out.print("<tr>");
                    for (int i = 0; i < 7; i++) {
                        if (dayCounter > totalDays) {
                            out.print("<td></td>");
                        } else {
                            LocalDate date = LocalDate.of(year, month, dayCounter);
                            String status = "inactive";

                            if ((started != null && !date.isBefore(started)) && !date.isAfter(today)) {
                                for (DayStatus ds : days) {
                                    if (ds.getDate().equals(date)) {
                                        status = ds.getStatus();
                                        break;
                                    }
                                }
                            }

                            out.print("<td class='" + status + "'>" + dayCounter + "</td>");
                        }
                        dayCounter++;
                    }
                    out.print("</tr>");
                }
            %>
        </table>

        <div class="legend">
            <span style="background:#92D050"></span> Working
            <span style="background:#FF0000"></span> Leave
            <span style="background:#f0f0f0"></span> Do not have data
        </div>
        <br><br><!-- comment -->
        <a href="${pageContext.request.contextPath}/division/agenda">Back to view agenda list</a>

    </body>
</html>
