package dao;

import model.Task;
import util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {
    
    public boolean createTask(Task task) {
        String sql = "INSERT INTO tasks (title, description, status, priority, due_date, project_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, task.getTitle());
            stmt.setString(2, task.getDescription());
            stmt.setString(3, task.getStatus());
            stmt.setString(4, task.getPriority());
            
            if (task.getDueDate() != null) {
                stmt.setDate(5, task.getDueDate());
            } else {
                stmt.setNull(5, Types.DATE);
            }
            
            stmt.setInt(6, task.getProjectId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Task> getTasksByProject(int projectId, String statusFilter, String priorityFilter, String sortBy) {
        List<Task> tasks = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM tasks WHERE project_id = ?");
        
        List<Object> params = new ArrayList<>();
        params.add(projectId);
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND status = ?");
            params.add(statusFilter);
        }
        
        if (priorityFilter != null && !priorityFilter.isEmpty()) {
            sql.append(" AND priority = ?");
            params.add(priorityFilter);
        }
        
        if ("date".equals(sortBy)) {
            sql.append(" ORDER BY created_at DESC");
        } else if ("due_date".equals(sortBy)) {
            sql.append(" ORDER BY due_date ASC");
        } else {
            sql.append(" ORDER BY FIELD(priority, 'high', 'medium', 'low'), created_at DESC");
        }
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                tasks.add(extractTaskFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }
    
    public Task getTaskById(int id) {
        String sql = "SELECT * FROM tasks WHERE id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractTaskFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET title = ?, description = ?, status = ?, priority = ?, due_date = ? " +
                    "WHERE id = ? AND project_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, task.getTitle());
            stmt.setString(2, task.getDescription());
            stmt.setString(3, task.getStatus());
            stmt.setString(4, task.getPriority());
            
            if (task.getDueDate() != null) {
                stmt.setDate(5, task.getDueDate());
            } else {
                stmt.setNull(5, Types.DATE);
            }
            
            stmt.setInt(6, task.getId());
            stmt.setInt(7, task.getProjectId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteTask(int taskId, int projectId) {
        String sql = "DELETE FROM tasks WHERE id = ? AND project_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, taskId);
            stmt.setInt(2, projectId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public int countTasksByProject(int projectId) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE project_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, projectId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    private Task extractTaskFromResultSet(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setId(rs.getInt("id"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setStatus(rs.getString("status"));
        task.setPriority(rs.getString("priority"));
        task.setDueDate(rs.getDate("due_date"));
        task.setProjectId(rs.getInt("project_id"));
        task.setCreatedAt(rs.getTimestamp("created_at"));
        return task;
    }
}