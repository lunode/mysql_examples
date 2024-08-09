
CREATE DATABASE SchoolSchedulingExample;

USE SchoolSchedulingExample;

CREATE TABLE Buildings (
    BuildingCode NVARCHAR(3) NOT NULL,
    BuildingName NVARCHAR(25) NULL,
    NumberOfFloors SMALLINT NULL,
    ElevatorAccess BIT NOT NULL DEFAULT 0,
    SiteParkingAvailable BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (BuildingCode)
);

CREATE INDEX NumberOfFloors_IDX ON Buildings(NumberOfFloors);

CREATE TABLE Categories (
    CategoryID NVARCHAR(10) NOT NULL,
    CategoryDescription NVARCHAR(75) NULL,
    DepartmentID INT NULL DEFAULT 0,
    PRIMARY KEY (CategoryID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE INDEX DepartmentID_IDX ON Categories(DepartmentID);

CREATE TABLE Class_Rooms (
    ClassRoomID INT NOT NULL,
    BuildingCode NVARCHAR(3) NULL,
    PhoneAvailable BIT NOT NULL DEFAULT 0,
    Capacity SMALLINT NOT NULL DEFAULT 0,
    PRIMARY KEY (ClassRoomID),
    FOREIGN KEY (BuildingCode) REFERENCES Buildings(BuildingCode)
);

CREATE INDEX BuildingCode_IDX ON Class_Rooms(BuildingCode);

CREATE TABLE Classes (
    ClassID INT NOT NULL,
    SubjectID INT NULL DEFAULT 0,
    ClassRoomID INT NULL DEFAULT 0,
    Credits TINYINT NULL DEFAULT 0,
    SemesterNumber SMALLINT,
    StartDate DATE NULL,
    StartTime TIME NULL,
    Duration SMALLINT NULL DEFAULT 0,
    MondaySchedule BIT NOT NULL DEFAULT 0,
    TuesdaySchedule BIT NOT NULL DEFAULT 0,
    WednesdaySchedule BIT NOT NULL DEFAULT 0,
    ThursdaySchedule BIT NOT NULL DEFAULT 0,
    FridaySchedule BIT NOT NULL DEFAULT 0,
    SaturdaySchedule BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (ClassID),
    FOREIGN KEY (ClassRoomID) REFERENCES Class_Rooms(ClassRoomID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

CREATE INDEX SubjectID_IDX ON Classes(SubjectID);
CREATE INDEX ClassRoomID_IDX ON Classes(ClassRoomID);

CREATE TABLE Departments (
    DepartmentID INT NOT NULL,
    DeptName NVARCHAR(50) NULL,
    DeptChair INT NULL DEFAULT 0,
    PRIMARY KEY (DepartmentID),
    FOREIGN KEY (DeptChair) REFERENCES Staff(StaffID)
);

CREATE INDEX StaffDepartments_IDX ON Departments(DeptChair);

CREATE TABLE Faculty (
    StaffID INT NOT NULL,
    Title NVARCHAR(50) NULL,
    Status NVARCHAR(12) NULL,
    Tenured BIT NOT NULL DEFAULT 0,
    PRIMARY KEY (StaffID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE Faculty_Categories (
    StaffID INT NOT NULL,
    CategoryID NVARCHAR(10) NOT NULL DEFAULT 'ACC',
    PRIMARY KEY (StaffID, CategoryID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (StaffID) REFERENCES Faculty(StaffID)
);

CREATE INDEX CategoriesFacultyCategories_IDX ON Faculty_Categories(CategoryID);
CREATE INDEX FacultyFacultyCategories_IDX ON Faculty_Categories(StaffID);

CREATE TABLE Faculty_Classes (
    ClassID INT NOT NULL,
    StaffID INT NOT NULL,
    PRIMARY KEY (ClassID, StaffID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (StaffID) REFERENCES Faculty(StaffID)
);

CREATE INDEX ClassesFacultyClasses_IDX ON Faculty_Classes(ClassID);
CREATE INDEX StaffFacultyClasses_IDX ON Faculty_Classes(StaffID);

CREATE TABLE Faculty_Subjects (
    StaffID INT NOT NULL DEFAULT 0,
    SubjectID INT NOT NULL DEFAULT 0,
    ProficiencyRating REAL NULL DEFAULT 0,
    PRIMARY KEY (StaffID, SubjectID),
    FOREIGN KEY (StaffID) REFERENCES Faculty(StaffID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

CREATE INDEX FacultyFacultySubjects_IDX ON Faculty_Subjects(StaffID);
CREATE INDEX SubjectsFacultySubjects_IDX ON Faculty_Subjects(SubjectID);

CREATE TABLE Majors (
    MajorID INT NOT NULL,
    Major NVARCHAR(20) NULL,
    PRIMARY KEY (MajorID)
);

CREATE TABLE Staff (
    StaffID INT NOT NULL,
    StfFirstName NVARCHAR(25) NULL,
    StfLastname NVARCHAR(25) NULL,
    StfStreetAddress NVARCHAR(50) NULL,
    StfCity NVARCHAR(30) NULL,
    StfState NVARCHAR(2) NULL,
    StfZipCode NVARCHAR(5) NULL,
    StfAreaCode NVARCHAR(5) NULL,
    StfPhoneNumber NVARCHAR(8) NULL,
    Salary DECIMAL(15,2) NULL,
    DateHired DATE NULL,
    Position NVARCHAR(50) NULL,
    PRIMARY KEY (StaffID)
);

CREATE INDEX StaffZipCode_IDX ON Staff(StfZipCode);
CREATE INDEX StaffAreaCode_IDX ON Staff(StfAreaCode);

CREATE TABLE Student_Class_Status (
    ClassStatus INT NOT NULL DEFAULT 0,
    ClassStatusDescription NVARCHAR(50) NULL,
    PRIMARY KEY (ClassStatus)
);

CREATE TABLE Student_Schedules (
    StudentID INT NOT NULL,
    ClassID INT NOT NULL,
    ClassStatus INT NULL DEFAULT 0,
    Grade REAL NULL DEFAULT 0,
    PRIMARY KEY (StudentID, ClassID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID),
    FOREIGN KEY (ClassStatus) REFERENCES Student_Class_Status(ClassStatus),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

CREATE INDEX ClassesStudentSchedules_IDX ON Student_Schedules(ClassID);
CREATE INDEX StudentClassStatusStudentSchedules_IDX ON Student_Schedules(ClassStatus);
CREATE INDEX StudentsStudentSchedules_IDX ON Student_Schedules(StudentID);

CREATE TABLE Students (
    StudentID INT NOT NULL,
    StudFirstName NVARCHAR(25) NULL,
    StudLastName NVARCHAR(25) NULL,
    StudStreetAddress NVARCHAR(50) NULL,
    StudCity NVARCHAR(30) NULL,
    StudState NVARCHAR(2) NULL,
    StudZipCode NVARCHAR(5) NULL,
    StudAreaCode NVARCHAR(5) NULL,
    StudPhoneNumber NVARCHAR(8) NULL,
    StudBirthDate DATE NULL,
    StudGender NVARCHAR(1) NULL,
    StudMaritalStatus NVARCHAR(1) NULL,
    StudMajor INT NULL,
    PRIMARY KEY (StudentID),
    FOREIGN KEY (StudMajor) REFERENCES Majors(MajorID)
);

CREATE INDEX StudAreaCode_IDX ON Students(StudAreaCode);
CREATE INDEX StudZipCode_IDX ON Students(StudZipCode);
CREATE INDEX StudMajor_IDX ON Students(StudMajor);

CREATE TABLE Subjects (
    SubjectID INT NOT NULL DEFAULT 0,
    CategoryID NVARCHAR(10) NULL,
    SubjectCode NVARCHAR(8) NULL,
    SubjectName NVARCHAR(50) NULL,
    SubjectPreReq NVARCHAR(8) NULL DEFAULT NULL,
    SubjectDescription TEXT NULL,
    SubjectEstClassSize SMALLINT NOT NULL DEFAULT 0,
    PRIMARY KEY (SubjectID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SubjectPreReq) REFERENCES Subjects(SubjectCode)
);

CREATE INDEX CategoryID_IDX ON Subjects(CategoryID);
CREATE UNIQUE INDEX SubjectCode_IDX ON Subjects(SubjectCode);
CREATE INDEX SubjectPreReq_IDX ON Subjects(SubjectPreReq);