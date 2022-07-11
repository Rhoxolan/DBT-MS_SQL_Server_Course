--БД "Hospital" https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/15.06.2022/PW_15.06.2022.sql

USE Hospital

--Дополняем БД

ALTER TABLE Wards
ADD Places INT CHECK(Places > 0) DEFAULT 10 NOT NULL

ALTER TABLE Doctors
ADD Premium MONEY CHECK (Premium > -1) DEFAULT 0 NOT NULL

CREATE TABLE DoctorsExaminations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EndTime TIME NOT NULL,
StartTime TIME CHECK (StartTime > '08:00:00' AND StartTime < '18:00:00'),
DoctorId INT NOT NULL REFERENCES Doctors(Id),
ExaminationId INT NOT NULL REFERENCES Examinations(Id),
WardId INT NOT NULL REFERENCES Wards(Id)
)

INSERT DoctorsExaminations VALUES
(
'14:00:00', '11:00:00',
(SELECT Id FROM Doctors WHERE Name = 'Василий Павлович'),
(SELECT Id FROM Examinations WHERE Name = 'Снимок перелома'),
(SELECT Id FROM Wards WHERE Name = 'Палата 3')
),
(
'12:00:00', '09:30:00',
(SELECT Id FROM Doctors WHERE Name = 'Петр Васильевич'),
(SELECT Id FROM Examinations WHERE Name = 'Снимок вывиха'),
(SELECT Id FROM Wards WHERE Name = 'Палата 1')
),
(
'17:00:00', '13:30:00',
(SELECT Id FROM Doctors WHERE Name = 'Анатолий Анатольевич'),
(SELECT Id FROM Examinations WHERE Name = 'Помазать ушиб кремом'),
(SELECT Id FROM Wards WHERE Name = 'Палата 7')
)

--1. Вывести количество палат, вместимость которых больше 10.
SELECT COUNT(Places) AS 'Количество палат'
FROM Wards
WHERE Places > 10

--2. Вывести названия корпусов и количество палат в каждом из них.
SELECT Departments.Building AS 'Корпус', COUNT(Wards.Places) AS 'Количество палат'
FROM Departments, Wards
WHERE Departments.Id = Wards.DepartmentID
GROUP BY Departments.Building

--3. Вывести названия отделений и количество палат в каждом из них.
SELECT Departments.Name AS 'Отделение', COUNT(Wards.Places) AS 'Количество палат'
FROM Departments, Wards
WHERE Departments.Id = Wards.DepartmentID
GROUP BY Departments.Name

--4. Вывести названия отделений и суммарную надбавку врачей в каждом из них.
SELECT Departments.Name AS Отделение, SUM(Doctors.Premium) AS 'Сумма премий' 
FROM Departments, Wards, DoctorsExaminations, Doctors
WHERE Wards.DepartmentID = Departments.Id AND DoctorsExaminations.DoctorId = Doctors.Id AND DoctorsExaminations.WardId = Wards.Id
GROUP BY Departments.Name
