<%@ page import="model.User, model.Project" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Project project = (Project) request.getAttribute("project");
    Boolean editMode = (Boolean) request.getAttribute("editMode");
    
    if (project == null && editMode != null && editMode) {
        response.sendRedirect(request.getContextPath() + "/projects");
        return;
    }
    
    String action = (project != null && editMode != null && editMode) ? "update" : "create";
    String title = (project != null && editMode != null && editMode) ? "Edit Project" : "Create New Project";
    String buttonText = (project != null && editMode != null && editMode) ? "Update Project" : "Create Project";
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= title %> - Task Manager</title>
    <!-- <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .nav { margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        .error { color: red; }
        label { display: inline-block; width: 100px; }
    </style> -->
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
    <div class="nav">
        <h2><%= title %></h2>
        <a href="${pageContext.request.contextPath}/projects">Back to Projects</a> | 
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a> | 
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
    
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    
    <form action="${pageContext.request.contextPath}/projects" method="post">
        <input type="hidden" name="action" value="<%= action %>">
        
        <% if (project != null && editMode != null && editMode) { %>
            <input type="hidden" name="id" value="<%= project.getId() %>">
        <% } %>
        
        <div class="form-group">
            <label for="name">Project Name:</label>
            <input type="text" id="name" name="name" 
                   value="<%= project != null ? project.getName() : "" %>" 
                   required style="width: 300px;">
        </div>
        
        <div class="form-group">
            <label for="description">Description:</label><br>
            <textarea id="description" name="description" rows="4" style="width: 300px;"><%= 
                project != null && project.getDescription() != null ? project.getDescription() : "" 
            %></textarea>
        </div>
        
        <div class="form-group">
            <input type="submit" value="<%= buttonText %>">
            <a href="${pageContext.request.contextPath}/projects" style="margin-left: 20px;">Cancel</a>
        </div>
    </form>
</body>
</html>