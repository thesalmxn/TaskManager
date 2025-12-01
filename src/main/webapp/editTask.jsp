<%@ page import="model.User, model.Project, model.Task, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Project project = (Project) request.getAttribute("project");
    Task task = (Task) request.getAttribute("task");
    Boolean editMode = (Boolean) request.getAttribute("editMode");
    
    if (project == null) {
        response.sendRedirect(request.getContextPath() + "/projects");
        return;
    }
    
    String action = (task != null && editMode != null && editMode) ? "update" : "create";
    String title = (task != null && editMode != null && editMode) ? "Edit Task" : "Create New Task";
    String buttonText = (task != null && editMode != null && editMode) ? "Update Task" : "Create Task";
    
    // Format due date for input field
    String dueDateStr = "";
    if (task != null && task.getDueDate() != null) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        dueDateStr = sdf.format(task.getDueDate());
    }
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
        <p>Project: <strong><%= project.getName() %></strong></p>
        <a href="${pageContext.request.contextPath}/projects?action=view&id=<%= project.getId() %>">Back to Project</a> | 
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a> | 
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
    
    <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
    <% } %>
    
    <form action="${pageContext.request.contextPath}/tasks" method="post">
        <input type="hidden" name="action" value="<%= action %>">
        <input type="hidden" name="projectId" value="<%= project.getId() %>">
        
        <% if (task != null && editMode != null && editMode) { %>
            <input type="hidden" name="id" value="<%= task.getId() %>">
        <% } %>
        
        <div class="form-group">
            <label for="title">Title:</label>
            <input type="text" id="title" name="title" 
                   value="<%= task != null ? task.getTitle() : "" %>" 
                   required style="width: 300px;">
        </div>
        
        <div class="form-group">
            <label for="description">Description:</label><br>
            <textarea id="description" name="description" rows="4" style="width: 300px;"><%= 
                task != null && task.getDescription() != null ? task.getDescription() : "" 
            %></textarea>
        </div>
        
        <div class="form-group">
            <label for="status">Status:</label>
            <select id="status" name="status">
                <option value="todo" <%= (task != null && "todo".equals(task.getStatus())) ? "selected" : "" %>>To Do</option>
                <option value="in_progress" <%= (task != null && "in_progress".equals(task.getStatus())) ? "selected" : "" %>>In Progress</option>
                <option value="done" <%= (task != null && "done".equals(task.getStatus())) ? "selected" : "" %>>Done</option>
            </select>
        </div>
        
        <div class="form-group">
            <label for="priority">Priority:</label>
            <select id="priority" name="priority">
                <option value="low" <%= (task != null && "low".equals(task.getPriority())) ? "selected" : "" %>>Low</option>
                <option value="medium" <%= (task != null && "medium".equals(task.getPriority())) || (task == null) ? "selected" : "" %>>Medium</option>
                <option value="high" <%= (task != null && "high".equals(task.getPriority())) ? "selected" : "" %>>High</option>
            </select>
        </div>
        
        <div class="form-group">
            <label for="dueDate">Due Date:</label>
            <input type="date" id="dueDate" name="dueDate" 
                   value="<%= dueDateStr %>" style="width: 200px;">
        </div>
        
        <div class="form-group">
            <input type="submit" value="<%= buttonText %>">
            <a href="${pageContext.request.contextPath}/projects?action=view&id=<%= project.getId() %>" style="margin-left: 20px;">Cancel</a>
        </div>
    </form>
</body>
</html>