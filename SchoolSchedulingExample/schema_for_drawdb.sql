CREATE DATABASE SchoolSchedulingExample;

USE SchoolSchedulingExample;

CREATE TABLE Buildings (
    BuildingCode VARCHAR(3) NOT NULL,
    BuildingName VARCHAR(25),
    NumberOfFloors SMALLINT,
    ElevatorAccess BOOLEAN NOT NULL DEFAULT FALSE,
    SiteParkingAvailable BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (BuildingCode)
);

CREATE TABLE Categories (
    CategoryID VARCHAR(10) NOT NULL,
    CategoryDescription VARCHAR(75),
    DepartmentID INT DEFAULT 0,
    PRIMARY KEY (CategoryID),
    INDEX (DepartmentID)
);

CREATE TABLE Class_Rooms (
    ClassRoomID INT NOT NULL,
    BuildingCode VARCHAR(3),
    PhoneAvailable BOOLEAN NOT NULL DEFAULT FALSE,
    Capacity SMALLINT NOT NULL DEFAULT 0,
    PRIMARY KEY (ClassRoomID),
    INDEX (BuildingCode)
);

CREATE TABLE Classes (
    ClassID INT NOT NULL,
    SubjectID INT DEFAULT 0,
    ClassRoomID INT DEFAULT 0,
    Credits TINYINT DEFAULT 0,
    SemesterNumber SMALLINT,
    StartDate DATE,
    StartTime TIME,
    Duration SMALLINT DEFAULT 0,
    MondaySchedule BOOLEAN NOT NULL DEFAULT FALSE,
    TuesdaySchedule BOOLEAN NOT NULL DEFAULT FALSE,
    WednesdaySchedule BOOLEAN NOT NULL DEFAULT FALSE,
    ThursdaySchedule BOOLEAN NOT NULL DEFAULT FALSE,
    FridaySchedule BOOLEAN NOT NULL DEFAULT FALSE,
    SaturdaySchedule BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (ClassID),
    INDEX (SubjectID),
    INDEX (ClassRoomID)
);

CREATE TABLE Departments (
    DepartmentID INT NOT NULL,
    DeptName VARCHAR(50),
    DeptChair INT DEFAULT 0,
    PRIMARY KEY (DepartmentID),
    INDEX (DeptChair)
);

CREATE TABLE Faculty (
    StaffID INT NOT NULL,
    Title VARCHAR(50),
    Status VARCHAR(12),
    Tenured BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (StaffID)
);

CREATE TABLE Faculty_Categories (
    StaffID INT NOT NULL,
    CategoryID VARCHAR(10) NOT NULL DEFAULT 'ACC',
    PRIMARY KEY (StaffID, CategoryID),
    INDEX (CategoryID),
    INDEX (StaffID)
);

CREATE TABLE Faculty_Classes (
    ClassID INT NOT NULL,
    StaffID INT NOT NULL,
    PRIMARY KEY (ClassID, StaffID),
    INDEX (ClassID),
    INDEX (StaffID)
);

CREATE TABLE Faculty_Subjects (
    StaffID INT NOT NULL DEFAULT 0,
    SubjectID INT NOT NULL DEFAULT 0,
    ProficiencyRating FLOAT DEFAULT 0,
    PRIMARY KEY (StaffID, SubjectID),
    INDEX (StaffID),
    INDEX (SubjectID)
);

CREATE TABLE Majors (
    MajorID INT NOT NULL,
    Major VARCHAR(20),
    PRIMARY KEY (MajorID)
);

CREATE TABLE Staff (
    StaffID INT NOT NULL,
    StfFirstName VARCHAR(25),
    StfLastName VARCHAR(25),
    StfStreetAddress VARCHAR(50),
    StfCity VARCHAR(30),
    StfState VARCHAR(2),
    StfZipCode VARCHAR(5),
    StfAreaCode VARCHAR(5),
    StfPhoneNumber VARCHAR(8),
    Salary DECIMAL(15, 2),
    DateHired DATE,
    Position VARCHAR(50),
    PRIMARY KEY (StaffID),
    INDEX (StfZipCode),
    INDEX (StfAreaCode)
);

CREATE TABLE Student_Class_Status (
    ClassStatus INT NOT NULL DEFAULT 0,
    ClassStatusDescription VARCHAR(50),
    PRIMARY KEY (ClassStatus)
);

CREATE TABLE Student_Schedules (
    StudentID INT NOT NULL,
    ClassID INT NOT NULL,
    ClassStatus INT DEFAULT 0,
    Grade FLOAT DEFAULT 0,
    PRIMARY KEY (StudentID, ClassID),
    INDEX (ClassID),
    INDEX (ClassStatus),
    INDEX (StudentID)
);

CREATE TABLE Students (
    StudentID INT NOT NULL,
    StudFirstName VARCHAR(25),
    StudLastName VARCHAR(25),
    StudStreetAddress VARCHAR(50),
    StudCity VARCHAR(30),
    StudState VARCHAR(2),
    StudZipCode VARCHAR(5),
    StudAreaCode VARCHAR(5),
    StudPhoneNumber VARCHAR(8),
    StudBirthDate DATE,
    StudGender VARCHAR(1),
    StudMaritalStatus VARCHAR(1),
    StudMajor INT,
    PRIMARY KEY (StudentID),
    INDEX (StudAreaCode),
    INDEX (StudZipCode),
    INDEX (StudMajor)
);

