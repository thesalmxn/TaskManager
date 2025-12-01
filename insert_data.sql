USE task_manager;

-- Clear existing data (optional)
-- DELETE FROM tasks;
-- DELETE FROM projects;

-- Create admin user if not exists
INSERT IGNORE INTO users (username, email, password_hash) VALUES 
('admin', 'admin@ai.edu', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918');

-- Get user ID
SET @user_id = (SELECT id FROM users WHERE username = 'admin');

-- Insert projects
INSERT INTO projects (name, description, user_id) VALUES
('Machine Learning', 'ML algorithms and applications', @user_id),
('Deep Learning', 'Neural networks and architectures', @user_id),
('NLP', 'Natural language processing tasks', @user_id),
('Computer Vision', 'Image processing and recognition', @user_id),
('Reinforcement Learning', 'Agent learning systems', @user_id),
('AI Ethics', 'Ethical considerations in AI', @user_id),
('AI Research', 'Advanced AI project work', @user_id);

-- Get project IDs
SELECT @p1:=id FROM projects WHERE name='Machine Learning';
SELECT @p2:=id FROM projects WHERE name='Deep Learning';
SELECT @p3:=id FROM projects WHERE name='NLP';
SELECT @p4:=id FROM projects WHERE name='Computer Vision';
SELECT @p5:=id FROM projects WHERE name='Reinforcement Learning';
SELECT @p6:=id FROM projects WHERE name='AI Ethics';
SELECT @p7:=id FROM projects WHERE name='AI Research';

-- Insert tasks with varying counts per project
-- Project 1: 5 tasks
INSERT INTO tasks (title, description, status, priority, due_date, project_id) VALUES
('Linear Regression', 'Implement LR model', 'done', 'medium', '2024-01-15', @p1),
('Logistic Regression', 'Binary classification', 'done', 'medium', '2024-01-18', @p1),
('Decision Trees', 'Tree-based models', 'in_progress', 'low', '2024-01-25', @p1),
('SVM', 'Support vector machines', 'todo', 'high', '2024-01-30', @p1),
('Model Evaluation', 'Performance metrics', 'todo', 'medium', '2024-02-05', @p1);

-- Project 2: 8 tasks
INSERT INTO tasks (title, description, status, priority, due_date, project_id) VALUES
('Perceptron', 'Basic NN', 'done', 'low', '2024-01-10', @p2),
('Backpropagation', 'NN training', 'done', 'medium', '2024-01-12', @p2),
('CNN', 'Convolutional networks', 'in_progress', 'high', '2024-01-28', @p2),
('RNN', 'Recurrent networks', 'in_progress', 'high', '2024-01-30', @p2),
('TensorFlow Setup', 'Framework setup', 'done', 'low', '2024-01-08', @p2),
('Transfer Learning', 'Use pre-trained models', 'todo', 'medium', '2024-02-10', @p2),
('Hyperparameter Tuning', 'Optimize NN', 'todo', 'medium', '2024-02-12', @p2),
('Paper Review', 'Read research paper', 'todo', 'low', '2024-02-15', @p2);

-- Project 3: 6 tasks
INSERT INTO tasks (title, description, status, priority, due_date, project_id) VALUES
('Text Cleaning', 'Preprocess text data', 'done', 'low', '2024-01-14', @p3),
('Sentiment Analysis', 'Classify sentiments', 'in_progress', 'high', '2024-01-26', @p3),
('NER', 'Named entity recognition', 'todo', 'medium', '2024-01-31', @p3),
('Text Summarization', 'Summarize documents', 'todo', 'high', '2024-02-03', @p3),
('Word Embeddings', 'Study embeddings', 'done', 'low', '2024-01-16', @p3),
('Chatbot', 'Build simple chatbot', 'in_progress', 'medium', '2024-01-29', @p3);

-- Project 4: 7 tasks
INSERT INTO tasks (title, description, status, priority, due_date, project_id) VALUES
('Image Filters', 'Basic filtering', 'done', 'low', '2024-01-13', @p4),
('Edge Detection', 'Detect edges', 'done', 'medium', '2024-01-17', @p4),
('Object Detection', 'Detect objects', 'in_progress', 'high', '2024-01-27', @p4),
('Face Recognition', 'Recognize faces', 'in_progress', 'high', '2024-01-31', @p4),
('Image Segmentation', 'Segment images', 'todo', 'medium', '2024-02-07', @p4),
('Dataset Prep', 'Prepare dataset', 'todo', 'low', '2024-02-10', @p4),
('Optical Flow', 'Motion analysis', 'todo', 'medium', '2024-02-12', @p4);

-- Project 5: 5 tasks
INSERT INTO tasks (title, description, status, priority, due_date, project_id) VALUES
('Q-Learning', 'Basic RL algorithm', 'done', 'medium', '2024-01-16', @p5),
('CartPole', 'Solve RL problem', 'in_progress', 'high', '2024-01-27', @p5),
('Deep Q Network', 'DQN implementation', 'in_progress', 'high', '2024-02-05', @p5),
('Policy Gradients', 'PG methods', 'todo', 'medium', '2024-02-09', @p5),
('Multi-Agent RL', 'Multi-agent systems', 'todo', 'low', '2024-02-14', @p5);

-- Project 6: 4 tasks
INSERT INTO tasks (title, description, status, priority, due_date, project_id) VALUES
('AI Bias', 'Study bias in AI', 'done', 'medium', '2024-01-17', @p6),
('Privacy Issues', 'Privacy concerns', 'in_progress', 'high', '2024-01-26', @p6),
('Ethics Framework', 'Ethical frameworks', 'todo', 'medium', '2024-02-06', @p6),
('Regulations', 'AI regulations', 'todo', 'low', '2024-02-10', @p6);

-- Project 7: 9 tasks
INSERT INTO tasks (title, description, status, priority, due_date, project_id) VALUES
('Proposal', 'Project proposal', 'done', 'high', '2024-01-05', @p7),
('Literature Review', 'Review papers', 'done', 'high', '2024-01-12', @p7),
('Data Collection', 'Gather data', 'done', 'medium', '2024-01-15', @p7),
('Methodology', 'Design methods', 'in_progress', 'high', '2024-01-27', @p7),
('Experiment Setup', 'Setup experiments', 'in_progress', 'medium', '2024-01-29', @p7),
('Model Implementation', 'Implement model', 'todo', 'high', '2024-02-02', @p7),
('Run Experiments', 'Execute experiments', 'todo', 'high', '2024-02-09', @p7),
('Analyze Results', 'Result analysis', 'todo', 'medium', '2024-02-12', @p7),
('Write Paper', 'Final paper', 'todo', 'high', '2024-02-20', @p7);

SELECT 'Data insertion complete!' as Status;
SELECT p.name, COUNT(t.id) as Tasks FROM projects p JOIN tasks t ON p.id = t.project_id GROUP BY p.name;
SELECT * FROM TASKS;
SELECT * FROM projects;
SELECT * FROM USERS;