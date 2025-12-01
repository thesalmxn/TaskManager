package service;

import dao.TaskDAO;
import model.Task;

public class TaskService {
    private TaskDAO taskDAO;
    
    public TaskService() {
        this.taskDAO = new TaskDAO();
    }
    
    public boolean createTask(Task task) {
        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Task title is required");
        }
        return taskDAO.createTask(task);
    }
    
    public Task getTaskById(int id) {
        return taskDAO.getTaskById(id);
    }
    
    public boolean updateTask(Task task) {
        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Task title is required");
        }
        return taskDAO.updateTask(task);
    }
    
    public boolean deleteTask(int taskId, int projectId) {
        return taskDAO.deleteTask(taskId, projectId);
    }
}