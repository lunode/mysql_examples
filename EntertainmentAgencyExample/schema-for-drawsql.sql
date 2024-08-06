CREATE DATABASE EntertainmentAgencyExample;

USE EntertainmentAgencyExample;

CREATE TABLE Agents (
    AgentID int NOT NULL,
    AgtFirstName varchar(25) NULL,
    AgtLastName varchar(25) NULL,
    AgtStreetAddress varchar(50) NULL,
    AgtCity varchar(30) NULL,
    AgtState varchar(2) NULL,
    AgtZipCode varchar(10) NULL,
    AgtPhoneNumber varchar(15) NULL,
    DateHired date NULL,
    Salary decimal(15, 2) NULL DEFAULT 0,
    CommissionRate float(24) NULL DEFAULT 0,
    PRIMARY KEY (AgentID)
);

CREATE INDEX AgtZipCode ON Agents(AgtZipCode);

CREATE TABLE Customers (
    CustomerID int NOT NULL,
    CustFirstName varchar(25) NULL,
    CustLastName varchar(25) NULL,
    CustStreetAddress varchar(50) NULL,
    CustCity varchar(30) NULL,
    CustState varchar(2) NULL,
    CustZipCode varchar(10) NULL,
    CustPhoneNumber varchar(15) NULL,
    PRIMARY KEY (CustomerID)
);

CREATE INDEX CustZipCode ON Customers(CustZipCode);

CREATE TABLE Engagements (
    EngagementNumber int NOT NULL,
    StartDate date NULL,
    EndDate date NULL,
    StartTime time NULL,
    StopTime time NULL,
    ContractPrice decimal(15,2) NULL DEFAULT 0,
    CustomerID int NULL,
    AgentID int NULL,
    EntertainerID int NULL,
    PRIMARY KEY (EngagementNumber),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID),
    FOREIGN KEY (EntertainerID) REFERENCES Entertainers(EntertainerID)
);

CREATE INDEX AgentsEngagements ON Engagements(AgentID);
CREATE INDEX CustomersEngagements ON Engagements(CustomerID);
CREATE INDEX EntertainersEngagements ON Engagements(EntertainerID);

CREATE TABLE Entertainer_Members (
    EntertainerID int NOT NULL,
    MemberID int NOT NULL,
    Status smallint NULL DEFAULT 0,
    PRIMARY KEY (EntertainerID, MemberID),
    FOREIGN KEY (EntertainerID) REFERENCES Entertainers(EntertainerID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

CREATE INDEX EntertainersEntertainerMembers ON Entertainer_Members(EntertainerID);
CREATE INDEX MembersEntertainerMembers ON Entertainer_Members(MemberID);

CREATE TABLE Entertainer_Styles (
    EntertainerID int NOT NULL,
    StyleID smallint NOT NULL,
    StyleStrength smallint NOT NULL,
    PRIMARY KEY (EntertainerID, StyleID),
    FOREIGN KEY (EntertainerID) REFERENCES Entertainers(EntertainerID),
    FOREIGN KEY (StyleID) REFERENCES Musical_Styles(StyleID)
);

CREATE INDEX EntertainersEntertainerStyles ON Entertainer_Styles(EntertainerID);
CREATE INDEX MusicalStylesEntStyles ON Entertainer_Styles(StyleID);

CREATE TABLE Entertainers (
    EntertainerID int NOT NULL,
    EntStageName varchar(50) NULL,
    EntSSN varchar(12) NULL,
    EntStreetAddress varchar(50) NULL,
    EntCity varchar(30) NULL,
    EntState varchar(2) NULL,
    EntZipCode varchar(10) NULL,
    EntPhoneNumber varchar(15) NULL,
    EntWebPage varchar(50) NULL,
    EntEMailAddress varchar(50) NULL,
    DateEntered date NULL,
    PRIMARY KEY (EntertainerID)
);

CREATE INDEX EntZipCode ON Entertainers(EntZipCode);

CREATE TABLE Members (
    MemberID int NOT NULL,
    MbrFirstName varchar(25) NULL,
    MbrLastName varchar(25) NULL,
    MbrPhoneNumber varchar(15) NULL,
    Gender varchar(2) NULL,
    PRIMARY KEY (MemberID)
);

CREATE INDEX MemberID ON Members(MemberID);

CREATE TABLE Musical_Preferences (
    CustomerID int NOT NULL,
    StyleID smallint NOT NULL,
    PreferenceSeq smallint NOT NULL,
    PRIMARY KEY (CustomerID, StyleID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (StyleID) REFERENCES Musical_Styles(StyleID)
);

CREATE INDEX CustomersMusicalPreferences ON Musical_Preferences(CustomerID);
CREATE INDEX StyleID ON Musical_Preferences(StyleID);

CREATE TABLE Musical_Styles (
    StyleID smallint NOT NULL,
    StyleName varchar(75) NULL,
    PRIMARY KEY (StyleID)
);

CREATE TABLE ztblDays (
    DateField date NOT NULL,
    PRIMARY KEY (DateField)
);

CREATE TABLE ztblMonths (
    MonthYear varchar(15) NULL,
    YearNumber smallint NOT NULL,
    MonthNumber smallint NOT NULL,
    MonthStart date NULL,
    MonthEnd date NULL,
    January smallint NULL DEFAULT 0,
    February smallint NULL DEFAULT 0,
    March smallint NULL DEFAULT 0,
    April smallint NULL DEFAULT 0,
    May smallint NULL DEFAULT 0,
    June smallint NULL DEFAULT 0,
    July smallint NULL DEFAULT 0,
    August smallint NULL DEFAULT 0,
    September smallint NULL DEFAULT 0,
    October smallint NULL DEFAULT 0,
    November smallint NULL DEFAULT 0,
    December smallint NULL DEFAULT 0,
    PRIMARY KEY (YearNumber, MonthNumber)
);

CREATE UNIQUE INDEX ztblMonths_MonthEnd ON ztblMonths(MonthEnd);
CREATE UNIQUE INDEX ztblMonths_MonthStart ON ztblMonths(MonthStart);
CREATE UNIQUE INDEX ztblMonths_MonthYear ON ztblMonths(MonthYear);

CREATE TABLE ztblSkipLabels (
    LabelCount int NOT NULL,
    PRIMARY KEY (LabelCount)
);

CREATE TABLE ztblWeeks (
    WeekStart date NOT NULL,
    WeekEnd date NULL,
    PRIMARY KEY (WeekStart)
);
