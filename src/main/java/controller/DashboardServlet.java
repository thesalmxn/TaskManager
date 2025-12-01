package controller;

import dao.DashboardDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

public class DashboardServlet extends HttpServlet {
    private DashboardDAO dashboardDAO;
    
    @Override
    public void init() throws ServletException {
        this.dashboardDAO = new DashboardDAO();
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
        
        // Get dashboard statistics
        int totalProjects = dashboardDAO.getTotalProjects(user.getId());
        int totalTasks = dashboardDAO.getTotalTasks(user.getId());
        Map<String, Integer> taskStatusDistribution = dashboardDAO.getTaskStatusDistribution(user.getId());
        Map<String, Integer> taskPriorityDistribution = dashboardDAO.getTaskPriorityDistribution(user.getId());
        
        request.setAttribute("totalProjects", totalProjects);
        request.setAttribute("totalTasks", totalTasks);
        request.setAttribute("taskStatusDistribution", taskStatusDistribution);
        request.setAttribute("taskPriorityDistribution", taskPriorityDistribution);
        request.setAttribute("contextPath", request.getContextPath());
        
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}