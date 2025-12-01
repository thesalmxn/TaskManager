package dao;

import util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class DashboardDAO {
    
    public int getTotalProjects(int userId) {
        String sql = "SELECT COUNT(*) FROM projects WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getTotalTasks(int userId) {
        String sql = "SELECT COUNT(*) FROM tasks t " +
                    "JOIN projects p ON t.project_id = p.id " +
                    "WHERE p.user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public Map<String, Integer> getTaskStatusDistribution(int userId) {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT t.status, COUNT(*) as count FROM tasks t " +
                    "JOIN projects p ON t.project_id = p.id " +
                    "WHERE p.user_id = ? " +
                    "GROUP BY t.status";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            // Initialize with 0
            distribution.put("todo", 0);
            distribution.put("in_progress", 0);
            distribution.put("done", 0);
            
            while (rs.next()) {
                distribution.put(rs.getString("status"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return distribution;
    }
    
    public Map<String, Integer> getTaskPriorityDistribution(int userId) {
        Map<String, Integer> distribution = new HashMap<>();
        String sql = "SELECT t.priority, COUNT(*) as count FROM tasks t " +
                    "JOIN projects p ON t.project_id = p.id " +
                    "WHERE p.user_id = ? " +
                    "GROUP BY t.priority";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            // Initialize with 0
            distribution.put("low", 0);
            distribution.put("medium", 0);
            distribution.put("high", 0);
            
            while (rs.next()) {
                distribution.put(rs.getString("priority"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return distribution;
    }
}