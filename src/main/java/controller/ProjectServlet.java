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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class ProjectServlet extends HttpServlet {
    private ProjectDAO projectDAO;
    private TaskDAO taskDAO;
    
    @Override
    public void init() throws ServletException {
        this.projectDAO = new ProjectDAO();
        this.taskDAO = new TaskDAO();
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
        
        if (action == null && idParam == null) {
            // List all projects
            List<Project> projects = projectDAO.getProjectsByUser(user.getId());
            request.setAttribute("projects", projects);
            request.getRequestDispatcher("/projects.jsp").forward(request, response);
            
        } else if ("view".equals(action) && idParam != null) {
            // View project details with tasks
            int projectId = Integer.parseInt(idParam);
            Project project = projectDAO.getProjectById(projectId);
            
            // Check if project belongs to user
            if (project == null || project.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/projects");
                return;
            }
            
            // Get tasks with filters
            String statusFilter = request.getParameter("statusFilter");
            String priorityFilter = request.getParameter("priorityFilter");
            String sortBy = request.getParameter("sortBy");
            
            List<Task> tasks = taskDAO.getTasksByProject(projectId, statusFilter, priorityFilter, sortBy);
            
            request.setAttribute("project", project);
            request.setAttribute("tasks", tasks);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("priorityFilter", priorityFilter);
            request.setAttribute("sortBy", sortBy);
            
            request.getRequestDispatcher("/tasks.jsp").forward(request, response);
            
        } else if ("edit".equals(action) && idParam != null) {
            // Edit project form
            int projectId = Integer.parseInt(idParam);
            Project project = projectDAO.getProjectById(projectId);
            
            if (project == null || project.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/projects");
                return;
            }
            
            request.setAttribute("project", project);
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/editProject.jsp").forward(request, response);
            
        } else if ("delete".equals(action) && idParam != null) {
            // Delete project
            int projectId = Integer.parseInt(idParam);
            Project project = projectDAO.getProjectById(projectId);
            
            if (project != null && project.getUserId() == user.getId()) {
                projectDAO.deleteProject(projectId, user.getId());
            }
            
            response.sendRedirect(request.getContextPath() + "/projects");
            
        } else {
            // Default: list all projects
            List<Project> projects = projectDAO.getProjectsByUser(user.getId());
            request.setAttribute("projects", projects);
            request.getRequestDispatcher("/projects.jsp").forward(request, response);
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
        
        if ("create".equals(action)) {
            // Create new project
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Project name is required");
                request.getRequestDispatcher("/projects.jsp").forward(request, response);
                return;
            }
            
            Project project = new Project();
            project.setName(name.trim());
            project.setDescription(description != null ? description.trim() : "");
            project.setUserId(user.getId());
            
            boolean success = projectDAO.createProject(project);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/projects");
            } else {
                request.setAttribute("error", "Failed to create project");
                request.getRequestDispatcher("/projects.jsp").forward(request, response);
            }
            
        } else if ("update".equals(action)) {
            // Update project
            String idParam = request.getParameter("id");
            
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/projects");
                return;
            }
            
            int projectId = Integer.parseInt(idParam);
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            
            Project project = projectDAO.getProjectById(projectId);
            
            if (project == null || project.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/projects");
                return;
            }
            
            project.setName(name.trim());
            project.setDescription(description != null ? description.trim() : "");
            
            boolean success = projectDAO.updateProject(project);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/projects");
            } else {
                request.setAttribute("error", "Failed to update project");
                request.setAttribute("project", project);
                request.setAttribute("editMode", true);
                request.getRequestDispatcher("/editProject.jsp").forward(request, response);
            }
        }
    }
}