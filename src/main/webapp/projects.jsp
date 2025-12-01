<%@ page import="model.User, model.Project, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    List<Project> projects = (List<Project>) request.getAttribute("projects");
    
    String contextPath = request.getContextPath();
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Projects - Task Manager</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Prevent caching -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <script src="<%= contextPath %>/js/noback.js"></script>
</head>
<body>
    <div class="header">
        <div class="container">
            <nav class="navbar">
                <a href="<%= contextPath %>/dashboard" class="brand">Task Manager</a>
                <ul class="nav-links">
                    <li><a href="<%= contextPath %>/dashboard">Dashboard</a></li>
                    <li><a href="<%= contextPath %>/projects" class="active">Projects</a></li>
                    <li><a href="<%= contextPath %>/logout">Logout</a></li>
                </ul>
            </nav>
        </div>
    </div>
    
    <div class="main-content">
        <div class="container">
            <div class="card fade-in">
                <div class="card-header">
                    <h1 class="card-title">My Projects</h1>
                    <div class="action-buttons">
                        <a href="<%= contextPath %>/dashboard" class="btn btn-secondary">Dashboard</a>
                    </div>
                </div>
                
                <!-- Error Message -->
                <% if (error != null) { %>
                    <div class="alert alert-error">
                        <strong>Error:</strong> <%= error %>
                    </div>
                <% } %>
                
                <!-- Create Project Form -->
                <div class="card mb-4">
                    <h3>Create New Project</h3>
                    <form action="<%= contextPath %>/projects" method="post" class="mt-2">
                        <input type="hidden" name="action" value="create">
                        <div class="form-group">
                            <label for="projectName" class="form-label">Project Name *</label>
                            <input type="text" id="projectName" name="name" class="form-control" required 
                                   placeholder="Enter project name">
                        </div>
                        <div class="form-group">
                            <label for="projectDescription" class="form-label">Description</label>
                            <textarea id="projectDescription" name="description" class="form-control" 
                                      rows="3" placeholder="Enter project description (optional)"></textarea>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Create Project</button>
                            <button type="reset" class="btn btn-secondary">Clear Form</button>
                        </div>
                    </form>
                </div>
                
                <!-- Project List -->
                <div class="table-container">
                    <div class="d-flex justify-between align-center mb-3">
                        <h3>Project List</h3>
                        <span class="badge status-inprogress">
                            <%= projects != null ? projects.size() : 0 %> Projects
                        </span>
                    </div>
                    
                    <% if (projects == null || projects.isEmpty()) { %>
                        <div class="alert alert-info">
                            <p>No projects found. Create your first project to get started!</p>
                            <a href="#projectForm" class="btn btn-success btn-small">Create Project</a>
                        </div>
                    <% } else { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Created</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Project project : projects) { 
                                    String description = project.getDescription();
                                    if (description != null && description.length() > 50) {
                                        description = description.substring(0, 50) + "...";
                                    }
                                %>
                                <tr class="fade-in">
                                    <td><strong>#<%= project.getId() %></strong></td>
                                    <td>
                                        <strong><%= project.getName() %></strong>
                                    </td>
                                    <td>
                                        <% if (project.getDescription() != null && !project.getDescription().isEmpty()) { %>
                                            <%= description %>
                                        <% } else { %>
                                            <span class="text-muted">No description</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <small><%= project.getCreatedAt() != null ? project.getCreatedAt().toString() : "" %></small>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <a href="<%= contextPath %>/projects?action=view&id=<%= project.getId() %>" 
                                               class="btn btn-small">View Tasks</a>
                                            <a href="<%= contextPath %>/projects?action=edit&id=<%= project.getId() %>" 
                                               class="btn btn-small btn-secondary">Edit</a>
                                            <a href="<%= contextPath %>/tasks?projectId=<%= project.getId() %>" 
                                               class="btn btn-small btn-success">Add Task</a>
                                            <a href="<%= contextPath %>/projects?action=delete&id=<%= project.getId() %>" 
                                               class="btn btn-small btn-danger"
                                               onclick="return confirm('Are you sure you want to delete project: <%= project.getName() %>? This will also delete all tasks in this project.')">Delete</a>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        
                        <!-- Summary Stats -->
                        <div class="stats-grid mt-4">
                            <div class="stat-card">
                                <div class="stat-number"><%= projects.size() %></div>
                                <div class="stat-label">Total Projects</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-number">
                                    <% 
                                        // Calculate recent projects (last 7 days)
                                        int recentCount = 0;
                                        java.util.Date now = new java.util.Date();
                                        for (Project p : projects) {
                                            if (p.getCreatedAt() != null) {
                                                long diff = now.getTime() - p.getCreatedAt().getTime();
                                                long diffDays = diff / (1000 * 60 * 60 * 24);
                                                if (diffDays <= 7) {
                                                    recentCount++;
                                                }
                                            }
                                        }
                                    %>
                                    <%= recentCount %>
                                </div>
                                <div class="stat-label">Recent (7 days)</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-number">
                                    <% 
                                        // Count projects with descriptions
                                        int withDesc = 0;
                                        for (Project p : projects) {
                                            if (p.getDescription() != null && !p.getDescription().isEmpty()) {
                                                withDesc++;
                                            }
                                        }
                                    %>
                                    <%= withDesc %>
                                </div>
                                <div class="stat-label">With Description</div>
                            </div>
                        </div>
                    <% } %>
                </div>
                
                <!-- Quick Tips -->
                <div class="card mt-4">
                    <h4>💡 Quick Tips</h4>
                    <ul style="list-style-type: none; padding-left: 0;">
                        <li>✅ Click "View Tasks" to see and manage tasks in a project</li>
                        <li>✅ Use "Add Task" to quickly add tasks to a project</li>
                        <li>✅ Projects can be edited or deleted using the action buttons</li>
                        <li>✅ All tasks in a project are deleted when the project is deleted</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="copyright">
                    &copy; Salman's Task Management System | 
                    User: <%= user.getUsername() %> | 
                    Total Projects: <%= projects != null ? projects.size() : 0 %>
                </div>
                <ul class="footer-links">
                    <li><a href="<%= contextPath %>/dashboard">Dashboard</a></li>
                    <li><a href="<%= contextPath %>/projects">Projects</a></li>
                    <li><a href="<%= contextPath %>/logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
    
    <script>
        // Add smooth scrolling for "Create Project" link
        document.addEventListener('DOMContentLoaded', function() {
            const createProjectLink = document.querySelector('a[href="#projectForm"]');
            if (createProjectLink) {
                createProjectLink.addEventListener('click', function(e) {
                    e.preventDefault();
                    document.querySelector('#projectName').focus();
                });
            }
            
            // Add animation to table rows
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach((row, index) => {
                row.style.animationDelay = (index * 0.05) + 's';
                row.classList.add('fade-in');
            });
        });
    </script>
</body>
</html>