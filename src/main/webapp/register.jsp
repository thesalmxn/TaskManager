<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String error = (String) request.getAttribute("error");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Task Manager</title>
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
            <h1 class="auth-title">Create Account</h1>
            
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <strong>Registration Error:</strong> <%= error %>
                </div>
            <% } %>
            
            <form action="<%= contextPath %>/register" method="post" id="registerForm">
                <div class="form-group">
                    <label for="username" class="form-label">Username *</label>
                    <input type="text" id="username" name="username" class="form-control" 
                           required placeholder="Enter your username" autocomplete="username">
                    <small class="text-muted">Choose a unique username (3-20 characters)</small>
                </div>
                
                <div class="form-group">
                    <label for="email" class="form-label">Email Address *</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           required placeholder="Enter your email" autocomplete="email">
                    <small class="text-muted">We'll never share your email with anyone else.</small>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Password *</label>
                    <input type="password" id="password" name="password" class="form-control" 
                           required placeholder="Enter your password" autocomplete="new-password">
                    <small class="text-muted">Minimum 6 characters with letters and numbers</small>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Confirm Password *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                           required placeholder="Confirm your password" autocomplete="new-password">
                    <small class="text-muted">Re-enter your password to confirm</small>
                </div>
                
                <!-- Password strength indicator -->
                <div class="form-group">
                    <div id="passwordStrength" style="display: none;">
                        <div class="d-flex justify-between mb-1">
                            <small>Password Strength:</small>
                            <small id="strengthText">Weak</small>
                        </div>
                        <div class="password-strength-bar">
                            <div id="strengthBar" class="strength-fill"></div>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <div class="form-check">
                        <input type="checkbox" id="terms" name="terms" class="form-check-input" required>
                        <label for="terms" class="form-check-label">
                            I agree to the <a href="#" class="terms-link">Terms of Service</a> and <a href="#" class="terms-link">Privacy Policy</a>
                        </label>
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-success" style="width: 100%;">
                        Create Account
                    </button>
                </div>
            </form>
            
            <div class="auth-links">
                <p>Already have an account? 
                    <a href="<%= contextPath %>/login.jsp" class="btn-link">Sign In Here</a>
                </p>
                <p>Or return to 
                    <a href="<%= contextPath %>/" class="btn-link">Home Page</a>
                </p>
            </div>
        </div>
    </div>
    
    <style>
        .password-strength-bar {
            height: 6px;
            background-color: #eee;
            border-radius: 3px;
            overflow: hidden;
            margin-top: 5px;
        }
        
        .strength-fill {
            height: 100%;
            width: 0%;
            border-radius: 3px;
            transition: width 0.3s ease, background-color 0.3s ease;
        }
        
        .terms-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
        }
        
        .terms-link:hover {
            text-decoration: underline;
        }
        
        .form-check {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .form-check-input {
            margin-right: 10px;
            width: 18px;
            height: 18px;
        }
        
        .form-check-label {
            font-size: 0.9rem;
            color: #555;
        }
        
        .btn-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            padding: 0;
            background: none;
            border: none;
            cursor: pointer;
        }
        
        .btn-link:hover {
            text-decoration: underline;
            color: #2980b9;
        }
    </style>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const passwordStrength = document.getElementById('passwordStrength');
            const strengthBar = document.getElementById('strengthBar');
            const strengthText = document.getElementById('strengthText');
            const registerForm = document.getElementById('registerForm');
            
            // Password strength checker
            passwordInput.addEventListener('input', function() {
                const password = passwordInput.value;
                let strength = 0;
                
                if (password.length === 0) {
                    passwordStrength.style.display = 'none';
                    return;
                }
                
                passwordStrength.style.display = 'block';
                
                // Length check
                if (password.length >= 6) strength += 25;
                if (password.length >= 10) strength += 15;
                
                // Character variety checks
                if (/[A-Z]/.test(password)) strength += 20;
                if (/[a-z]/.test(password)) strength += 10;
                if (/[0-9]/.test(password)) strength += 20;
                if (/[^A-Za-z0-9]/.test(password)) strength += 10;
                
                // Cap at 100
                strength = Math.min(strength, 100);
                
                // Update UI
                strengthBar.style.width = strength + '%';
                
                if (strength < 40) {
                    strengthBar.style.backgroundColor = '#e74c3c';
                    strengthText.textContent = 'Weak';
                    strengthText.style.color = '#e74c3c';
                } else if (strength < 70) {
                    strengthBar.style.backgroundColor = '#f39c12';
                    strengthText.textContent = 'Medium';
                    strengthText.style.color = '#f39c12';
                } else {
                    strengthBar.style.backgroundColor = '#2ecc71';
                    strengthText.textContent = 'Strong';
                    strengthText.style.color = '#2ecc71';
                }
            });
            
            // Password confirmation check
            confirmPasswordInput.addEventListener('input', function() {
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                
                if (confirmPassword.length === 0) return;
                
                if (password !== confirmPassword) {
                    confirmPasswordInput.style.borderColor = '#e74c3c';
                    confirmPasswordInput.style.boxShadow = '0 0 0 3px rgba(231, 76, 60, 0.1)';
                } else {
                    confirmPasswordInput.style.borderColor = '#2ecc71';
                    confirmPasswordInput.style.boxShadow = '0 0 0 3px rgba(46, 204, 113, 0.1)';
                }
            });
            
            // Form validation
            registerForm.addEventListener('submit', function(e) {
                const username = document.getElementById('username').value;
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;
                const terms = document.getElementById('terms').checked;
                
                // Username validation
                if (username.length < 3 || username.length > 20) {
                    e.preventDefault();
                    alert('Username must be between 3 and 20 characters.');
                    return;
                }
                
                // Password validation
                if (password.length < 6) {
                    e.preventDefault();
                    alert('Password must be at least 6 characters long.');
                    return;
                }
                
                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Passwords do not match.');
                    return;
                }
                
                // Terms validation
                if (!terms) {
                    e.preventDefault();
                    alert('You must agree to the Terms of Service and Privacy Policy.');
                    return;
                }
            });
        });
    </script>
</body>
</html>