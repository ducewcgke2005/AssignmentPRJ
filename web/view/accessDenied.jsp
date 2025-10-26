<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chua dang nhap</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background-color: #f8f9fa; }
        .box { background-color: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 0 10px #ccc; display: inline-block; }
        h1 { color: #dc3545; }
        button {
            padding: 10px 20px; 
            font-size: 16px; 
            margin-top: 20px; 
            cursor: pointer; 
            background-color: #007bff; 
            color: white; 
            border: none; 
            border-radius: 5px;
        }
        button:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <div class="box">
        <h1>You have not login yet!</h1>
        <br><br>
        <form action="<%=request.getContextPath()%>/login" method="get">
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
