<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error - Task Manager</title>
    <!-- Prevent caching -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    <%
	    String contextPath = request.getContextPath();
	%>
	<link rel="stylesheet" href="<%= contextPath %>/css/style.css">
	<script src="${pageContext.request.contextPath}/js/noback.js"></script>
</head>
<body>
    <h2>Error</h2>
    <p>An error occurred while processing your request.</p>
    
    <% 
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p><strong>Details:</strong> <%= error %></p>
    <% } %>
    
    <p><a href="${pageContext.request.contextPath}/dashboard">Go to Dashboard</a></p>
</body>
</html>