DROP DATABASE IF EXISTS lms;
CREATE DATABASE lms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lms;

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100),
    duration_years INT
);

INSERT INTO courses (course_name, duration_years) VALUES
('Bachelor of Computer Applications', 3),
('Bachelor of Science in IT', 3);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    roll_no VARCHAR(20),
    semester INT,
    course_id INT,
    email VARCHAR(100),
    password VARCHAR(255),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students (name, roll_no, semester, course_id, email, password) VALUES
('Anmol Sharma', '101', 5, 1, 'anmol@example.com', 'password123'),
('Khushi Kadam', '102', 5, 1, 'khushi@example.com', 'password123'),
('Anirudh Kushwah', '103', 5, 1, 'anirudh@example.com', 'password123'),
('Ayaan Khan', '104', 5, 1, 'ayaan@example.com', 'password123'),
('Abhi Yadav', '105', 5, 1, 'abhi@example.com', 'password123'),
('Aditya Sharma', '106', 5, 1, 'aditya@example.com', 'password123'),
('Simran Verma', '107', 3, 2, 'simran@example.com', 'password123'),
('Rahul Mehta', '108', 3, 2, 'rahul@example.com', 'password123');

CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    subject_specialization VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO teachers (name, subject_specialization, email) VALUES
('Dr. Meera Nair', 'Database Management Systems', 'meera.nair@college.com'),
('Prof. Ramesh Iyer', 'Computer Networks', 'ramesh.iyer@college.com'),
('Prof. Kavita Sethi', 'Operating Systems', 'kavita.sethi@college.com'),
('Dr. Ajay Mishra', 'Software Engineering', 'ajay.mishra@college.com'),
('Prof. Priya Verma', 'Web Development', 'priya.verma@college.com'),
('Dr. Manish Kulkarni', 'Mathematics', 'manish.kulkarni@college.com');

CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100),
    syllabus TEXT,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

INSERT INTO subjects (subject_name, syllabus, teacher_id) VALUES
('Database Management Systems', 'Relational DBMS, SQL, Normalization, Transactions, Indexing, Stored Procedures, Triggers', 1),
('Computer Networks', 'OSI model, TCP/IP, Routing, Switching, Subnetting, Network Security, Firewalls, VPN', 2),
('Operating Systems', 'Process Management, Threads, Scheduling, Deadlocks, Memory Management, File Systems, I/O', 3),
('Software Engineering', 'SDLC, Agile, UML Diagrams, Testing, Version Control, CI/CD', 4),
('Web Development', 'HTML, CSS, JavaScript, Flask, REST APIs, Authentication, Deployment', 5),
('Mathematics', 'Probability, Statistics, Linear Algebra, Calculus, Discrete Mathematics', 6);

CREATE TABLE classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT,
    class_date DATE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO classes (subject_id, class_date) VALUES
(1, '2025-09-01'), (1, '2025-09-02'), (1, '2025-09-05'),
(2, '2025-09-01'), (2, '2025-09-04'),
(3, '2025-09-03'), (3, '2025-09-06'),
(4, '2025-09-03'), (4, '2025-09-07'),
(5, '2025-09-04'), (5, '2025-09-08'),
(6, '2025-09-02'), (6, '2025-09-05');

CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    class_id INT,
    status ENUM('Present','Absent'),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

INSERT INTO attendance (student_id, class_id, status) VALUES
(1, 1, 'Present'), (1, 2, 'Absent'), (1, 3, 'Present'), (1, 4, 'Present'), (1, 5, 'Present'), (1, 6, 'Absent'),
(2, 1, 'Absent'), (2, 2, 'Absent'), (2, 3, 'Present'), (2, 4, 'Present'), (2, 5, 'Present'), (2, 6, 'Present'),
(3, 1, 'Present'), (3, 2, 'Present'), (3, 3, 'Present'), (3, 4, 'Present'), (3, 5, 'Present'), (3, 6, 'Present'),
(4, 1, 'Absent'), (4, 2, 'Absent'), (4, 3, 'Absent'), (4, 4, 'Present'), (4, 5, 'Present'), (4, 6, 'Absent'),
(5, 1, 'Present'), (5, 2, 'Present'), (5, 3, 'Absent'), (5, 4, 'Present'), (5, 5, 'Present'), (5, 6, 'Present'),
(6, 1, 'Absent'), (6, 2, 'Present'), (6, 3, 'Present'), (6, 4, 'Present'), (6, 5, 'Absent'), (6, 6, 'Present'),
(7, 1, 'Present'), (7, 3, 'Present'), (7, 6, 'Absent'), (7, 8, 'Present'),
(8, 2, 'Present'), (8, 4, 'Absent'), (8, 5, 'Present'), (8, 6, 'Present');

CREATE TABLE results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    marks INT,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO results (student_id, subject_id, marks, grade) VALUES
(1, 1, 85, 'A'), (1, 2, 78, 'B'), (1, 3, 88, 'A'), (1, 4, 75, 'B'), (1, 5, 90, 'A'),
(2, 1, 70, 'B'), (2, 2, 65, 'C'), (2, 3, 60, 'C'), (2, 4, 72, 'B'), (2, 5, 74, 'B'),
(3, 1, 90, 'A'), (3, 2, 85, 'A'), (3, 3, 88, 'A'), (3, 4, 92, 'A'), (3, 5, 95, 'A'),
(4, 1, 55, 'D'), (4, 2, 50, 'D'), (4, 3, 58, 'D'), (4, 4, 62, 'C'), (4, 5, 66, 'C');

CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT,
    title VARCHAR(255),
    description TEXT,
    due_date DATE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO assignments (subject_id, title, description, due_date) VALUES
(1, 'ER Diagram of Library DB', 'Draw an ER diagram for library management system with all relationships', '2025-09-10'),
(5, 'Build a Flask App', 'Create a simple CRUD app using Flask and MySQL integration', '2025-09-15'),
(3, 'Process Scheduling Simulation', 'Implement FCFS and Round Robin scheduling algorithms in C', '2025-09-12'),
(6, 'Probability Assignment', 'Solve 10 problems on Bayes theorem and probability distributions', '2025-09-09');