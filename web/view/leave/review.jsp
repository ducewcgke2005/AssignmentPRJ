<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
            h2 {
                text-align: center;
                color: #333;
            }
            p {
                font-size: 15px;
                margin: 8px 0;
            }
            .actions {
                text-align: center;
                margin-top: 20px;
            }
            button {
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                cursor: pointer;
                margin: 5px;
            }
            .approve {
                background-color: #28a745;
                color: white;
            }
            .reject {
                background-color: #dc3545;
                color: white;
            }
            .back, .dashboard {
                display: block;
                text-align: center;
                margin-top: 15px;
                color: #007bff;
                text-decoration: none;
            }
            .back:hover, .dashboard:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <c:choose>
            <c:when test="${empty requestScope.request}">
                <h3 style="color:red;text-align:center;">No request found!</h3>
                <c:remove var="request" scope="request"/>
                <c:redirect url="${pageContext.request.contextPath}/request/review" />
            </c:when>
        </c:choose>

        <c:set var="r" value="${requestScope.request}" />
        <c:set var="dashboardLink" value="#" />

        <c:choose>
            <c:when test="${roleName eq 'Employee'}">
                <c:set var="dashboardLink" value='${pageContext.request.contextPath}/view/dashboard/employeedash.jsp' />
            </c:when>
            <c:when test="${roleName eq 'IT PM'}">
                <c:set var="dashboardLink" value='${pageContext.request.contextPath}/view/dashboard/pmdash.jsp' />
            </c:when>
            <c:when test="${roleName eq 'IT Head'}">
                <c:set var="dashboardLink" value='${pageContext.request.contextPath}/view/dashboard/head.jsp' />
            </c:when>
        </c:choose>

        <div class="container">
            <h2>Review Leave Request</h2>

            <p><b>Employee:</b> ${r.createdBy.name}</p>
            <p><b>From:</b> ${r.fromDate}</p>
            <p><b>To:</b> ${r.toDate}</p>
            <p><b>Reason:</b> ${r.reason}</p>
            <p><b>Status:</b>
                <c:choose>
                    <c:when test="${r.status == 0}">Pending</c:when>
                    <c:when test="${r.status == 1}">Approved</c:when>
                    <c:otherwise>Rejected</c:otherwise>
                </c:choose>
            </p>

            <c:if test="${not empty r.processedBy}">
                <p><b>Processed By:</b> ${r.processedBy.name}</p>
            </c:if>

            <form action="${pageContext.request.contextPath}/request/review" method="post" class="actions">
                <input type="hidden" name="id" value="${r.id}">
                <button type="submit" name="action" value="approve" class="approve">Approve</button>
                <button type="submit" name="action" value="reject" class="reject">Reject</button>
            </form>

            <a href="${pageContext.request.contextPath}/request/review" class="back">← Back to Review List</a>
        </div>

    </body>
</html>
