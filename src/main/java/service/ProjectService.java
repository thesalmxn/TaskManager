package service;

import dao.ProjectDAO;
import dao.TaskDAO;
import model.Project;
import model.Task;

import java.util.List;

public class ProjectService {
    private ProjectDAO projectDAO;
    private TaskDAO taskDAO;
    
    public ProjectService() {
        this.projectDAO = new ProjectDAO();
        this.taskDAO = new TaskDAO();
    }
    
    public boolean createProject(Project project) {
        if (project.getName() == null || project.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Project name is required");
        }
        return projectDAO.createProject(project);
    }
    
    public List<Project> getProjectsByUser(int userId) {
        return projectDAO.getProjectsByUser(userId);
    }
    
    public Project getProjectById(int id) {
        return projectDAO.getProjectById(id);
    }
    
    public boolean updateProject(Project project) {
        if (project.getName() == null || project.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Project name is required");
        }
        return projectDAO.updateProject(project);
    }
    
    public boolean deleteProject(int projectId, int userId) {
        return projectDAO.deleteProject(projectId, userId);
    }
    
    public List<Task> getProjectTasks(int projectId, String statusFilter, String priorityFilter, String sortBy) {
        return taskDAO.getTasksByProject(projectId, statusFilter, priorityFilter, sortBy);
    }
}