DROP DATABASE IF EXISTS lms;
CREATE DATABASE lms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lms;

-- Courses Table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150),
    course_code VARCHAR(20) UNIQUE,
    duration_years INT,
    description TEXT
);

INSERT INTO courses (course_name, course_code, duration_years, description) VALUES
('Bachelor of Computer Applications', 'BCA', 3, 'Comprehensive program covering programming, database management, and software development'),
('Bachelor of Science in Information Technology', 'BSc IT', 3, 'Focus on IT infrastructure, networking, and system administration'),
('Bachelor of Technology in Computer Science', 'B.Tech CS', 4, 'Engineering approach to computer science with advanced mathematics and algorithms');

-- Students Table (Enhanced with personal details)
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    roll_no VARCHAR(20) UNIQUE,
    semester INT,
    year VARCHAR(20),
    course_id INT,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    password VARCHAR(255),
    address TEXT,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    guardian_name VARCHAR(100),
    guardian_phone VARCHAR(15),
    admission_date DATE,
    status ENUM('Active', 'Inactive', 'Graduated') DEFAULT 'Active',
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students (name, roll_no, semester, year, course_id, email, phone_number, password, address, date_of_birth, gender, guardian_name, guardian_phone, admission_date, status) VALUES
('Anmol Sharma', '101', 5, '3rd Year', 1, 'anmol@example.com', '9876543210', 'password123', '123 Main Street, Mumbai, Maharashtra', '2002-03-15', 'Male', 'Rajesh Sharma', '9876543211', '2022-07-01', 'Active'),
('Khushi Kadam', '102', 5, '3rd Year', 1, 'khushi@example.com', '9876543212', 'password123', '456 Park Avenue, Pune, Maharashtra', '2002-05-20', 'Female', 'Suresh Kadam', '9876543213', '2022-07-01', 'Active'),
('Anirudh Kushwah', '103', 5, '3rd Year', 1, 'anirudh@example.com', '9876543214', 'password123', '789 Garden Road, Indore, Madhya Pradesh', '2002-01-10', 'Male', 'Mohan Kushwah', '9876543215', '2022-07-01', 'Active'),
('Ayaan Khan', '104', 5, '3rd Year', 1, 'ayaan@example.com', '9876543216', 'password123', '321 Lake View, Bhopal, Madhya Pradesh', '2002-08-25', 'Male', 'Salim Khan', '9876543217', '2022-07-01', 'Active'),
('Abhi Yadav', '105', 5, '3rd Year', 1, 'abhi@example.com', '9876543218', 'password123', '654 Hill Station, Nagpur, Maharashtra', '2002-11-30', 'Male', 'Ramesh Yadav', '9876543219', '2022-07-01', 'Active'),
('Aditya Sharma', '106', 5, '3rd Year', 1, 'aditya@example.com', '9876543220', 'password123', '987 River Side, Jaipur, Rajasthan', '2002-07-12', 'Male', 'Vikram Sharma', '9876543221', '2022-07-01', 'Active'),
('Simran Verma', '107', 3, '2nd Year', 2, 'simran@example.com', '9876543222', 'password123', '147 Station Road, Delhi', '2003-02-18', 'Female', 'Kiran Verma', '9876543223', '2023-07-01', 'Active'),
('Rahul Mehta', '108', 3, '2nd Year', 2, 'rahul@example.com', '9876543224', 'password123', '258 Market Street, Gurgaon, Haryana', '2003-04-22', 'Male', 'Ashok Mehta', '9876543225', '2023-07-01', 'Active'),
('Rahul Kumar', 'ITM123', 6, '3rd Year', 3, 'rahul.kumar@example.com', '9876543226', '12345', '369 Tech Park, Bangalore, Karnataka', '2002-09-05', 'Male', 'Sunil Kumar', '9876543227', '2022-07-01', 'Active');

-- Teachers Table
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    subject_specialization VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    department VARCHAR(50),
    qualification VARCHAR(100),
    experience_years INT
);

INSERT INTO teachers (name, subject_specialization, email, phone_number, department, qualification, experience_years) VALUES
('Dr. Meera Nair', 'Database Management Systems', 'meera.nair@college.com', '9876501001', 'Computer Science', 'PhD Computer Science', 12),
('Prof. Ramesh Iyer', 'Computer Networks', 'ramesh.iyer@college.com', '9876501002', 'Computer Science', 'M.Tech Networking', 8),
('Prof. Kavita Sethi', 'Operating Systems', 'kavita.sethi@college.com', '9876501003', 'Computer Science', 'M.Sc Computer Science', 10),
('Dr. Ajay Mishra', 'Software Engineering', 'ajay.mishra@college.com', '9876501004', 'Computer Science', 'PhD Software Engineering', 15),
('Prof. Priya Verma', 'Web Development', 'priya.verma@college.com', '9876501005', 'Computer Science', 'M.Tech Web Technologies', 6),
('Dr. Manish Kulkarni', 'Mathematics', 'manish.kulkarni@college.com', '9876501006', 'Mathematics', 'PhD Mathematics', 20),
('Dr. Priya Sharma', 'Object-Oriented Programming', 'priya.sharma@college.com', '9876501007', 'Computer Science', 'PhD Computer Science', 14),
('Prof. Amit Verma', 'Indian Constitution', 'amit.verma@college.com', '9876501008', 'Humanities', 'M.A. Political Science', 9),
('Dr. Suresh Kumar', 'Advanced Mathematics', 'suresh.kumar@college.com', '9876501009', 'Mathematics', 'PhD Mathematics', 18);

