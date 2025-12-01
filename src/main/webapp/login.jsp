<%
    // Check if redirected due to expired session
    String expired = request.getParameter("expired");
    String error = (String) request.getAttribute("error");
    String contextPath = request.getContextPath();
    
    if ("true".equals(expired)) {
        error = "Your session has expired. Please login again.";
    }
%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Task Manager</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Prevent caching -->
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv="Expires" content="0">
    
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
    <div class="auth-container">
        <div class="auth-box fade-in">
            <div class="text-center mb-4">
                <h1 class="auth-title">Welcome Back</h1>
                <p class="text-muted">Sign in to access your projects and tasks</p>
            </div>
            
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <strong>Login Error:</strong> <%= error %>
                </div>
            <% } %>
            
            <form action="<%= contextPath %>/login" method="post" id="loginForm">
                <div class="form-group">
                    <label for="username" class="form-label">Username *</label>
                    <input type="text" id="username" name="username" class="form-control" 
                           required placeholder="Enter your username" autocomplete="username"
                           autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Password *</label>
                    <div class="password-container">
                        <input type="password" id="password" name="password" class="form-control" 
                               required placeholder="Enter your password" autocomplete="current-password">
                        <button type="button" id="togglePassword" class="password-toggle">
                            👁️
                        </button>
                    </div>
                </div>
                
                <div class="form-group d-flex justify-between align-center">
                    <div class="form-check">
                        <input type="checkbox" id="remember" name="remember" class="form-check-input">
                        <label for="remember" class="form-check-label">Remember me</label>
                    </div>
                    <a href="#" class="btn-link">Forgot Password?</a>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-success" style="width: 100%;">
                        Sign In
                    </button>
                </div>
            </form>
            
            <!-- Demo Credentials Card -->
            <div class="card mt-3" style="background-color: #f8f9fa; border: 1px dashed #6c757d;">
                <div class="card-body">
                    <h6 style="color: #6c757d; margin-bottom: 8px;">Demo Credentials</h6>
                    <div style="font-size: 0.85rem; color: #495057;">
                        <div><strong>Username:</strong> admin</div>
                        <div><strong>Password:</strong> admin</div>
                    </div>
                </div>
            </div>
            
            <div class="auth-links">
                <p>Don't have an account? 
                    <a href="<%= contextPath %>/register.jsp" class="btn-link">Create Account</a>
                </p>
                <p class="mt-2">
                    <a href="<%= contextPath %>/" class="btn-link">← Return to Home</a>
                </p>
            </div>
        </div>
    </div>
    
    <style>
        .password-container {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
            color: #6c757d;
            padding: 4px;
            border-radius: 4px;
        }
        
        .password-toggle:hover {
            background-color: rgba(0,0,0,0.05);
        }
        
        .demo-card {
            background-color: #f8f9fa;
            border: 1px dashed #6c757d;
            border-radius: 6px;
            padding: 12px;
            margin: 15px 0;
        }
        
        .demo-title {
            color: #6c757d;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .demo-credentials {
            font-size: 0.85rem;
            color: #495057;
        }
    </style>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const loginForm = document.getElementById('loginForm');
            const togglePasswordBtn = document.getElementById('togglePassword');
            const passwordInput = document.getElementById('password');
            const rememberCheckbox = document.getElementById('remember');
            
            // Toggle password visibility
            togglePasswordBtn.addEventListener('click', function() {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                togglePasswordBtn.textContent = type === 'password' ? '👁️' : '🔒';
            });
            
            // Load saved credentials if "Remember me" was checked
            const savedUsername = localStorage.getItem('rememberedUsername');
            const savedPassword = localStorage.getItem('rememberedPassword');
            
            if (savedUsername) {
                document.getElementById('username').value = savedUsername;
                rememberCheckbox.checked = true;
            }
            
            if (savedPassword) {
                passwordInput.value = savedPassword;
                rememberCheckbox.checked = true;
            }
            
            // Save credentials on form submit if "Remember me" is checked
            loginForm.addEventListener('submit', function() {
                const username = document.getElementById('username').value;
                const password = passwordInput.value;
                
                if (rememberCheckbox.checked) {
                    localStorage.setItem('rememberedUsername', username);
                    localStorage.setItem('rememberedPassword', password);
                } else {
                    localStorage.removeItem('rememberedUsername');
                    localStorage.removeItem('rememberedPassword');
                }
            });
            
            // Clear form button (optional)
            const clearForm = document.createElement('button');
            clearForm.type = 'button';
            clearForm.className = 'btn btn-secondary btn-small mt-2';
            clearForm.textContent = 'Clear Form';
            clearForm.style.width = '100%';
            clearForm.addEventListener('click', function() {
                loginForm.reset();
                localStorage.removeItem('rememberedUsername');
                localStorage.removeItem('rememberedPassword');
                rememberCheckbox.checked = false;
            });
            
            loginForm.querySelector('.form-actions').appendChild(clearForm);
            
            // Auto-focus on username field
            document.getElementById('username').focus();
            
            // Handle Enter key to submit form
            loginForm.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    loginForm.submit();
                }
            });
        });
    </script>
</body>
</html>