package controller;

import dao.ProjectDAO;
import dao.TaskDAO;
import model.Project;
import model.Task;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class TaskServlet extends HttpServlet {
    private TaskDAO taskDAO;
    private ProjectDAO projectDAO;
    
    @Override
    public void init() throws ServletException {
        this.taskDAO = new TaskDAO();
        this.projectDAO = new ProjectDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
    	// Prevent caching
    	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    	response.setHeader("Pragma", "no-cache");
    	response.setHeader("Expires", "0");
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        String projectIdParam = request.getParameter("projectId");
        
        if ("edit".equals(action) && idParam != null) {
            // Edit task form
            int taskId = Integer.parseInt(idParam);
            Task task = taskDAO.getTaskById(taskId);
            
            if (task == null) {
                response.sendRedirect(request.getContextPath() + "/projects");
                return;
            }
            
            // Get project to check ownership
            Project project = projectDAO.getProjectById(task.getProjectId());
            if (project == null || project.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/projects");
                return;
            }
            
            request.setAttribute("task", task);
            request.setAttribute("project", project);
            request.setAttribute("editMode", true);
            request.setAttribute("contextPath", request.getContextPath());
            request.getRequestDispatcher("/editTask.jsp").forward(request, response);
            
        } else if ("delete".equals(action) && idParam != null && projectIdParam != null) {
            // Delete task
            int taskId = Integer.parseInt(idParam);
            int projectId = Integer.parseInt(projectIdParam);
            
            // Check project ownership
            Project project = projectDAO.getProjectById(projectId);
            if (project != null && project.getUserId() == user.getId()) {
                taskDAO.deleteTask(taskId, projectId);
            }
            
            response.sendRedirect(request.getContextPath() + "/projects?action=view&id=" + projectId);
            
        } else if (projectIdParam != null) {
            // Create task form for a project
            int projectId = Integer.parseInt(projectIdParam);
            Project project = projectDAO.getProjectById(projectId);
            
            if (project == null || project.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/projects");
                return;
            }
            
            request.setAttribute("project", project);
            request.setAttribute("contextPath", request.getContextPath());
            request.getRequestDispatcher("/editTask.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String projectIdParam = request.getParameter("projectId");
        
        if (projectIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/projects");
            return;
        }
        
        int projectId = Integer.parseInt(projectIdParam);
        
        // Check project ownership
        Project project = projectDAO.getProjectById(projectId);
        if (project == null || project.getUserId() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/projects");
            return;
        }
        
        if ("create".equals(action)) {
            // Create new task
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String priority = request.getParameter("priority");
            String dueDateStr = request.getParameter("dueDate");
            
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Task title is required");
                request.setAttribute("project", project);
                request.setAttribute("contextPath", request.getContextPath());
                request.getRequestDispatcher("/editTask.jsp").forward(request, response);
                return;
            }
            
            Task task = new Task();
            task.setTitle(title.trim());
            task.setDescription(description != null ? description.trim() : "");
            task.setStatus(status != null ? status : "todo");
            task.setPriority(priority != null ? priority : "medium");
            task.setProjectId(projectId);
            
            // Parse due date
            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date utilDate = sdf.parse(dueDateStr.trim());
                    task.setDueDate(new Date(utilDate.getTime()));
                } catch (ParseException e) {
                    // If date parsing fails, set to null
                    task.setDueDate(null);
                }
            }
            
            boolean success = taskDAO.createTask(task);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/projects?action=view&id=" + projectId);
            } else {
                request.setAttribute("error", "Failed to create task");
                request.setAttribute("project", project);
                request.setAttribute("contextPath", request.getContextPath());
                request.getRequestDispatcher("/editTask.jsp").forward(request, response);
            }
            
        } else if ("update".equals(action)) {
            // Update task
            String idParam = request.getParameter("id");
            
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/projects?action=view&id=" + projectId);
                return;
            }
            
            int taskId = Integer.parseInt(idParam);
            Task task = taskDAO.getTaskById(taskId);
            
            if (task == null || task.getProjectId() != projectId) {
                response.sendRedirect(request.getContextPath() + "/projects?action=view&id=" + projectId);
                return;
            }
            
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String priority = request.getParameter("priority");
            String dueDateStr = request.getParameter("dueDate");
            
            task.setTitle(title.trim());
            task.setDescription(description != null ? description.trim() : "");
            task.setStatus(status != null ? status : "todo");
            task.setPriority(priority != null ? priority : "medium");
            
            // Parse due date
            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    java.util.Date utilDate = sdf.parse(dueDateStr.trim());
                    task.setDueDate(new Date(utilDate.getTime()));
                } catch (ParseException e) {
                    // If date parsing fails, set to null
                    task.setDueDate(null);
                }
            } else {
                task.setDueDate(null);
            }
            
            boolean success = taskDAO.updateTask(task);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/projects?action=view&id=" + projectId);
            } else {
                request.setAttribute("error", "Failed to update task");
                request.setAttribute("task", task);
                request.setAttribute("project", project);
                request.setAttribute("editMode", true);
                request.setAttribute("contextPath", request.getContextPath());
                request.getRequestDispatcher("/editTask.jsp").forward(request, response);
            }
        }
    }
}