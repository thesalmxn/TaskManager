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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">  -->
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
    <div class="header">
        <div class="container">
            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/dashboard" class="brand">Task Manager</a>
                <ul class="nav-links">
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/projects" class="active">Projects</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                </ul>
            </nav>
        </div>
    </div>
    
    <div class="main-content">
        <div class="container">
            <div class="card fade-in">
                <div class="card-header">
                    <div>
                        <h1 class="card-title"><%= project.getName() %></h1>
                        <p class="text-muted"><%= project.getDescription() != null && !project.getDescription().isEmpty() ? project.getDescription() : "No description" %></p>
                    </div>
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/projects" class="btn btn-secondary">Back to Projects</a>
                        <a href="${pageContext.request.contextPath}/tasks?projectId=<%= project.getId() %>" class="btn btn-success">Add New Task</a>
                    </div>
                </div>
                
                <!-- Filters Panel -->
                <div class="filters-panel">
                    <h4>Filter & Sort Tasks</h4>
                    <form method="get" class="filter-form">
                        <input type="hidden" name="action" value="view">
                        <input type="hidden" name="id" value="<%= project.getId() %>">
                        
                        <div class="filter-group">
                            <div class="filter-controls">
                                <div>
                                    <label for="statusFilter">Status:</label>
                                    <select id="statusFilter" name="statusFilter" class="form-control">
                                        <option value="">All Status</option>
                                        <option value="todo" <%= "todo".equals(statusFilter) ? "selected" : "" %>>To Do</option>
                                        <option value="in_progress" <%= "in_progress".equals(statusFilter) ? "selected" : "" %>>In Progress</option>
                                        <option value="done" <%= "done".equals(statusFilter) ? "selected" : "" %>>Done</option>
                                    </select>
                                </div>
                                
                                <div>
                                    <label for="priorityFilter">Priority:</label>
                                    <select id="priorityFilter" name="priorityFilter" class="form-control">
                                        <option value="">All Priority</option>
                                        <option value="low" <%= "low".equals(priorityFilter) ? "selected" : "" %>>Low</option>
                                        <option value="medium" <%= "medium".equals(priorityFilter) ? "selected" : "" %>>Medium</option>
                                        <option value="high" <%= "high".equals(priorityFilter) ? "selected" : "" %>>High</option>
                                    </select>
                                </div>
                                
                                <div>
                                    <label for="sortBy">Sort by:</label>
                                    <select id="sortBy" name="sortBy" class="form-control">
                                        <option value="">Default (Priority)</option>
                                        <option value="date" <%= "date".equals(sortBy) ? "selected" : "" %>>Created Date (Newest)</option>
                                        <option value="due_date" <%= "due_date".equals(sortBy) ? "selected" : "" %>>Due Date (Earliest)</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-actions mt-2">
                                <button type="submit" class="btn">Apply Filters</button>
                                <a href="${pageContext.request.contextPath}/projects?action=view&id=<%= project.getId() %>" class="btn btn-secondary">Clear Filters</a>
                            </div>
                        </div>
                    </form>
                </div>
                
                <!-- Tasks List -->
                <div class="table-container">
                    <h3>Tasks (<%= tasks != null ? tasks.size() : 0 %>)</h3>
                    
                    <% if (tasks == null || tasks.isEmpty()) { %>
                        <div class="alert alert-info">
                            <p>No tasks found for this project. <a href="${pageContext.request.contextPath}/tasks?projectId=<%= project.getId() %>" class="btn btn-success btn-small">Create your first task</a></p>
                        </div>
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
                                    String statusText = "";
                                    
                                    switch(task.getStatus()) {
                                        case "todo": 
                                            statusClass = "status-todo";
                                            statusText = "To Do";
                                            break;
                                        case "in_progress": 
                                            statusClass = "status-inprogress";
                                            statusText = "In Progress";
                                            break;
                                        case "done": 
                                            statusClass = "status-done";
                                            statusText = "Done";
                                            break;
                                    }
                                    
                                    switch(task.getPriority()) {
                                        case "high": 
                                            priorityClass = "priority-high";
                                            break;
                                        case "medium": 
                                            priorityClass = "priority-medium";
                                            break;
                                        case "low": 
                                            priorityClass = "priority-low";
                                            break;
                                    }
                                    
                                    // Format dates
                                    String dueDate = task.getDueDate() != null ? task.getDueDate().toString() : "No due date";
                                    String createdAt = task.getCreatedAt() != null ? task.getCreatedAt().toString() : "";
                                %>
                                <tr class="fade-in">
                                    <td><strong><%= task.getTitle() %></strong></td>
                                    <td>
                                        <% if (task.getDescription() != null && !task.getDescription().isEmpty()) { 
                                            String desc = task.getDescription();
                                            if (desc.length() > 50) {
                                                desc = desc.substring(0, 50) + "...";
                                            }
                                        %>
                                            <%= desc %>
                                        <% } else { %>
                                            <span class="text-muted">No description</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="badge <%= statusClass %>">
                                            <%= statusText %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge <%= priorityClass %>">
                                            <%= task.getPriority().toUpperCase() %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (task.getDueDate() != null) { 
                                            java.util.Date now = new java.util.Date();
                                            java.util.Date due = new java.util.Date(task.getDueDate().getTime());
                                            boolean isOverdue = due.before(now) && !"done".equals(task.getStatus());
                                        %>
                                            <%= task.getDueDate() %>
                                            <% if (isOverdue) { %>
                                                <span class="badge status-todo ml-1">OVERDUE</span>
                                            <% } %>
                                        <% } else { %>
                                            <span class="text-muted">No due date</span>
                                        <% } %>
                                    </td>
                                    <td><small><%= createdAt %></small></td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="${pageContext.request.contextPath}/tasks?action=edit&id=<%= task.getId() %>" 
                                               class="btn btn-small">Edit</a>
                                            <a href="${pageContext.request.contextPath}/tasks?action=delete&id=<%= task.getId() %>&projectId=<%= project.getId() %>" 
                                               class="btn btn-small btn-danger"
                                               onclick="return confirm('Are you sure you want to delete task: <%= task.getTitle() %>?')">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
                
                <!-- Quick Stats -->
                <% if (tasks != null && !tasks.isEmpty()) { 
                    int todoCount = 0;
                    int inProgressCount = 0;
                    int doneCount = 0;
                    int highPriorityCount = 0;
                    
                    for (Task task : tasks) {
                        switch(task.getStatus()) {
                            case "todo": todoCount++; break;
                            case "in_progress": inProgressCount++; break;
                            case "done": doneCount++; break;
                        }
                        if ("high".equals(task.getPriority())) {
                            highPriorityCount++;
                        }
                    }
                %>
                <div class="stats-grid mt-3">
                    <div class="stat-card">
                        <div class="stat-number"><%= todoCount %></div>
                        <div class="stat-label">To Do Tasks</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= inProgressCount %></div>
                        <div class="stat-label">In Progress</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= doneCount %></div>
                        <div class="stat-label">Completed</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= highPriorityCount %></div>
                        <div class="stat-label">High Priority</div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="copyright">
                    &copy; Salman's Task Management System | Project: <%= project.getName() %>
                </div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/projects">Projects</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</body>
</html>