CREATE TABLE Subjects (
    SubjectID INT NOT NULL DEFAULT 0,
    CategoryID VARCHAR(10),
    SubjectCode VARCHAR(8),
    SubjectName VARCHAR(50),
    SubjectPreReq VARCHAR(8),
    SubjectDescription TEXT,
    SubjectEstClassSize SMALLINT NOT NULL DEFAULT 0,
    PRIMARY KEY (SubjectID),
    UNIQUE (SubjectCode),
    INDEX (CategoryID),
    INDEX (SubjectPreReq)
);

CREATE TABLE ztblGenderMatrix (
    Gender VARCHAR(1) NOT NULL,
    Male SMALLINT,
    Female SMALLINT,
    PRIMARY KEY (Gender)
);

CREATE TABLE ztblLetterGrades (
    LetterGrade VARCHAR(3) NOT NULL,
    LowGradePoint FLOAT,
    HighGradePoint FLOAT,
    PRIMARY KEY (LetterGrade)
);

CREATE TABLE ztblMaritalStatusMatrix (
    MaritalStatus VARCHAR(1) NOT NULL,
    Married SMALLINT,
    Single SMALLINT,
    Widowed SMALLINT,
    Divorced SMALLINT,
    PRIMARY KEY (MaritalStatus)
);

CREATE TABLE ztblProfRatings (
    ProfRatingDesc VARCHAR(12),
    ProfRatingLow FLOAT NOT NULL,
    ProfRatingHigh FLOAT,
    PRIMARY KEY (ProfRatingLow)
);

CREATE TABLE ztblSemesterDays (
    SemesterNo SMALLINT NOT NULL,
    SemDate DATE NOT NULL,
    SemDayName VARCHAR(10),
    PRIMARY KEY (SemesterNo, SemDate)
);

CREATE TABLE ztblSeqNumbers (
    Sequence INT NOT NULL DEFAULT 0,
    PRIMARY KEY (Sequence)
);

ALTER TABLE Categories 
    ADD CONSTRAINT FK_Categories_Departments FOREIGN KEY (DepartmentID) REFERENCES Departments (DepartmentID);

ALTER TABLE Class_Rooms 
    ADD CONSTRAINT FK_Class_Rooms_Buildings FOREIGN KEY (BuildingCode) REFERENCES Buildings (BuildingCode);

ALTER TABLE Classes 
    ADD CONSTRAINT FK_Classes_Class_Rooms FOREIGN KEY (ClassRoomID) REFERENCES Class_Rooms (ClassRoomID),
    ADD CONSTRAINT FK_Classes_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects (SubjectID);

ALTER TABLE Departments 
    ADD CONSTRAINT FK_Departments_Staff FOREIGN KEY (DeptChair) REFERENCES Staff (StaffID);

ALTER TABLE Faculty 
    ADD CONSTRAINT FK_Faculty_Staff FOREIGN KEY (StaffID) REFERENCES Staff (StaffID);

ALTER TABLE Faculty_Categories 
    ADD CONSTRAINT FK_Faculty_Categories_Categories FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID),
    ADD CONSTRAINT FK_Faculty_Categories_Faculty FOREIGN KEY (StaffID) REFERENCES Faculty (StaffID);

ALTER TABLE Faculty_Classes 
    ADD CONSTRAINT FK_Faculty_Classes_Classes FOREIGN KEY (ClassID) REFERENCES Classes (ClassID),
    ADD CONSTRAINT FK_Faculty_Classes_Staff FOREIGN KEY (StaffID) REFERENCES Staff (StaffID);

ALTER TABLE Faculty_Subjects 
    ADD CONSTRAINT FK_Faculty_Subjects_Faculty FOREIGN KEY (StaffID) REFERENCES Faculty (StaffID),
    ADD CONSTRAINT FK_Faculty_Subjects_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects (SubjectID);

ALTER TABLE Students 
    ADD CONSTRAINT FK_Students_Majors FOREIGN KEY (StudMajor) REFERENCES Majors (MajorID);

ALTER TABLE Student_Schedules 
    ADD CONSTRAINT FK_Student_Schedules_Classes FOREIGN KEY (ClassID) REFERENCES Classes (ClassID),
    ADD CONSTRAINT FK_Student_Schedules_Student_Class_Status FOREIGN KEY (ClassStatus) REFERENCES Student_Class_Status (ClassStatus),
    ADD CONSTRAINT FK_Student_Schedules_Students FOREIGN KEY (StudentID) REFERENCES Students (StudentID);

ALTER TABLE Subjects 
    ADD CONSTRAINT FK_Subjects_Categories FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID),
    ADD CONSTRAINT FK_Subjects_Subjects FOREIGN KEY (SubjectPreReq) REFERENCES Subjects (SubjectCode);
