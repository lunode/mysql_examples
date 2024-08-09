
CREATE DATABASE if not exists SchoolSchedulingExample;
USE SchoolSchedulingExample;
CREATE TABLE ztblGenderMatrix (
    Gender NVARCHAR(1) NOT NULL,
    Male SMALLINT NULL,
    Female SMALLINT NULL,
    PRIMARY KEY (Gender)
);
CREATE TABLE ztblLetterGrades (
    LetterGrade NVARCHAR(3) NOT NULL,
    LowGradePoint REAL NULL,
    HighGradePoint REAL NULL,
    PRIMARY KEY (LetterGrade)
);
CREATE TABLE ztblMaritalStatusMatrix (
    MaritalStatus NVARCHAR(1) NOT NULL,
    Married SMALLINT NULL,
    Single SMALLINT NULL,
    Widowed SMALLINT NULL,
    Divorced SMALLINT NULL,
    PRIMARY KEY (MaritalStatus)
);
CREATE TABLE ztblProfRatings (
    ProfRatingDesc NVARCHAR(12) NULL,
    ProfRatingLow FLOAT(53) NOT NULL,
    ProfRatingHigh FLOAT(53) NULL,
    PRIMARY KEY (ProfRatingLow)
);
CREATE TABLE ztblSemesterDays (
    SemesterNo SMALLINT NOT NULL,
    SemDate DATE NOT NULL,
    SemDayName NVARCHAR(10) NULL,
    PRIMARY KEY (SemesterNo, SemDate)
);
CREATE TABLE ztblSeqNumbers (
    Sequence INT NOT NULL DEFAULT 0,
    PRIMARY KEY (Sequence)
);
