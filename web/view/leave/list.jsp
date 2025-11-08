<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
            .pagination {
                text-align: center;
                margin-top: 10px;
                padding: 15px
            }

            .pagination a, .pagination .current {
                padding: 5px 10px;
                margin: 0 2px;
                text-decoration: none;
                border: 1px solid #ccc;
                color: #333;
            }

            .pagination a:hover {
                background-color: #eee;
            }

            .pagination .current {
                font-weight: bold;
                background-color: #333;
                color: #fff;
            }

            form[action$="/request/search"] {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 15px;
                background-color: #f8f9fa;
                padding: 10px 15px;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                width: 40%;               /* ✅ Responsive theo % */
                margin-left: auto;
                margin-right: auto;
                min-width: 250px;         /* ✅ Không nhỏ quá */
                max-width: 600px;         /* ✅ Giới hạn trên */
            }

            form[action$="/request/search"] input[type="text"] {
                padding: 8px 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                flex: 1;
                font-size: 14px;
                transition: border-color 0.2s ease;
            }

            form[action$="/request/search"] input[type="text"]:focus {
                border-color: #007bff;
                outline: none;
            }

            form[action$="/request/search"] button {
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                padding: 8px 16px;
                cursor: pointer;
                transition: background-color 0.2s ease;
            }

            form[action$="/request/search"] button:hover {
                background-color: #0056b3;
            }

        </style>
    </head>
    <body>

        <c:choose>
            <c:when test="${empty sessionScope.auth}">
                <c:redirect url="${pageContext.request.contextPath}/view/auth/login.jsp" />
            </c:when>
        </c:choose>

        <c:set var="user" value="${sessionScope.auth}" />
        <c:set var="roleName" value="${not empty user.roles ? user.roles[0].name : 'Employee'}" />

        <c:set var="dashboardUrl" value="${pageContext.request.contextPath}/view/dashboard/employeedash.jsp" />
        <c:choose>
            <c:when test="${roleName eq 'IT Head'}">
                <c:set var="dashboardUrl" value='${pageContext.request.contextPath}/view/dashboard/head.jsp' />
            </c:when>
            <c:when test="${roleName eq 'IT PM' or roleName eq 'Head'}">
                <c:set var="dashboardUrl" value='${pageContext.request.contextPath}/view/dashboard/pmdash.jsp' />
            </c:when>
        </c:choose>

        <c:set var="canViewSubordinates" value="${roleName eq 'IT Head' or roleName eq 'IT PM' or roleName eq 'DivisionHead'}" />

        <div class="top-bar">
            <h2>Leave Requests</h2>
            <a href="${dashboardUrl}" class="back">← Back to Dashboard</a>
        </div>



        <c:if test="${roleName eq 'IT Head' or roleName eq 'IT PM'}">
            <form action="${pageContext.request.contextPath}/request/search" method="get">
                <input type="text" name="name" placeholder="Nhap ten nhan vien">
                <button type="submit">Search</button>
            </form>
        </c:if>


        <form method="get" action="${pageContext.request.contextPath}/request/list">
            <label>View:</label>
            <select name="view" onchange="this.form.submit()">
                <option value="mine" ${viewType eq 'mine' ? 'selected' : ''}>My Requests</option>
                <c:if test="${canViewSubordinates}">
                    <option value="subordinates" ${viewType eq 'subordinates' ? 'selected' : ''}>Subordinates' Requests</option>
                </c:if>
            </select>
        </form>

        <table>
            <tr>
                <th>ID</th>
                <th>Employee ID</th>
                <th>Employee</th>
                <th>From</th>
                <th>To</th>
                <th>Reason</th>
                <th>Status</th>
                <th>Processed By</th>
            </tr>

            <c:choose>
                <c:when test="${not empty requests}">
                    <c:forEach var="r" items="${requests}">
                        <tr>
                            <td>${r.id}</td>
                            <td>${r.createdBy.id}</td>
                            <td>${r.createdBy.name}</td>
                            <td>${r.fromDate}</td>
                            <td>${r.toDate}</td>
                            <td>${r.reason}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status == 0}">In progress</c:when>
                                    <c:when test="${r.status == 1}">Approved</c:when>
                                    <c:otherwise>Rejected</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty r.processedBy}">
                                        ${r.processedBy.name}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="8">No requests found.</td></tr>
                </c:otherwise>
            </c:choose>
        </table>
        <div class="pagination">
            <jsp:include page="/view/pagger/pagger.jsp" />
        </div>
    </body>
</html>
