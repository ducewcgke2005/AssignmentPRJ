<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

        <c:choose>
            <c:when test="${empty requests}">
                <h3 style="color:red;text-align:center;">No requests found!</h3>
            </c:when>
            <c:otherwise>
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
                    <c:forEach var="r" items="${requests}">
                        <tr>
                            <td>${r.id}</td>
                            <td>${r.createdBy.name}</td>
                            <td>${r.fromDate}</td>
                            <td>${r.toDate}</td>
                            <td>${r.reason}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status == 0}">Pending</c:when>
                                    <c:when test="${r.status == 1}">Approved</c:when>
                                    <c:otherwise>Rejected</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status == 0}">
                                        <a href="${pageContext.request.contextPath}/request/review?id=${r.id}">Review</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: gray;">Processed</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>

        <c:set var="dashboardLink" value="#" />
        <c:choose>
            <c:when test="${roleName eq 'Employee'}">
                <c:set var="dashboardLink" value="${pageContext.request.contextPath}/view/dashboard/employeedash.jsp" />
            </c:when>
            <c:when test="${roleName eq 'IT PM'}">
                <c:set var="dashboardLink" value="${pageContext.request.contextPath}/view/dashboard/pmdash.jsp" />
            </c:when>
            <c:when test="${roleName eq 'IT Head'}">
                <c:set var="dashboardLink" value="${pageContext.request.contextPath}/view/dashboard/head.jsp" />
            </c:when>
        </c:choose>

        <a href="${dashboardLink}" class="dashboard">🏠 Back to Dashboard</a>
    </body>
</html>
