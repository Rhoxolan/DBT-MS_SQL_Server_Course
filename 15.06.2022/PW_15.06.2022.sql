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

INSERT Sponsors VALUES
('Umbrella Corporation'),
('DBP Corporation'),
('DBM Corporation')

CREATE TABLE Donations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Amount MONEY CHECK(Amount > 0) NOT NULL,
Date DATE DEFAULT GETDATE() CHECK(Date < GETDATE() OR DATE = GETDATE()),
DepartmentId INT NOT NULL REFERENCES Departments(Id),
SponsorId INT NOT NULL REFERENCES Sponsors(Id),
)

INSERT Donations VALUES 
(1000, '2022-03-05', (SELECT Id FROM Departments WHERE Name = 'Приёмный покой'), (SELECT Id FROM Sponsors WHERE Name = 'Umbrella Corporation')),
(1050, DEFAULT, (SELECT Id FROM Departments WHERE Name = 'Травмотология'), (SELECT Id FROM Sponsors WHERE Name = 'DBP Corporation')),
(1000, '2022-07-01', (SELECT Id FROM Departments WHERE Name = 'Хурургическое'), (SELECT Id FROM Sponsors WHERE Name = 'DBM Corporation'))

CREATE TABLE Vacations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EndDate DATE NOT NULL,
StartDate DATE NOT NULL,
DoctorId INT NOT NULL REFERENCES Doctors(Id),
CHECK(EndDate > StartDate)
)

ALTER TABLE Examinations
ADD DepartmentID INT REFERENCES Departments(Id)
ALTER TABLE Examinations
ADD DoctorID INT REFERENCES Doctors(Id)

ALTER TABLE Wards
ADD DepartmentID INT REFERENCES Departments(Id)

ALTER TABLE Departments
ADD DoctorID INT REFERENCES Doctors(Id)

ALTER TABLE Diseases
ADD WardID INT REFERENCES Wards(Id)

INSERT Specializations VALUES
('Травматолог'),
('Терапевт'),
('Хирург')

ALTER TABLE Specializations
ADD DiseasID INT REFERENCES Diseases(Id)

ALTER TABLE Examinations
ADD DiseasID INT REFERENCES Diseases(Id)

INSERT DoctorsSpecializations VALUES
(
(SELECT Id FROM Doctors WHERE Name = 'Василий Павлович'),
(SELECT Id FROM Specializations WHERE Name = 'Травматолог')
),
(
(SELECT Id FROM Doctors WHERE Name = 'Петр Васильевич'),
(SELECT Id FROM Specializations WHERE Name = 'Терапевт')
),
(
(SELECT Id FROM Doctors WHERE Name = 'Анатолий Анатольевич'),
(SELECT Id FROM Specializations WHERE Name = 'Хирург')
)

INSERT Vacations VALUES
('2022-07-08', '2022-07-03', (SELECT Id FROM Doctors WHERE Name = 'Василий Павлович')),
('2022-09-10', '2022-08-15', (SELECT Id FROM Doctors WHERE Name = 'Петр Васильевич')),
('2022-11-02', '2022-10-03', (SELECT Id FROM Doctors WHERE Name = 'Анатолий Анатольевич'))

--1. Вывести полные имена врачей и их специализации.
-- Подробнее https://metanit.com/sql/sqlserver/7.1.php
SELECT Doctors.Name, Specializations.Name
FROM DoctorsSpecializations, Doctors, Specializations
WHERE DoctorsSpecializations.Id = Doctors.Id AND DoctorsSpecializations.Id = Specializations.Id

--2. Вывести фамилии и зарплаты (сумма ставки и надбавки) врачей, которые не находятся в отпуске.
SELECT Doctors.Name, Doctors.Salary
FROM Doctors, Vacations
WHERE Vacations.DoctorId = Doctors.Id AND GETDATE() NOT BETWEEN Vacations.StartDate AND Vacations.EndDate

--3. Вывести названия палат, которые находятся в отделении “Приёмный покой”.
SELECT Wards.Name
FROM Wards, Departments
WHERE Wards.DepartmentID = Departments.Id and Departments.Name = 'Приёмный покой'

--4. Вывести названия отделений без повторений, которые спонсируются компанией “Umbrella Corporation”.
SELECT Departments.Name AS 'Название отделения'
FROM Departments, Donations, Sponsors
WHERE Departments.Id = Donations.DepartmentId and Sponsors.Name = 'Umbrella Corporation' AND Donations.SponsorId = Sponsors.Id

--5. Вывести все пожертвования за последний месяц в виде: отделение, спонсор, сумма пожертвования, дата пожертвования.
SELECT Departments.Name AS Отделение, Sponsors.Name AS Спонсор, Donations.Amount AS 'Сумма пожертвования', Donations.Date AS 'Дата пожертвования'
FROM Departments, Sponsors, Donations
WHERE Departments.ID = Donations.DepartmentId AND Donations.SponsorId = Sponsors.Id AND Donations.Date > '2022-07-07'

--6. Вывести фамилии врачей с указанием отделений, в которых они проводят обследования. Необходимо учитывать обследования, проводимые только в будние дни.
SELECT Doctors.Name, Departments.Name, Examinations.Name
FROM Doctors, Departments, Examinations
WHERE Departments.Id = Examinations.DepartmentID AND Doctors.Id = Examinations.DoctorID

--7. Вывести названия палат и корпуса отделений, в которых проводит обследования врач “Василий Павлович”
SELECT Wards.Name, Departments.Name, Doctors.Name
FROM Doctors, Departments, Wards, Examinations
WHERE Wards.DepartmentID = Departments.Id and Doctors.Id = Examinations.DoctorID AND Doctors.Name = 'Василий Павлович' AND Departments.Id = Examinations.DepartmentID

--8. Вывести названия отделений, которые получали пожертвование в размере больше 1001, с указанием их врачей
SELECT Departments.Name, Doctors.Name, Donations.Amount
FROM Departments, Donations, Doctors
WHERE Departments.DoctorID = Doctors.Id and Donations.DepartmentId = Departments.Id AND Donations.Amount > 1001

--9. Вывести названия отделений, в которых есть врачи, получающие больше 20000.
SELECT Departments.Name AS 'Название департамента', Doctors.Name AS Имя, Doctors.Salary AS Salary
FROM Departments, Doctors
WHERE Departments.DoctorID = Doctors.Id and Doctors.Salary > 20000

--10. Вывести названия специализаций, которые используются для лечения заболеваний со степенью тяжести выше 2.
SELECT Specializations.Name, Diseases.Name
FROM Specializations, Diseases
WHERE Specializations.Id = Diseases.Id AND Diseases.Severity > 2

--11. Вывести названия отделений и заболеваний, обследования по которым они проводили за последние полгода.
SELECT Departments.Name, Diseases.Name, Examinations.StartTime, Examinations.EndTime
FROM Departments, Diseases, Examinations
WHERE Examinations.DoctorID = Departments.DoctorID AND Examinations.DepartmentID = Departments.Id AND Diseases.Id = Examinations.DiseasID

--12. Вывести названия отделений и палат, в которых проводились обследования заболеваний со степенью тяжести 1
SELECT Departments.Name, Wards.Name, Examinations.Name
FROM Departments, Wards, Examinations, Diseases
WHERE Examinations.DepartmentID = Departments.Id AND Wards.DepartmentID = Departments.Id AND Examinations.DepartmentID = Departments.Id AND
Diseases.WardID = Wards.Id AND Diseases.Severity = 1
