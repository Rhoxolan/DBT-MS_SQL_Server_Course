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

--5. Вывести названия отделений, в которых проводят обследования 5 и более врачей.
SELECT Departments.Name AS Отделение, COUNT(DoctorsExaminations.DoctorId) AS 'Принимающие врачи'
FROM Departments, Wards, DoctorsExaminations, Doctors
WHERE DoctorsExaminations.DoctorId = Doctors.Id AND DoctorsExaminations.WardId = Wards.Id AND Wards.DepartmentID = Departments.Id
GROUP BY Departments.Name
HAVING COUNT(DoctorsExaminations.DoctorId) > 5

--6. Вывести количество врачей и их суммарную зарплату (сумма ставки и надбавки).
--Версия 1 - через таблицу врачей
SELECT COUNT(Doctors.Id) AS 'Количество врачей', SUM(Doctors.Salary) + SUM(Doctors.Premium) AS 'Зарплата'
FROM Doctors
--Версия 2 - через таблицу врачей, проводящих обследования
SELECT COUNT(DoctorsExaminations.DoctorId) AS 'Количество врачей', SUM(Doctors.Salary) + SUM(Doctors.Premium) AS 'Зарплата'
FROM Doctors, DoctorsExaminations
WHERE DoctorsExaminations.DoctorId = Doctors.Id

--7. Вывести среднюю зарплату (сумма ставки и надбавки) врачей.
SELECT AVG(Doctors.Salary + Doctors.Premium) AS 'Среднее значение зарплаты врачей'
FROM Doctors

--8. Вывести названия палат с минимальной вместительностью.
SELECT Name AS 'Палата с минимальной вместительностью', Places AS 'Мест'
FROM Wards
WHERE Places=(SELECT MIN(Places) FROM Wards)

--9. Вывести в каких из корпусов 1, 2, и 5, суммарное количество мест в палатах превышает 30.
--При этом учитывать только палаты с количеством мест больше 10.
SELECT Departments.Building AS 'Корпус', SUM(Wards.Places) AS 'Количество мест в палатах'
FROM Departments, Wards
WHERE Departments.Id = Wards.DepartmentID AND Wards.Places > 10
GROUP BY Departments.Building
HAVING SUM(Wards.Places) > 30
