-- ========================
--  STUDENTS TABLE
-- ========================
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    roll_no VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL, -- hashed in production
    course VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    semester INT NOT NULL
);

-- ========================
--  COURSES TABLE
-- ========================
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT
);

-- ========================
--  COURSE ENROLLMENTS
-- (link students ↔ courses)
-- ========================
CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(id) ON DELETE CASCADE
);

-- ========================
--  COURSE MATERIALS
-- ========================
CREATE TABLE course_materials (
    id SERIAL PRIMARY KEY,
    course_id INT REFERENCES courses(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    file_url TEXT NOT NULL, -- link to PDF/PPT in Supabase storage
    material_type VARCHAR(50) -- Notes, PPT, Circular
);

-- ========================
--  ASSIGNMENTS
-- ========================
CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    course_id INT REFERENCES courses(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    due_date DATE NOT NULL,
    file_url TEXT
);

-- ========================
--  ATTENDANCE
-- ========================
CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(id) ON DELETE CASCADE,
    total_classes INT NOT NULL,
    present_classes INT NOT NULL
);

-- ========================
--  MARKS
-- ========================
CREATE TABLE marks (
    id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(id) ON DELETE CASCADE,
    internal_marks INT,
    semester_marks INT,
    total_marks INT
);

-- ========================
--  CIRCULARS
-- ========================
CREATE TABLE circulars (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    category VARCHAR(100),
    date_published DATE DEFAULT CURRENT_DATE,
    file_url TEXT NOT NULL
);