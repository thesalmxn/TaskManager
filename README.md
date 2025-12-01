# Task Management System (MVP)

## Project Description
A simple Project and Task Management System where users can manage their projects and related tasks.

## Technologies Used
- **Backend**: Java 1.8, JSP & Servlets, MySQL
- **Frontend**: HTML, CSS, JavaScript, Chart.js
- **Server**: Apache Tomcat 9.0
- **Database**: MySQL 8.0

## Setup Instructions

### 1. Database Setup
```sql
-- Run database.sql to create database and tables
mysql -u root -p < database.sql

-- Optional: Add sample data
mysql -u root -p < insert_data.sql
```

### 2. Configure Database

Edit `DatabaseUtil.java`:

```java

private static final String URL = "jdbc:mysql://localhost:3306/task_manager";

private static final String USER = "root";      // Your MySQL username

private static final String PASSWORD = "root";     // Your MySQL password
```

### 3. Required JAR File
Download `mysql-connector-java-8.0.28.jar` and place it in:
```
TaskManager/WEB-INF/lib/
```

### 4. Deploy to Tomcat
1. Copy the entire `TaskManager` folder to Tomcat's `webapps/` directory
2. Start Tomcat server
3. Access: `http://localhost:8080/TaskManager/`

## Default Credentials
- **Username**: `admin`
- **Password**: `admin`

## Features
- ✅ User registration and login
- ✅ Project CRUD operations
- ✅ Task CRUD operations with project association
- ✅ Filter tasks by status and priority
- ✅ Sort tasks by date
- ✅ Dashboard with statistics and charts
- ✅ Responsive design
- ✅ Session management and security

## Project Structure
```
TaskManager/
├── src/main/java/     # Java source files
├── src/main/webapp/   # JSP, CSS, JS files
├── database.sql       # Database schema
├── insert_data.sql    # Sample data
└── README.md
```

## Quick Start
1. Setup MySQL database
2. Update database credentials
3. Deploy to Tomcat
4. Login with admin/admin
5. Create projects and tasks
