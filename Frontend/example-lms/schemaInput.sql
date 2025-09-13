-- ========================
--  STUDENTS
-- ========================
INSERT INTO students (roll_no, name, password, course, year, semester)
VALUES 
('ITM2023001', 'Anirudh Kushwah', '12345', 'BCA', 3, 5),
('ITM2023002', 'Ritika Sharma', '12345', 'B.Tech CSE', 2, 4),
('ITM2023003', 'Rohit Verma', '12345', 'MBA', 1, 2);

-- ========================
--  COURSES
-- ========================
INSERT INTO courses (course_code, course_name, credits)
VALUES 
('CSE301', 'OOPS with Java', 4),
('HUM101', 'Indian Constitution', 2),
('MTH201', 'Mathematics II', 4);

-- ========================
--  ENROLLMENTS
-- ========================
-- Anirudh enrolled in all 3
INSERT INTO enrollments (student_id, course_id)
VALUES 
(1, 1), (1, 2), (1, 3);

-- Ritika enrolled in Java + Maths
INSERT INTO enrollments (student_id, course_id)
VALUES 
(2, 1), (2, 3);

-- Rohit enrolled in Constitution only
INSERT INTO enrollments (student_id, course_id)
VALUES 
(3, 2);

-- ========================
--  COURSE MATERIALS
-- ========================
INSERT INTO course_materials (course_id, title, file_url, material_type)
VALUES 
(1, 'Java OOPS Unit 1 Notes', 'https://example.com/java_unit1.pdf', 'Notes'),
(1, 'Java OOPS PPTs', 'https://example.com/java_oops.pptx', 'PPT'),
(2, 'Indian Constitution Unit 1', 'https://example.com/consti_unit1.pdf', 'Notes'),
(3, 'Mathematics II Formula Sheet', 'https://example.com/math_formulas.pdf', 'Notes');

-- ========================
--  ASSIGNMENTS
-- ========================
INSERT INTO assignments (course_id, title, description, due_date, file_url)
VALUES 
(1, 'Java Assignment 1', 'Implement Inheritance in Java', '2025-09-25', 'https://example.com/java_assignment1.pdf'),
(2, 'Constitution Assignment', 'Essay on Fundamental Rights', '2025-09-20', 'https://example.com/consti_assignment.pdf');

-- ========================
--  ATTENDANCE
-- ========================
INSERT INTO attendance (student_id, course_id, total_classes, present_classes)
VALUES 
(1, 1, 30, 25),  -- Anirudh Java
(1, 2, 20, 18),  -- Anirudh Constitution
(1, 3, 25, 20),  -- Anirudh Maths
(2, 1, 30, 28),  -- Ritika Java
(2, 3, 25, 22),  -- Ritika Maths
(3, 2, 20, 15);  -- Rohit Constitution

-- ========================
--  MARKS
-- ========================
INSERT INTO marks (student_id, course_id, internal_marks, semester_marks, total_marks)
VALUES 
(1, 1, 18, 65, 83), -- Anirudh Java
(1, 2, 15, 55, 70), -- Anirudh Constitution
(1, 3, 20, 60, 80), -- Anirudh Maths
(2, 1, 16, 70, 86), -- Ritika Java
(2, 3, 18, 62, 80), -- Ritika Maths
(3, 2, 12, 58, 70); -- Rohit Constitution

-- ========================
--  CIRCULARS
-- ========================
INSERT INTO circulars (title, category, date_published, file_url)
VALUES 
('Exam Timetable Sept 2025', 'Examination', '2025-09-10', 'https://example.com/exam_timetable.pdf'),
('Scholarship Form Deadline', 'Scholarship', '2025-09-05', 'https://example.com/scholarship_notice.pdf'),
('Holiday Notice - Gandhi Jayanti', 'General', '2025-09-02', 'https://example.com/holiday_notice.pdf');