-- Subjects Table (Enhanced with more details)
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100),
    subject_code VARCHAR(20) UNIQUE,
    credits INT,
    syllabus TEXT,
    syllabus_link VARCHAR(255),
    description TEXT,
    semester INT,
    teacher_id INT,
    course_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO subjects (subject_name, subject_code, credits, syllabus, syllabus_link, description, semester, teacher_id, course_id) VALUES
('Database Management Systems', 'DBMS301', 4, 'Relational DBMS, SQL, Normalization, Transactions, Indexing, Stored Procedures, Triggers', 'https://example.com/dbms_syllabus.pdf', 'Covers fundamentals of databases, design principles, SQL commands, and optimization.', 5, 1, 1),
('Computer Networks', 'CN302', 4, 'OSI model, TCP/IP, Routing, Switching, Subnetting, Network Security, Firewalls, VPN', 'https://example.com/cn_syllabus.pdf', 'Focuses on how computers communicate over networks, including internet protocols and security.', 5, 2, 1),
('Operating Systems', 'OS303', 4, 'Process Management, Threads, Scheduling, Deadlocks, Memory Management, File Systems, I/O', 'https://example.com/os_syllabus.pdf', 'Teaches core OS concepts like multitasking, resource allocation, and performance.', 5, 3, 1),
('Software Engineering', 'SE304', 4, 'SDLC, Agile, UML Diagrams, Testing, Version Control, CI/CD', 'https://example.com/se_syllabus.pdf', 'Covers software development process, design documentation, and quality assurance.', 5, 4, 1),
('Web Development', 'WD305', 4, 'HTML, CSS, JavaScript, Flask, REST APIs, Authentication, Deployment', 'https://example.com/webdev_syllabus.pdf', 'Focuses on full-stack web development, frontend and backend integration.', 5, 5, 1),
('Mathematics', 'MATH201', 4, 'Probability, Statistics, Linear Algebra, Calculus, Discrete Mathematics', 'https://example.com/maths_syllabus.pdf', 'Covers core mathematics required for computer science.', 3, 6, 2),
('Object-Oriented Programming (Java)', 'CS301', 4, 'Java fundamentals, OOP concepts, Collections, Exception handling, Multithreading, GUI programming', 'https://example.com/java_syllabus.pdf', 'Comprehensive Java programming with focus on object-oriented design patterns.', 6, 7, 3),
('Indian Constitution', 'HS201', 2, 'Constitutional history, Fundamental rights, Directive principles, Amendments, Judicial system', 'https://example.com/constitution_syllabus.pdf', 'Study of Indian Constitution, governance structure and citizen rights.', 6, 8, 3),
('Advanced Mathematics', 'MA301', 4, 'Advanced calculus, Differential equations, Complex analysis, Numerical methods, Graph theory', 'https://example.com/advanced_math_syllabus.pdf', 'Higher mathematics concepts essential for computer science applications.', 6, 9, 3);

