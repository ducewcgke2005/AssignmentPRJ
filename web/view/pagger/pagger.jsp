<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:set var="viewType" value="${viewType}" />

<div class="pagination">
    <c:if test="${currentPage > 1}">
        <a href="?view=${viewType}&page=${currentPage-1}">&#x2B05;</a>
    </c:if>

    <c:set var="start" value="${currentPage - 2}" />
    <c:set var="end" value="${currentPage + 2}" />
    <c:if test="${start < 1}"><c:set var="start" value="1"/></c:if>
    <c:if test="${end > totalPages}"><c:set var="end" value="${totalPages}"/></c:if>

    <c:if test="${start > 1}">
        <a href="?view=${viewType}&page=1">1</a><span>...</span>
    </c:if>

    <c:forEach var="i" begin="${start}" end="${end}">
        <c:choose>
            <c:when test="${i == currentPage}">
                <span class="current">${i}</span>
            </c:when>
            <c:otherwise>
                <a href="?view=${viewType}&page=${i}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <c:if test="${end < totalPages}">
        <span>...</span>
        <a href="?view=${viewType}&page=${totalPages}">${totalPages}</a>
    </c:if>

    <c:if test="${currentPage < totalPages}">
        <a href="?view=${viewType}&page=${currentPage+1}">&#x27A1;</a>
    </c:if>
</div>


<style>
    .pagination {
        margin-top: 10px;
    }
    .pagination a {
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
        padding: 5px 10px;
        margin: 0 2px;
        font-weight: bold;
        border: 1px solid #333;
        background-color: #333;
        color: #fff;
    }
</style>
