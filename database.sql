-- ============================================
-- STUDENT REGISTRATION SYSTEM
-- SQL Script: Database + Table + Sample Data
-- ============================================


-- STEP 1: Create the database
-- This creates a new database called StudentDB
CREATE DATABASE StudentDB;
GO

-- STEP 2: Tell SQL to use that database
USE StudentDB;
GO


-- STEP 3: Create the Students table
-- This is like creating a spreadsheet with defined columns
CREATE TABLE Students (
    StudentID   INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increments: 1, 2, 3...
    FullName    NVARCHAR(100)  NOT NULL,          -- Text, max 100 characters, cannot be empty
    Email       NVARCHAR(150)  NOT NULL UNIQUE,   -- Must be unique (no duplicate emails)
    Phone       CHAR(10)       NOT NULL,           -- Always exactly 10 characters
    Course      NVARCHAR(50)   NOT NULL,           -- e.g. "B.Tech CSE"
    YearOfStudy NVARCHAR(20)   NOT NULL,           -- e.g. "2nd Year"
    DateOfBirth DATE           NOT NULL,           -- Format: YYYY-MM-DD
    CreatedAt   DATETIME       DEFAULT GETDATE()   -- Automatically saves the time of registration
);
GO


-- STEP 4: Insert some sample student records
-- These are test students so the table is not empty
INSERT INTO Students (FullName, Email, Phone, Course, YearOfStudy, DateOfBirth)
VALUES
    ('Atasi Atipriya Rout',  'atasi@gmail.com',   '7008119230', 'B.Tech CSE', '2nd Year', '2005-03-14'),
    ('Riya Sharma',          'riya@gmail.com',    '9876543210', 'BCA',        '1st Year', '2006-07-22'),
    ('Arjun Patel',          'arjun@gmail.com',   '8765432109', 'B.Tech ECE', '3rd Year', '2004-11-05'),
    ('Sneha Mishra',         'sneha@gmail.com',   '7654321098', 'MCA',        '1st Year', '2003-01-30'),
    ('Rohit Das',            'rohit@gmail.com',   '6543210987', 'MBA',        '2nd Year', '2002-09-18');
GO


-- ============================================
-- CRUD OPERATIONS
-- CRUD = Create, Read, Update, Delete
-- These are the 4 basic operations on any database
-- ============================================


-- READ: Get ALL students
SELECT * FROM Students;
GO

-- READ: Get students from a specific course
SELECT * FROM Students
WHERE Course = 'B.Tech CSE';
GO

-- READ: Search student by name (partial match)
SELECT * FROM Students
WHERE FullName LIKE '%Atasi%';
GO

-- READ: Get total count of students
SELECT COUNT(*) AS TotalStudents FROM Students;
GO


-- UPDATE: Change a student's course
UPDATE Students
SET Course = 'B.Tech CSE'
WHERE StudentID = 2;
GO

-- UPDATE: Change phone number by email
UPDATE Students
SET Phone = '9999999999'
WHERE Email = 'riya@gmail.com';
GO


-- DELETE: Remove a student by ID
-- (Be careful! This permanently removes the record)
DELETE FROM Students
WHERE StudentID = 5;
GO


-- ============================================
-- STORED PROCEDURES
-- A stored procedure is a saved SQL function
-- you can call by name instead of writing SQL every time
-- ============================================


-- STORED PROCEDURE 1: Register a new student
CREATE PROCEDURE sp_RegisterStudent
    @FullName    NVARCHAR(100),
    @Email       NVARCHAR(150),
    @Phone       CHAR(10),
    @Course      NVARCHAR(50),
    @YearOfStudy NVARCHAR(20),
    @DateOfBirth DATE
AS
BEGIN
    -- Check if email already exists
    IF EXISTS (SELECT 1 FROM Students WHERE Email = @Email)
    BEGIN
        PRINT 'Error: A student with this email already exists.';
        RETURN;
    END

    -- Insert the new student
    INSERT INTO Students (FullName, Email, Phone, Course, YearOfStudy, DateOfBirth)
    VALUES (@FullName, @Email, @Phone, @Course, @YearOfStudy, @DateOfBirth);

    PRINT 'Student registered successfully!';
END;
GO


-- STORED PROCEDURE 2: Get all students
CREATE PROCEDURE sp_GetAllStudents
AS
BEGIN
    SELECT
        StudentID,
        FullName,
        Email,
        Phone,
        Course,
        YearOfStudy,
        DateOfBirth,
        CreatedAt
    FROM Students
    ORDER BY CreatedAt DESC;  -- Newest first
END;
GO


-- STORED PROCEDURE 3: Delete a student by ID
CREATE PROCEDURE sp_DeleteStudent
    @StudentID INT
AS
BEGIN
    -- Check if student exists
    IF NOT EXISTS (SELECT 1 FROM Students WHERE StudentID = @StudentID)
    BEGIN
        PRINT 'Error: Student not found.';
        RETURN;
    END

    DELETE FROM Students WHERE StudentID = @StudentID;
    PRINT 'Student deleted successfully.';
END;
GO


-- STORED PROCEDURE 4: Search students by name or course
CREATE PROCEDURE sp_SearchStudents
    @SearchTerm NVARCHAR(100)
AS
BEGIN
    SELECT * FROM Students
    WHERE
        FullName LIKE '%' + @SearchTerm + '%'
        OR Course LIKE '%' + @SearchTerm + '%';
END;
GO


-- ============================================
-- HOW TO CALL (USE) THE STORED PROCEDURES
-- ============================================

-- Register a new student:
EXEC sp_RegisterStudent
    @FullName    = 'Priya Singh',
    @Email       = 'priya@gmail.com',
    @Phone       = '9112233445',
    @Course      = 'BCA',
    @YearOfStudy = '1st Year',
    @DateOfBirth = '2006-04-10';
GO

-- Get all students:
EXEC sp_GetAllStudents;
GO

-- Delete student with ID = 3:
EXEC sp_DeleteStudent @StudentID = 3;
GO

-- Search for students named "Riya" or in "BCA":
EXEC sp_SearchStudents @SearchTerm = 'BCA';
GO