-- Course Materials Table (New)
CREATE TABLE course_materials (
    material_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT,
    material_name VARCHAR(255),
    material_type ENUM('Notes', 'PPT', 'Video', 'Lab Manual', 'Reference Book', 'Sample Paper'),
    file_path VARCHAR(500),
    upload_date DATE DEFAULT (CURRENT_DATE),
    description TEXT,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO course_materials (subject_id, material_name, material_type, file_path, description) VALUES
(1, 'Unit 1 - Introduction to DBMS', 'Notes', '/materials/dbms/unit1_notes.pdf', 'Basic concepts of database systems'),
(1, 'SQL Fundamentals', 'PPT', '/materials/dbms/sql_presentation.pptx', 'Complete SQL commands and syntax'),
(1, 'Database Lab Manual', 'Lab Manual', '/materials/dbms/lab_manual.pdf', 'Practical exercises for database operations'),
(7, 'Unit 1 Notes', 'Notes', '/materials/java/unit1_java.pdf', 'Java basics and OOP concepts'),
(7, 'Unit 2 Notes', 'Notes', '/materials/java/unit2_java.pdf', 'Advanced Java concepts'),
(7, 'Unit 3 Notes', 'Notes', '/materials/java/unit3_java.pdf', 'Collections and Exception Handling'),
(7, 'PPT Slides', 'PPT', '/materials/java/java_presentation.pptx', 'Complete Java course slides'),
(7, 'Lab Manual', 'Lab Manual', '/materials/java/java_lab_manual.pdf', 'Programming exercises and assignments'),
(8, 'Constitution PDF', 'Notes', '/materials/constitution/constitution.pdf', 'Complete text of Indian Constitution'),
(8, 'Fundamental Rights', 'Notes', '/materials/constitution/fundamental_rights.pdf', 'Detailed study of fundamental rights'),
(8, 'Amendments', 'Notes', '/materials/constitution/amendments.pdf', 'Constitutional amendments and their significance'),
(8, 'Case Studies', 'Notes', '/materials/constitution/case_studies.pdf', 'Important constitutional cases'),
(8, 'Sample Questions', 'Sample Paper', '/materials/constitution/sample_questions.pdf', 'Previous year questions and model answers'),
(9, 'Calculus Notes', 'Notes', '/materials/math/calculus.pdf', 'Advanced calculus concepts'),
(9, 'Linear Algebra', 'Notes', '/materials/math/linear_algebra.pdf', 'Matrix operations and vector spaces'),
(9, 'Differential Equations', 'Notes', '/materials/math/differential_equations.pdf', 'Solving differential equations'),
(9, 'Formula Sheet', 'Notes', '/materials/math/formula_sheet.pdf', 'Quick reference formulas'),
(9, 'Previous Papers', 'Sample Paper', '/materials/math/previous_papers.pdf', 'Past examination papers');

-- Classes Table
CREATE TABLE classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT,
    class_date DATE,
    start_time TIME,
    end_time TIME,
    room_number VARCHAR(20),
    class_type ENUM('Theory', 'Lab', 'Tutorial') DEFAULT 'Theory',
    topic_covered VARCHAR(255),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO classes (subject_id, class_date, start_time, end_time, room_number, class_type, topic_covered) VALUES
(1, '2025-09-01', '09:00:00', '10:00:00', 'CS101', 'Theory', 'Introduction to DBMS'),
(1, '2025-09-02', '10:00:00', '11:00:00', 'CS101', 'Theory', 'Relational Model'),
(1, '2025-09-05', '11:00:00', '12:00:00', 'LAB1', 'Lab', 'SQL Basic Commands'),
(2, '2025-09-01', '11:00:00', '12:00:00', 'CS102', 'Theory', 'OSI Model'),
(2, '2025-09-04', '09:00:00', '10:00:00', 'CS102', 'Theory', 'TCP/IP Protocol'),
(3, '2025-09-03', '10:00:00', '11:00:00', 'CS103', 'Theory', 'Process Management'),
(3, '2025-09-06', '11:00:00', '12:00:00', 'CS103', 'Theory', 'Memory Management'),
(4, '2025-09-03', '02:00:00', '03:00:00', 'CS104', 'Theory', 'SDLC Models'),
(4, '2025-09-07', '02:00:00', '03:00:00', 'CS104', 'Theory', 'Agile Methodology'),
(5, '2025-09-04', '03:00:00', '04:00:00', 'LAB2', 'Lab', 'HTML and CSS'),
(5, '2025-09-08', '03:00:00', '04:00:00', 'LAB2', 'Lab', 'JavaScript Basics'),
(6, '2025-09-02', '09:00:00', '10:00:00', 'MATH101', 'Theory', 'Probability Theory'),
(6, '2025-09-05', '09:00:00', '10:00:00', 'MATH101', 'Theory', 'Statistics'),
(7, '2025-09-10', '09:00:00', '10:00:00', 'CS201', 'Theory', 'Java Fundamentals'),
(7, '2025-09-11', '10:00:00', '11:00:00', 'CS201', 'Theory', 'OOP Concepts'),
(7, '2025-09-12', '11:00:00', '12:00:00', 'LAB3', 'Lab', 'Java Programming Practice'),
(8, '2025-09-10', '02:00:00', '03:00:00', 'HS101', 'Theory', 'Constitutional History'),
(8, '2025-09-13', '02:00:00', '03:00:00', 'HS101', 'Theory', 'Fundamental Rights'),
(9, '2025-09-11', '03:00:00', '04:00:00', 'MATH201', 'Theory', 'Advanced Calculus'),
(9, '2025-09-14', '03:00:00', '04:00:00', 'MATH201', 'Theory', 'Differential Equations');

-- Attendance Table (Enhanced)
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    class_id INT,
    status ENUM('Present','Absent','Late'),
    marked_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- Attendance data for student ITM123 (Rahul Kumar) - student_id 9
INSERT INTO attendance (student_id, class_id, status) VALUES
(9, 14, 'Present'), (9, 15, 'Absent'), (9, 16, 'Present'),
(9, 17, 'Present'), (9, 18, 'Present'),
(9, 19, 'Late'), (9, 20, 'Present');

-- More attendance records for other students
INSERT INTO attendance (student_id, class_id, status) VALUES
(1, 1, 'Present'), (1, 2, 'Absent'), (1, 3, 'Present'), (1, 4, 'Present'), (1, 5, 'Present'), (1, 6, 'Absent'),
(2, 1, 'Absent'), (2, 2, 'Absent'), (2, 3, 'Present'), (2, 4, 'Present'), (2, 5, 'Present'), (2, 6, 'Present'),
(3, 1, 'Present'), (3, 2, 'Present'), (3, 3, 'Present'), (3, 4, 'Present'), (3, 5, 'Present'), (3, 6, 'Present');

-- Results Table (Enhanced with exam details)
CREATE TABLE results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    exam_type ENUM('Internal', 'Semester', 'Assignment', 'Lab') DEFAULT 'Semester',
    max_marks INT DEFAULT 100,
    obtained_marks INT,
    grade CHAR(2),
    exam_date DATE,
    remarks VARCHAR(255),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Results for student ITM123 (Rahul Kumar) - student_id 9
INSERT INTO results (student_id, subject_id, exam_type, max_marks, obtained_marks, grade, exam_date) VALUES
(9, 7, 'Internal', 40, 35, 'A', '2025-08-15'),
(9, 7, 'Semester', 60, 52, 'A', '2025-09-01'),
(9, 8, 'Internal', 40, 32, 'A', '2025-08-16'),
(9, 8, 'Semester', 60, 48, 'A', '2025-09-02'),
(9, 9, 'Internal', 40, 28, 'B', '2025-08-17'),
(9, 9, 'Semester', 60, 41, 'B', '2025-09-03');

-- More results for other students
INSERT INTO results (student_id, subject_id, exam_type, max_marks, obtained_marks, grade, exam_date) VALUES
(1, 1, 'Semester', 100, 85, 'A', '2025-09-01'),
(1, 2, 'Semester', 100, 78, 'B', '2025-09-02'),
(1, 3, 'Semester', 100, 88, 'A', '2025-09-03'),
(2, 1, 'Semester', 100, 70, 'B', '2025-09-01'),
(2, 2, 'Semester', 100, 65, 'C', '2025-09-02'),
(3, 1, 'Semester', 100, 90, 'A', '2025-09-01'),
(3, 2, 'Semester', 100, 85, 'A', '2025-09-02');

-- Assignments Table (Enhanced)
CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT,
    title VARCHAR(255),
    description TEXT,
    instructions TEXT,
    pdf_link VARCHAR(255),
    assigned_date DATE DEFAULT (CURRENT_DATE),
    due_date DATE,
    max_marks INT DEFAULT 20,
    assignment_type ENUM('Individual', 'Group', 'Lab', 'Project') DEFAULT 'Individual',
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO assignments (subject_id, title, description, instructions, pdf_link, due_date, max_marks, assignment_type) VALUES
(1, 'ER Diagram of Library DB', 'Draw an ER diagram for library management system with all relationships', 'Include entities: Book, Author, Member, Issue, Return. Show all relationships and cardinalities.', 'https://example.com/assignment1.pdf', '2025-09-10', 20, 'Individual'),
(5, 'Build a Flask App', 'Create a simple CRUD app using Flask and MySQL integration', 'Build a student management system with add, view, update, delete operations.', 'https://example.com/assignment2.pdf', '2025-09-15', 30, 'Individual'),
(3, 'Process Scheduling Simulation', 'Implement FCFS and Round Robin scheduling algorithms in C', 'Code both algorithms and compare their performance with sample processes.', 'https://example.com/assignment3.pdf', '2025-09-12', 25, 'Individual'),
(6, 'Probability Assignment', 'Solve 10 problems on Bayes theorem and probability distributions', 'Show complete working for each problem with proper mathematical notation.', 'https://example.com/assignment4.pdf', '2025-09-09', 20, 'Individual'),
(7, 'Java Programming Assignment 3', 'Implement a student management system using OOP concepts', 'Create classes for Student, Course, Grade. Implement inheritance and polymorphism.', 'https://example.com/java_assignment3.pdf', '2025-09-20', 30, 'Individual'),
(8, 'Constitution Essay', 'Write an essay on Fundamental Rights and their importance', 'Essay should be 1500-2000 words with proper citations and examples.', 'https://example.com/constitution_essay.pdf', '2025-09-18', 25, 'Individual'),
(9, 'Calculus Problem Set 5', 'Solve advanced calculus problems on differential equations', 'Include step-by-step solutions for all 15 problems provided.', 'https://example.com/calculus_problems.pdf', '2025-09-25', 20, 'Individual'),
(1, 'Database Design Project', 'Design and implement a complete database for an online shopping system', 'Include ER diagram, normalization, SQL queries, and a working database.', 'https://example.com/db_project.pdf', '2025-09-30', 50, 'Group');

-- Assignment Submissions Table (New)
CREATE TABLE assignment_submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT,
    student_id INT,
    submission_date DATE,
    file_path VARCHAR(500),
    status ENUM('Submitted', 'Late', 'Not Submitted', 'In Progress') DEFAULT 'In Progress',
    obtained_marks INT,
    feedback TEXT,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

-- Sample submissions for student ITM123
INSERT INTO assignment_submissions (assignment_id, student_id, submission_date, file_path, status, obtained_marks, feedback) VALUES
(5, 9, '2025-09-17', '/submissions/java_assignment_rahul.zip', 'Submitted', 28, 'Excellent implementation of OOP concepts'),
(6, 9, '2025-09-16', '/submissions/constitution_essay_rahul.pdf', 'Submitted', 22, 'Well-written essay with good examples'),
(7, 9, NULL, NULL, 'In Progress', NULL, NULL),
(8, 9, NULL, NULL, 'Not Submitted', NULL, NULL);

-- Circulars/Notices Table (New)
CREATE TABLE circulars (
    circular_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    content TEXT,
    category ENUM('Academic', 'Examinations', 'Financial Aid', 'Library', 'Placements', 'Administration', 'Events', 'General') DEFAULT 'General',
    published_date DATE DEFAULT (CURRENT_DATE),
    expiry_date DATE,
    pdf_link VARCHAR(255),
    priority ENUM('High', 'Medium', 'Low') DEFAULT 'Medium',
    target_audience ENUM('All Students', 'Specific Course', 'Specific Year', 'Faculty', 'Staff') DEFAULT 'All Students',
    is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO circulars (title, content, category, published_date, expiry_date, pdf_link, priority, target_audience) VALUES
('End Semester Examination Timetable', 'The end semester examination timetable for all courses has been published. Students are advised to check their exam dates and plan accordingly.', 'Examinations', '2025-09-10', '2025-12-31', '/circulars/exam_timetable_2025.pdf', 'High', 'All Students'),
('Scholarship Application Deadline', 'Reminder: The deadline for scholarship applications is September 30, 2025. All eligible students must submit their applications before the deadline.', 'Financial Aid', '2025-09-08', '2025-09-30', '/circulars/scholarship_2025.pdf', 'High', 'All Students'),
('Industrial Visit Permission Form', 'Students interested in participating in the upcoming industrial visit must submit their permission forms by September 20, 2025.', 'Academic', '2025-09-05', '2025-09-20', '/circulars/industrial_visit_form.pdf', 'Medium', 'Specific Course'),
('Library Fine Waiver Notice', 'The library is offering a fine waiver for overdue books returned between September 15-20, 2025. Students can return books without penalty during this period.', 'Library', '2025-09-03', '2025-09-20', '/circulars/library_fine_waiver.pdf', 'Medium', 'All Students'),
('Campus Placement Drive Schedule', 'The campus placement drive will commence from October 1, 2025. Final year students are requested to register for companies of their interest.', 'Placements', '2025-09-01', '2025-10-15', '/circulars/placement_drive_2025.pdf', 'High', 'Specific Year'),
('Student ID Card Renewal Process', 'Student ID card renewal process has been simplified. Students can now renew their ID cards online through the student portal.', 'Administration', '2025-08-28', '2025-12-31', '/circulars/id_renewal_process.pdf', 'Low', 'All Students'),
('Annual Tech Fest Registration', 'Registration for the annual tech fest TechnoVision 2025 is now open. Students can participate in various technical and cultural events.', 'Events', '2025-08-25', '2025-10-01', '/circulars/techfest_registration.pdf', 'Medium', 'All Students'),
('Hostel Room Allocation', 'Hostel room allocation for the new academic year has been completed. Students can check their allotted rooms on the hostel portal.', 'Administration', '2025-08-20', '2025-09-30', '/circulars/hostel_allocation.pdf', 'Medium', 'All Students');

-- Student_Subjects Enrollment Table (Enhanced)
CREATE TABLE student_subjects (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    subject_id INT,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('Enrolled', 'Dropped', 'Completed') DEFAULT 'Enrolled',
    academic_year VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO student_subjects (student_id, subject_id, academic_year) VALUES
-- Enrollments for BCA students (5th semester)
(1, 1, '2024-25'), (1, 2, '2024-25'), (1, 3, '2024-25'), (1, 4, '2024-25'), (1, 5, '2024-25'),
(2, 1, '2024-25'), (2, 2, '2024-25'), (2, 3, '2024-25'), (2, 4, '2024-25'), (2, 5, '2024-25'),
(3, 1, '2024-25'), (3, 2, '2024-25'), (3, 3, '2024-25'), (3, 4, '2024-25'), (3, 5, '2024-25'),
(4, 1, '2024-25'), (4, 2, '2024-25'), (4, 3, '2024-25'), (4, 4, '2024-25'), (4, 5, '2024-25'),
(5, 1, '2024-25'), (5, 2, '2024-25'), (5, 3, '2024-25'), (5, 4, '2024-25'), (5, 5, '2024-25'),
(6, 1, '2024-25'), (6, 2, '2024-25'), (6, 3, '2024-25'), (6, 4, '2024-25'), (6, 5, '2024-25'),
-- Enrollments for BSc IT students (3rd semester)
(7, 6, '2024-25'), (8, 6, '2024-25'),
-- Enrollments for B.Tech CS student (6th semester) - Rahul Kumar
(9, 7, '2024-25'), (9, 8, '2024-25'), (9, 9, '2024-25');

-- Fees Table (New)
CREATE TABLE fees (
    fee_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    academic_year VARCHAR(10),
    semester INT,
    tuition_fee DECIMAL(10,2),
    lab_fee DECIMAL(10,2),
    library_fee DECIMAL(10,2),
    exam_fee DECIMAL(10,2),
    other_fees DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    paid_amount DECIMAL(10,2),
    due_amount DECIMAL(10,2),
    due_date DATE,
    payment_status ENUM('Paid', 'Partial', 'Pending', 'Overdue') DEFAULT 'Pending',
    last_payment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

INSERT INTO fees (student_id, academic_year, semester, tuition_fee, lab_fee, library_fee, exam_fee, other_fees, total_amount, paid_amount, due_amount, due_date, payment_status, last_payment_date) VALUES
(9, '2024-25', 6, 25000.00, 2000.00, 500.00, 1000.00, 1500.00, 30000.00, 30000.00, 0.00, '2025-08-15', 'Paid', '2025-08-10'),
(1, '2024-25', 5, 20000.00, 1500.00, 500.00, 800.00, 1200.00, 24000.00, 24000.00, 0.00, '2025-08-15', 'Paid', '2025-08-05'),
(2, '2024-25', 5, 20000.00, 1500.00, 500.00, 800.00, 1200.00, 24000.00, 15000.00, 9000.00, '2025-08-15', 'Partial', '2025-08-01');

-- Timetable Table (New)
CREATE TABLE timetable (
    timetable_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
    start_time TIME,
    end_time TIME,
    room_number VARCHAR(20),
    semester INT,
    academic_year VARCHAR(10),
    class_type ENUM('Theory', 'Lab', 'Tutorial') DEFAULT 'Theory',
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO timetable (subject_id, day_of_week, start_time, end_time, room_number, semester, academic_year, class_type) VALUES
-- Timetable for B.Tech CS 6th semester (Rahul Kumar's subjects)
(7, 'Monday', '09:00:00', '10:00:00', 'CS201', 6, '2024-25', 'Theory'),
(8, 'Monday', '10:00:00', '11:00:00', 'HS101', 6, '2024-25', 'Theory'),
(9, 'Monday', '11:00:00', '12:00:00', 'MATH201', 6, '2024-25', 'Theory'),
(7, 'Tuesday', '09:00:00', '11:00:00', 'LAB3', 6, '2024-25', 'Lab'),
(8, 'Wednesday', '02:00:00', '03:00:00', 'HS101', 6, '2024-25', 'Theory'),
(9, 'Thursday', '03:00:00', '04:00:00', 'MATH201', 6, '2024-25', 'Theory'),
(7, 'Friday', '10:00:00', '11:00:00', 'CS201', 6, '2024-25', 'Theory');

-- Library Books Table (New)
CREATE TABLE library_books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE,
    title VARCHAR(255),
    author VARCHAR(255),
    publisher VARCHAR(100),
    publication_year YEAR,
    category VARCHAR(100),
    subject_id INT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    location VARCHAR(50),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO library_books (isbn, title, author, publisher, publication_year, category, subject_id, total_copies, available_copies, location) VALUES
('978-0134685991', 'Effective Java', 'Joshua Bloch', 'Addison-Wesley', 2017, 'Programming', 7, 5, 3, 'CS-A1'),
('978-0596009205', 'Head First Java', 'Kathy Sierra, Bert Bates', 'O\'Reilly Media', 2005, 'Programming', 7, 3, 2, 'CS-A2'),
('978-8120347724', 'Indian Constitution at Work', 'NCERT', 'NCERT Publications', 2019, 'Political Science', 8, 10, 8, 'HS-B1'),
('978-0073383095', 'Advanced Engineering Mathematics', 'Erwin Kreyszig', 'Wiley', 2011, 'Mathematics', 9, 4, 2, 'MATH-C1'),
('978-0321751041', 'Database System Concepts', 'Abraham Silberschatz', 'McGraw-Hill', 2019, 'Database', 1, 6, 4, 'CS-D1');

-- Library Transactions Table (New)
CREATE TABLE library_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    book_id INT,
    issue_date DATE,
    due_date DATE,
    return_date DATE,
    fine_amount DECIMAL(8,2) DEFAULT 0.00,
    status ENUM('Issued', 'Returned', 'Overdue', 'Lost') DEFAULT 'Issued',
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES library_books(book_id)
);

INSERT INTO library_transactions (student_id, book_id, issue_date, due_date, return_date, fine_amount, status) VALUES
(9, 1, '2025-08-15', '2025-09-15', NULL, 0.00, 'Issued'),
(9, 3, '2025-08-20', '2025-09-20', '2025-09-10', 0.00, 'Returned'),
(1, 5, '2025-09-01', '2025-10-01', NULL, 0.00, 'Issued');

-- Events Table (New)
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(255),
    event_type ENUM('Technical', 'Cultural', 'Sports', 'Academic', 'Workshop', 'Seminar', 'Competition'),
    description TEXT,
    event_date DATE,
    start_time TIME,
    end_time TIME,
    venue VARCHAR(100),
    organizer VARCHAR(100),
    registration_required BOOLEAN DEFAULT TRUE,
    registration_deadline DATE,
    max_participants INT,
    contact_email VARCHAR(100),
    status ENUM('Upcoming', 'Ongoing', 'Completed', 'Cancelled') DEFAULT 'Upcoming'
);

INSERT INTO events (event_name, event_type, description, event_date, start_time, end_time, venue, organizer, registration_deadline, max_participants, contact_email) VALUES
('TechnoVision 2025', 'Technical', 'Annual technical fest with coding competitions, hackathons, and tech talks', '2025-10-15', '09:00:00', '18:00:00', 'Main Campus', 'Computer Science Department', '2025-10-01', 500, 'techfest@college.com'),
('Cultural Night', 'Cultural', 'Annual cultural program showcasing student talents in music, dance, and drama', '2025-11-20', '18:00:00', '22:00:00', 'Auditorium', 'Cultural Committee', '2025-11-10', 200, 'cultural@college.com'),
('Java Workshop', 'Workshop', 'Hands-on workshop on advanced Java programming and frameworks', '2025-09-25', '10:00:00', '16:00:00', 'Computer Lab 1', 'Prof. Priya Sharma', '2025-09-20', 50, 'priya.sharma@college.com');

-- Event Registrations Table (New)
CREATE TABLE event_registrations (
    registration_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT,
    student_id INT,
    registration_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('Registered', 'Confirmed', 'Cancelled', 'Attended') DEFAULT 'Registered',
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

INSERT INTO event_registrations (event_id, student_id, status) VALUES
(1, 9, 'Registered'),
(3, 9, 'Confirmed'),
(1, 1, 'Registered'),
(2, 2, 'Registered');

-- Sample Queries for Chatbot Integration

-- 1. Get complete student profile
-- SELECT s.*, c.course_name, c.course_code 
-- FROM students s 
-- JOIN courses c ON s.course_id = c.course_id 
-- WHERE s.roll_no = 'ITM123';

-- 2. Get student's enrolled subjects with teacher information
-- SELECT sub.subject_name, sub.subject_code, sub.credits, t.name as teacher_name, t.email as teacher_email
-- FROM student_subjects ss 
-- JOIN subjects sub ON ss.subject_id = sub.subject_id 
-- JOIN teachers t ON sub.teacher_id = t.teacher_id 
-- WHERE ss.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123');

-- 3. Get student's timetable
-- SELECT sub.subject_name, tt.day_of_week, tt.start_time, tt.end_time, tt.room_number, tt.class_type
-- FROM timetable tt
-- JOIN subjects sub ON tt.subject_id = sub.subject_id
-- JOIN student_subjects ss ON sub.subject_id = ss.subject_id
-- WHERE ss.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123')
-- ORDER BY FIELD(tt.day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'), tt.start_time;

-- 4. Get student's attendance summary
-- SELECT sub.subject_name,
--        COUNT(a.attendance_id) as total_classes,
--        SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) as present_classes,
--        SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) as absent_classes,
--        ROUND((SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_id)), 2) as attendance_percentage
-- FROM attendance a
-- JOIN classes cl ON a.class_id = cl.class_id
-- JOIN subjects sub ON cl.subject_id = sub.subject_id
-- WHERE a.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123')
-- GROUP BY sub.subject_id, sub.subject_name;

-- 5. Get student's results with calculated totals
-- SELECT sub.subject_name,
--        SUM(CASE WHEN r.exam_type = 'Internal' THEN r.obtained_marks ELSE 0 END) as internal_marks,
--        SUM(CASE WHEN r.exam_type = 'Semester' THEN r.obtained_marks ELSE 0 END) as semester_marks,
--        SUM(r.obtained_marks) as total_marks,
--        MAX(r.grade) as grade
-- FROM results r
-- JOIN subjects sub ON r.subject_id = sub.subject_id
-- WHERE r.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123')
-- GROUP BY sub.subject_id, sub.subject_name;

-- 6. Get student's pending assignments
-- SELECT sub.subject_name, a.title, a.description, a.due_date, 
--        COALESCE(asub.status, 'Not Started') as submission_status
-- FROM assignments a
-- JOIN subjects sub ON a.subject_id = sub.subject_id
-- JOIN student_subjects ss ON sub.subject_id = ss.subject_id
-- LEFT JOIN assignment_submissions asub ON a.assignment_id = asub.assignment_id 
--     AND asub.student_id = ss.student_id
-- WHERE ss.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123')
--   AND a.due_date >= CURRENT_DATE
-- ORDER BY a.due_date;

-- 7. Get active circulars/notices
-- SELECT title, content, category, published_date, pdf_link, priority
-- FROM circulars
-- WHERE is_active = TRUE 
--   AND (expiry_date IS NULL OR expiry_date >= CURRENT_DATE)
--   AND (target_audience = 'All Students' OR target_audience = 'Specific Year')
-- ORDER BY priority DESC, published_date DESC;

-- 8. Get student's course materials
-- SELECT sub.subject_name, cm.material_name, cm.material_type, cm.file_path, cm.description
-- FROM course_materials cm
-- JOIN subjects sub ON cm.subject_id = sub.subject_id
-- JOIN student_subjects ss ON sub.subject_id = ss.subject_id
-- WHERE ss.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123')
-- ORDER BY sub.subject_name, cm.material_type;

-- 9. Get student's fee details
-- SELECT academic_year, semester, total_amount, paid_amount, due_amount, 
--        due_date, payment_status, last_payment_date
-- FROM fees
-- WHERE student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123')
-- ORDER BY academic_year DESC, semester DESC;

-- 10. Get student's library transactions
-- SELECT lb.title, lb.author, lt.issue_date, lt.due_date, lt.return_date, 
--        lt.fine_amount, lt.status
-- FROM library_transactions lt
-- JOIN library_books lb ON lt.book_id = lb.book_id
-- WHERE lt.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123')
-- ORDER BY lt.issue_date DESC;

-- 11. Get upcoming events
-- SELECT event_name, event_type, description, event_date, start_time, venue, 
--        registration_deadline, max_participants,
--        (SELECT COUNT(*) FROM event_registrations er WHERE er.event_id = e.event_id) as registered_count
-- FROM events e
-- WHERE status = 'Upcoming' AND event_date >= CURRENT_DATE
-- ORDER BY event_date;

-- 12. Check if student is registered for events
-- SELECT e.event_name, e.event_date, er.registration_date, er.status
-- FROM event_registrations er
-- JOIN events e ON er.event_id = e.event_id
-- WHERE er.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123');

-- Additional utility queries for chatbot

-- 13. Get teacher contact information for a subject
-- SELECT t.name, t.email, t.phone_number, t.qualification, sub.subject_name
-- FROM teachers t
-- JOIN subjects sub ON t.teacher_id = sub.teacher_id
-- WHERE sub.subject_code = 'CS301';

-- 14. Get class schedule for today
-- SELECT sub.subject_name, tt.start_time, tt.end_time, tt.room_number, tt.class_type
-- FROM timetable tt
-- JOIN subjects sub ON tt.subject_id = sub.subject_id
-- JOIN student_subjects ss ON sub.subject_id = ss.subject_id
-- WHERE ss.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123')
--   AND tt.day_of_week = DAYNAME(CURRENT_DATE())
-- ORDER BY tt.start_time;

-- 15. Get assignment submission status
-- SELECT a.title, a.due_date, 
--        CASE 
--          WHEN asub.submission_date IS NOT NULL THEN 'Submitted'
--          WHEN a.due_date < CURRENT_DATE THEN 'Overdue'
--          ELSE 'Pending'
--        END as status,
--        asub.obtained_marks, asub.feedback
-- FROM assignments a
-- JOIN subjects sub ON a.subject_id = sub.subject_id
-- JOIN student_subjects ss ON sub.subject_id = ss.subject_id
-- LEFT JOIN assignment_submissions asub ON a.assignment_id = asub.assignment_id 
--     AND asub.student_id = ss.student_id
-- WHERE ss.student_id = (SELECT student_id FROM students WHERE roll_no = 'ITM123')
-- ORDER BY a.due_date;