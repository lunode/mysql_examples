CREATE DATABASE BowlingLeagueExample;

USE BowlingLeagueExample;

CREATE TABLE Teams (
    TeamID int NOT NULL DEFAULT 0,
    TeamName nvarchar(50) NOT NULL,
    CaptainID int NULL,
    PRIMARY KEY (TeamID)
);

CREATE TABLE Bowlers (
    BowlerID int NOT NULL DEFAULT 0,
    BowlerLastName nvarchar(50) NULL,
    BowlerFirstName nvarchar(50) NULL,
    BowlerMiddleInit nvarchar(1) NULL,
    BowlerAddress nvarchar(50) NULL,
    BowlerCity nvarchar(50) NULL,
    BowlerState nvarchar(2) NULL,
    BowlerZip nvarchar(10) NULL,
    BowlerPhoneNumber nvarchar(14) NULL,
    TeamID int NULL,
    PRIMARY KEY (BowlerID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
CREATE TABLE Match_Games (
    MatchID int NOT NULL DEFAULT 0,
    GameNumber smallint NOT NULL DEFAULT 0,
    WinningTeamID int NULL DEFAULT 0,
    PRIMARY KEY (MatchID, GameNumber),
    FOREIGN KEY (MatchID) REFERENCES Tourney_Matches(MatchID)
);
CREATE TABLE Tourney_Matches (
    MatchID int NOT NULL DEFAULT 0,
    TourneyID int NULL DEFAULT 0,
    Lanes nvarchar(5) NULL,
    OddLaneTeamID int NULL DEFAULT 0,
    EvenLaneTeamID int NULL DEFAULT 0,
    PRIMARY KEY (MatchID),
    FOREIGN KEY (OddLaneTeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (EvenLaneTeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (TourneyID) REFERENCES Tournaments(TourneyID)
);
CREATE TABLE Tournaments (
    TourneyID int NOT NULL DEFAULT 0,
    TourneyDate date NULL,
    TourneyLocation nvarchar(50) NULL,
    PRIMARY KEY (TourneyID)
);
CREATE TABLE Bowler_Scores (
    MatchID int NOT NULL DEFAULT 0,
    GameNumber smallint NOT NULL DEFAULT 0,
    BowlerID int NOT NULL DEFAULT 0,
    RawScore smallint NULL DEFAULT 0,
    HandiCapScore smallint NULL DEFAULT 0,
    WonGame bit NOT NULL DEFAULT 0,
    PRIMARY KEY (MatchID, GameNumber, BowlerID),
    FOREIGN KEY (BowlerID) REFERENCES Bowlers(BowlerID),
    FOREIGN KEY (MatchID, GameNumber) REFERENCES Match_Games(MatchID, GameNumber)
);
CREATE INDEX BowlerID ON Bowler_Scores(BowlerID);
CREATE INDEX MatchGamesBowlerScores ON Bowler_Scores(MatchID, GameNumber);
CREATE TABLE ztblWeeks (
    WeekStart date NOT NULL,
    WeekEnd date NULL,
    PRIMARY KEY (WeekStart)
);
CREATE UNIQUE INDEX ztblMonths_MonthEnd ON ztblMonths(MonthEnd);
CREATE UNIQUE INDEX ztblMonths_MonthStart ON ztblMonths(MonthStart);
CREATE UNIQUE INDEX ztblMonths_MonthYear ON ztblMonths(MonthYear);
CREATE TABLE ztblSkipLabels (
    LabelCount int NOT NULL,
    PRIMARY KEY (LabelCount)
);
CREATE TABLE ztblBowlerRatings (
    BowlerRating nvarchar(15) NOT NULL,
    BowlerLowAvg smallint NULL,
    BowlerHighAvg smallint NULL,
    PRIMARY KEY (BowlerRating)
);
