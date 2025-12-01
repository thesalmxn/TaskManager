package filter;

import model.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class AuthFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        
        // Allow public resources
        if (path.endsWith(".css") || path.endsWith(".js") || 
            path.endsWith(".jpg") || path.endsWith(".png") ||
            path.endsWith(".ico")) {
            chain.doFilter(request, response);
            return;
        }
        
        if (path.equals("/") || 
            path.equals("/login.jsp") || 
            path.equals("/register.jsp") || 
            path.equals("/login") || 
            path.equals("/register")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        if (session != null && session.getAttribute("user") != null) {
            // Set cache control headers to prevent back button access
            httpResponse.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            httpResponse.setHeader("Pragma", "no-cache");
            httpResponse.setHeader("Expires", "0");
            
            chain.doFilter(request, response);
        } else {
            // Redirect to login with message
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?expired=true");
        }
    }
    
    @Override
    public void destroy() {
    }
}