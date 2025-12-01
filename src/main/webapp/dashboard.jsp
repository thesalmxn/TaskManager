<%@ page import="model.User, java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    Integer totalProjects = (Integer) request.getAttribute("totalProjects");
    Integer totalTasks = (Integer) request.getAttribute("totalTasks");
    Map<String, Integer> taskStatusDistribution = (Map<String, Integer>) request.getAttribute("taskStatusDistribution");
    
    if (totalProjects == null) totalProjects = 0;
    if (totalTasks == null) totalTasks = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Task Manager</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Prevent caching -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    
    <%
        String contextPath = request.getContextPath();
    %>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <script src="<%= contextPath %>/js/noback.js"></script>
</head>
<body>
    <div class="header">
        <div class="container">
            <nav class="navbar">
                <a href="<%= contextPath %>/dashboard" class="brand">Task Manager</a>
                <ul class="nav-links">
                    <li><a href="<%= contextPath %>/dashboard" class="active">Dashboard</a></li>
                    <li><a href="<%= contextPath %>/projects">Projects</a></li>
                    <li><a href="<%= contextPath %>/logout">Logout</a></li>
                </ul>
            </nav>
        </div>
    </div>
    
    <div class="main-content">
        <div class="container">
            <div class="card fade-in">
                <div class="card-header">
                    <h1 class="card-title">Dashboard Overview</h1>
                    <div class="action-buttons">
                        <a href="<%= contextPath %>/projects" class="btn">View All Projects</a>
                    </div>
                </div>
                
                <!-- Welcome Message -->
                <div class="alert alert-info">
                    <h3>Welcome back, <strong><%= user.getUsername() %></strong>!</h3>
                    <p>Here's a summary of your task management activities.</p>
                </div>
                
                <!-- Stats Grid -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number"><%= totalProjects %></div>
                        <div class="stat-label">Total Projects</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= totalTasks %></div>
                        <div class="stat-label">Total Tasks</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <%= taskStatusDistribution != null ? taskStatusDistribution.getOrDefault("done", 0) : 0 %>
                        </div>
                        <div class="stat-label">Completed Tasks</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <%= taskStatusDistribution != null ? taskStatusDistribution.getOrDefault("in_progress", 0) : 0 %>
                        </div>
                        <div class="stat-label">In Progress</div>
                    </div>
                </div>
                
                <!-- Charts Section -->
                <div class="chart-container">
                    <h3>Task Status Distribution</h3>
                    <p class="text-muted mb-3">Visual breakdown of tasks by their current status</p>
                    
                    <div style="position: relative; height: 300px; width: 100%;">
                        <canvas id="statusChart"></canvas>
                    </div>
                    
                    <!-- Status Legend -->
                    <div class="d-flex justify-center gap-3 mt-3 flex-wrap">
                        <div class="d-flex align-center gap-1">
                            <div style="width: 20px; height: 20px; background-color: rgba(255, 99, 132, 0.7); border-radius: 4px;"></div>
                            <span>To Do (<%= taskStatusDistribution != null ? taskStatusDistribution.getOrDefault("todo", 0) : 0 %>)</span>
                        </div>
                        <div class="d-flex align-center gap-1">
                            <div style="width: 20px; height: 20px; background-color: rgba(54, 162, 235, 0.7); border-radius: 4px;"></div>
                            <span>In Progress (<%= taskStatusDistribution != null ? taskStatusDistribution.getOrDefault("in_progress", 0) : 0 %>)</span>
                        </div>
                        <div class="d-flex align-center gap-1">
                            <div style="width: 20px; height: 20px; background-color: rgba(75, 192, 192, 0.7); border-radius: 4px;"></div>
                            <span>Done (<%= taskStatusDistribution != null ? taskStatusDistribution.getOrDefault("done", 0) : 0 %>)</span>
                        </div>
                    </div>
                </div>
                
                <!-- Priority Distribution (Optional) -->
                <%
                    Map<String, Integer> taskPriorityDistribution = (Map<String, Integer>) request.getAttribute("taskPriorityDistribution");
                    if (taskPriorityDistribution != null) {
                %>
                <div class="chart-container mt-4">
                    <h3>Task Priority Distribution</h3>
                    <p class="text-muted mb-3">Breakdown of tasks by priority level</p>
                    
                    <div style="position: relative; height: 300px; width: 100%;">
                        <canvas id="priorityChart"></canvas>
                    </div>
                    
                    <script>
                        const priorityCtx = document.getElementById('priorityChart').getContext('2d');
                        const priorityChart = new Chart(priorityCtx, {
                            type: 'pie',
                            data: {
                                labels: ['High Priority', 'Medium Priority', 'Low Priority'],
                                datasets: [{
                                    data: [
                                        <%= taskPriorityDistribution.getOrDefault("high", 0) %>,
                                        <%= taskPriorityDistribution.getOrDefault("medium", 0) %>,
                                        <%= taskPriorityDistribution.getOrDefault("low", 0) %>
                                    ],
                                    backgroundColor: [
                                        'rgba(255, 99, 132, 0.7)',
                                        'rgba(54, 162, 235, 0.7)',
                                        'rgba(75, 192, 192, 0.7)'
                                    ],
                                    borderColor: [
                                        'rgb(255, 99, 132)',
                                        'rgb(54, 162, 235)',
                                        'rgb(75, 192, 192)'
                                    ],
                                    borderWidth: 1
                                }]
                            },
                            options: {
                                responsive: true,
                                plugins: {
                                    legend: {
                                        position: 'right',
                                    }
                                }
                            }
                        });
                    </script>
                </div>
                <% } %>
                
                <!-- Quick Links -->
                <div class="card mt-4">
                    <h3>Quick Actions</h3>
                    <div class="d-flex gap-2 flex-wrap">
                        <a href="<%= contextPath %>/projects" class="btn">Manage Projects</a>
                        <a href="<%= contextPath %>/projects?action=create" class="btn btn-success">Create New Project</a>
                        <a href="<%= contextPath %>/tasks?projectId=1" class="btn btn-secondary">Add Tasks</a>
                        <a href="<%= contextPath %>/logout" class="btn btn-danger">Logout</a>
                    </div>
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
                    Projects: <%= totalProjects %> | 
                    Tasks: <%= totalTasks %>
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
        // Initialize the main chart
        const ctx = document.getElementById('statusChart').getContext('2d');
        const statusChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['To Do', 'In Progress', 'Done'],
                datasets: [{
                    label: 'Task Count',
                    data: [
                        <%= taskStatusDistribution != null ? taskStatusDistribution.getOrDefault("todo", 0) : 0 %>,
                        <%= taskStatusDistribution != null ? taskStatusDistribution.getOrDefault("in_progress", 0) : 0 %>,
                        <%= taskStatusDistribution != null ? taskStatusDistribution.getOrDefault("done", 0) : 0 %>
                    ],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(75, 192, 192, 0.7)'
                    ],
                    borderColor: [
                        'rgb(255, 99, 132)',
                        'rgb(54, 162, 235)',
                        'rgb(75, 192, 192)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1,
                            precision: 0
                        },
                        grid: {
                            display: true,
                            color: 'rgba(0, 0, 0, 0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.7)',
                        titleFont: {
                            size: 14
                        },
                        bodyFont: {
                            size: 14
                        }
                    }
                }
            }
        });
        
        // Add animation on load
        document.addEventListener('DOMContentLoaded', function() {
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                card.style.animationDelay = (index * 0.1) + 's';
                card.classList.add('fade-in');
            });
        });
    </script>
</body>
</html>