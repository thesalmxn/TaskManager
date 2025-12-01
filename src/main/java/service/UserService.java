package service;

import dao.UserDAO;
import model.User;
import util.PasswordHasher;

public class UserService {
    private UserDAO userDAO;
    
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    public boolean register(User user) {
        if (userDAO.isUsernameExists(user.getUsername())) {
            return false;
        }
        
        // Hash password before storing
        String hashedPassword = PasswordHasher.hash(user.getPasswordHash());
        user.setPasswordHash(hashedPassword);
        
        return userDAO.createUser(user);
    }
    
    public User login(String username, String password) {
        return userDAO.authenticate(username, password);
    }
    
    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }
}