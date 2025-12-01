<%@ page import="model.User, model.Project, model.Task, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Project project = (Project) request.getAttribute("project");
    List<Task> tasks = (List<Task>) request.getAttribute("tasks");
    String statusFilter = (String) request.getAttribute("statusFilter");
    String priorityFilter = (String) request.getAttribute("priorityFilter");
    String sortBy = (String) request.getAttribute("sortBy");
    
    if (project == null) {
        response.sendRedirect(request.getContextPath() + "/projects");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= project.getName() %> - Tasks</title>
    <!-- <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .nav { margin-bottom: 20px; }
        .filters { background-color: #f9f9f9; padding: 15px; margin: 20px 0; }
        .status-todo { color: #d9534f; }
        .status-inprogress { color: #f0ad4e; }
        .status-done { color: #5cb85c; }
        .priority-high { color: #d9534f; font-weight: bold; }
        .priority-medium { color: #f0ad4e; }
        .priority-low { color: #5bc0de; }
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
        <h2><%= project.getName() %></h2>
        <p><%= project.getDescription() != null ? project.getDescription() : "" %></p>
        <a href="${pageContext.request.contextPath}/projects">Back to Projects</a> | 
        <a href="${pageContext.request.contextPath}/tasks?projectId=<%= project.getId() %>">Add New Task</a> | 
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a> | 
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
    
    <div class="filters">
        <h3>Filter Tasks</h3>
        <form method="get">
            <input type="hidden" name="action" value="view">
            <input type="hidden" name="id" value="<%= project.getId() %>">
            
            <label>Status:</label>
            <select name="statusFilter">
                <option value="">All</option>
                <option value="todo" <%= "todo".equals(statusFilter) ? "selected" : "" %>>To Do</option>
                <option value="in_progress" <%= "in_progress".equals(statusFilter) ? "selected" : "" %>>In Progress</option>
                <option value="done" <%= "done".equals(statusFilter) ? "selected" : "" %>>Done</option>
            </select>
            
            <label>Priority:</label>
            <select name="priorityFilter">
                <option value="">All</option>
                <option value="low" <%= "low".equals(priorityFilter) ? "selected" : "" %>>Low</option>
                <option value="medium" <%= "medium".equals(priorityFilter) ? "selected" : "" %>>Medium</option>
                <option value="high" <%= "high".equals(priorityFilter) ? "selected" : "" %>>High</option>
            </select>
            
            <label>Sort by:</label>
            <select name="sortBy">
                <option value="">Default</option>
                <option value="date" <%= "date".equals(sortBy) ? "selected" : "" %>>Created Date (Newest)</option>
                <option value="due_date" <%= "due_date".equals(sortBy) ? "selected" : "" %>>Due Date (Earliest)</option>
            </select>
            
            <input type="submit" value="Apply Filters">
            <a href="${pageContext.request.contextPath}/projects?action=view&id=<%= project.getId() %>">Clear Filters</a>
        </form>
    </div>
    
    <h3>Tasks</h3>
    
    <% if (tasks == null || tasks.isEmpty()) { %>
        <p>No tasks found for this project. <a href="${pageContext.request.contextPath}/tasks?projectId=<%= project.getId() %>">Add a task</a></p>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Status</th>
                    <th>Priority</th>
                    <th>Due Date</th>
                    <th>Created</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (Task task : tasks) { 
                    String statusClass = "";
                    String priorityClass = "";
                    
                    switch(task.getStatus()) {
                        case "todo": statusClass = "status-todo"; break;
                        case "in_progress": statusClass = "status-inprogress"; break;
                        case "done": statusClass = "status-done"; break;
                    }
                    
                    switch(task.getPriority()) {
                        case "high": priorityClass = "priority-high"; break;
                        case "medium": priorityClass = "priority-medium"; break;
                        case "low": priorityClass = "priority-low"; break;
                    }
                %>
                <tr>
                    <td><%= task.getTitle() %></td>
                    <td><%= task.getDescription() != null ? task.getDescription() : "" %></td>
                    <td class="<%= statusClass %>">
                        <%= task.getStatus().replace("_", " ").toUpperCase() %>
                    </td>
                    <td class="<%= priorityClass %>">
                        <%= task.getPriority().toUpperCase() %>
                    </td>
                    <td><%= task.getDueDate() != null ? task.getDueDate() : "No due date" %></td>
                    <td><%= task.getCreatedAt() %></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/tasks?action=edit&id=<%= task.getId() %>">Edit</a> | 
                        <a href="${pageContext.request.contextPath}/tasks?action=delete&id=<%= task.getId() %>&projectId=<%= project.getId() %>" 
                           onclick="return confirm('Delete task: <%= task.getTitle() %>?')">Delete</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
</body>
</html>