CREATE DATABASE CourseManagementSystem;
USE CourseManagementSystem;  
CREATE TABLE Trainee (
    trainee_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    email VARCHAR(100) UNIQUE NOT NULL,
    background VARCHAR(200)
);

CREATE TABLE Trainer (
    trainer_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    duration_hours INT CHECK (duration_hours > 0)
);

CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY,
    course_id INT,
    trainer_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    time_slot VARCHAR(20) CHECK (time_slot IN ('Morning', 'Evening')),
    
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id),
    CONSTRAINT valid_dates CHECK (end_date >= start_date)
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY,
    trainee_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    
    FOREIGN KEY (trainee_id) REFERENCES Trainee(trainee_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    CONSTRAINT unique_enrollment UNIQUE (trainee_id, course_id)
);

-- Insert into Trainee Table
INSERT INTO Trainee (trainee_id, name, gender, email, background) VALUES
(1, 'Aisha Al-Harthy', 'F', 'aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'M', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'F', 'mariam@example.com', 'Marketing'),
(4, 'Omar Al-Balushi', 'M', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'F', 'fatma@example.com', 'Data Science');

-- Insert into Trainer Table
INSERT INTO Trainer (trainer_id, name, specialty, phone, email) VALUES
(1, 'Khalid Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '96893456789', 'salim@example.com');

-- Insert into Course Table
INSERT INTO Course (course_id, title, category, duration_hours) VALUES
(1, 'Database Fundamentals', 'Databases', 20),
(2, 'Web Development Basics', 'Web', 30),
(3, 'Data Science Introduction', 'Data Science', 25),
(4, 'Advanced SQL Queries', 'Databases', 15);

-- Insert into Schedule Table
INSERT INTO Schedule (schedule_id, course_id, trainer_id, start_date, end_date, time_slot) VALUES
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Evening'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning');

-- Insert into Enrollment Table
INSERT INTO Enrollment (enrollment_id, trainee_id, course_id, enrollment_date) VALUES
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');

-- Check all trainees
SELECT * FROM Trainee;
-- Check all trainers
SELECT * FROM Trainer;
-- Check all courses
SELECT * FROM Course;
-- Check all schedules
SELECT * FROM Schedule;
-- Check all enrollments
SELECT * FROM Enrollment;


--  Add the level column to Course table with default 'Beginner' value
ALTER TABLE Course
ADD COLUMN level VARCHAR(20) CHECK (level IN ('Beginner', 'Intermediate', 'Advanced')) DEFAULT 'Beginner';

-- Update existing courses with their correct levels
UPDATE Course SET level = 'Beginner' WHERE course_id IN (1, 2);
UPDATE Course SET level = 'Intermediate' WHERE course_id = 3;
UPDATE Course SET level = 'Advanced' WHERE course_id = 4;

--  Modify the Schedule table to allow 'Weekend' time_slot

ALTER TABLE Schedule
MODIFY COLUMN time_slot VARCHAR(20);

-- add the new CHECK constraint
ALTER TABLE Schedule
ADD CONSTRAINT chk_time_slot 
CHECK (time_slot IN ('Morning', 'Evening', 'Weekend'));

-- Update the schedule for course_id 3 to be 'Weekend' instead of 'Evening'
UPDATE Schedule SET time_slot = 'Weekend' WHERE schedule_id = 3;

-- Verify the changes
SELECT * FROM Course;
SELECT * FROM Schedule;

-- Retrieves all courses with their title, difficulty level, and category
SELECT title, level, category
FROM Course; 
-- Filters courses to only show beginner-level Data Science courses
SELECT title, level, category
FROM Course
WHERE category = 'Data Science' AND level = 'Beginner';

-- Displays all courses that trainee_id 1 is enrolled in
SELECT c.title
FROM Course c
JOIN Enrollment e ON c.course_id = e.course_id
WHERE e.trainee_id = 1;

-- Shows start dates and time slots for all courses trainee_id 1 is taking
SELECT s.start_date, s.time_slot
FROM Schedule s
JOIN Enrollment e ON s.course_id = e.course_id
WHERE e.trainee_id = 1;

-- Returns the total number of courses trainee_id 1 is enrolled in
SELECT COUNT(*) AS enrolled_courses_count
FROM Enrollment
WHERE trainee_id = 1;

-- Displays a complete schedule showing course, instructor, and session time
SELECT 
    c.title AS course_title,
    t.name AS trainer_name,
    s.time_slot
FROM Enrollment e
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON e.course_id = s.course_id
JOIN Trainer t ON s.trainer_id = t.trainer_id
WHERE e.trainee_id = 1;

-- Retrieves all courses assigned to a specific trainer
SELECT c.title
FROM Course c
JOIN Schedule s ON c.course_id = s.course_id
WHERE s.trainer_id = 1;

-- Displays future sessions for a trainer including schedule details
SELECT 
    c.title AS course_title,
    s.start_date,
    s.end_date,
    s.time_slot
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
WHERE s.trainer_id = 1
AND s.start_date >= CURRENT_DATE
ORDER BY s.start_date;

-- Shows enrollment counts per course for a trainer
SELECT 
    c.title AS course_title,
    COUNT(e.trainee_id) AS enrolled_trainees
FROM Course c
JOIN Schedule s ON c.course_id = s.course_id
LEFT JOIN Enrollment e ON c.course_id = e.course_id
WHERE s.trainer_id = 1
GROUP BY c.title;

-- Displays trainee details for each course taught by the trainer
SELECT 
    c.title AS course_title,
    t.name AS trainee_name,
    t.email AS trainee_email
FROM Trainee t
JOIN Enrollment e ON t.trainee_id = e.trainee_id
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id
WHERE s.trainer_id = 1
ORDER BY c.title, t.name;

-- Returns trainer contact information with their course assignments
SELECT 
    tr.name AS trainer_name,
    tr.phone,
    tr.email,
    GROUP_CONCAT(c.title SEPARATOR ', ') AS assigned_courses
FROM Trainer tr
JOIN Schedule s ON tr.trainer_id = s.trainer_id
JOIN Course c ON s.course_id = c.course_id
WHERE tr.trainer_id = 1
GROUP BY tr.trainer_id;

-- Calculates how many distinct courses a trainer is teaching
SELECT 
    COUNT(DISTINCT s.course_id) AS total_courses_teaching
FROM Schedule s
WHERE s.trainer_id = 1;

-- Inserts a new course into the Course table
INSERT INTO Course (course_id, title, category, duration_hours, level)
VALUES (5, 'Python Programming', 'Programming', 40, 'Intermediate');

-- Schedules a new course session with trainer assignment
INSERT INTO Schedule (schedule_id, course_id, trainer_id, start_date, end_date, time_slot)
VALUES (5, 5, 2, '2025-08-01', '2025-08-15', 'Evening');

-- Comprehensive enrollment report with course and schedule details
SELECT 
    t.name AS trainee_name,
    c.title AS course_title,
    c.level AS course_level,
    s.start_date,
    s.end_date,
    s.time_slot,
    tr.name AS trainer_name
FROM Enrollment e
JOIN Trainee t ON e.trainee_id = t.trainee_id
JOIN Course c ON e.course_id = c.course_id
JOIN Schedule s ON c.course_id = s.course_id
JOIN Trainer tr ON s.trainer_id = tr.trainer_id
ORDER BY c.title, t.name;

-- Counts course assignments per trainer
SELECT 
    tr.name AS trainer_name,
    COUNT(DISTINCT s.course_id) AS assigned_courses
FROM Trainer tr
LEFT JOIN Schedule s ON tr.trainer_id = s.trainer_id
GROUP BY tr.trainer_id
ORDER BY assigned_courses DESC;
-- Retrieves trainee details for a specific course
SELECT 
    t.name AS trainee_name,
    t.email,
    t.background
FROM Trainee t
JOIN Enrollment e ON t.trainee_id = e.trainee_id
JOIN Course c ON e.course_id = c.course_id
WHERE c.title = 'Database Fundamentals';

-- Finds the most popular course by enrollment count
SELECT 
    c.title AS course_title,
    COUNT(e.enrollment_id) AS enrollment_count
FROM Course c
LEFT JOIN Enrollment e ON c.course_id = e.course_id
GROUP BY c.course_id
ORDER BY enrollment_count DESC
LIMIT 1;

-- Shows all schedules in chronological order
SELECT 
    c.title AS course_title,
    tr.name AS trainer_name,
    s.start_date,
    s.end_date,
    s.time_slot
FROM Schedule s
JOIN Course c ON s.course_id = c.course_id
JOIN Trainer tr ON s.trainer_id = tr.trainer_id
ORDER BY s.start_date ASC;