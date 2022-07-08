-- БД "Hospital" https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/14.06.2022/PracticalWork_14_06_2022.sql

USE Hospital

--Дополняем БД

CREATE TABLE Specializations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL
)

CREATE TABLE DoctorsSpecializations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DoctorId INT NOT NULL REFERENCES Doctors(Id),
SpecializationId INT NOT NULL REFERENCES Specializations(Id)
)

CREATE TABLE Sponsors
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL,
)

CREATE TABLE Donations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Amount MONEY CHECK(Amount > 0) NOT NULL,
Date DATE DEFAULT GETDATE() CHECK(Date < GETDATE() AND DATE = GETDATE()),
DepartmentId INT NOT NULL REFERENCES Departments(Id),
SponsorId INT NOT NULL REFERENCES Sponsors(Id),
)

CREATE TABLE Vacations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EndDate DATE NOT NULL,
StartDate DATE NOT NULL,
DoctorId INT NOT NULL REFERENCES Doctors(Id),
CHECK(EndDate > StartDate)
)