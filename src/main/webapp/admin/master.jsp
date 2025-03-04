<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Master Layout</title>

    <style>
    body {
        margin: 0;
        padding: 0;
        font-family: sans-serif;
    }
    .content {
        margin-left: 200px;
        min-height: 86vh;
        padding: 8px;
        box-sizing: border-box;
        background-color: #f0f0f0;
        border-radius: 10px;
    }
       .footer {
           font-size: 12px;
           height: 28px;
           background-color: #ffffff;
           color: #f5c335;
           text-align: center;
           padding: 10px;
           position: fixed;
           width: 100%;
           bottom: 0;
        }
    @media (max-width: 768px) {
        .content {
            margin-left: 0;
        }
    }
    </style>
</head>
<body>
    <%@ include file="components/header.jsp" %>
    <%@ include file="components/sidebar.jsp" %>
    <div class="content">
        <iframe name="contentFrame" src="pages/dashboard.jsp" style="border:none; width:100%; height:100%;"></iframe>
    </div>
     <%@ include file="components/footer.jsp" %>
</body>
</html>
