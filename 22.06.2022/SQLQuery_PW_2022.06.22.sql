--БД "Hospital" https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/21.06.2022/SQLQuery_PW_21.06.2022.sql

USE Hospital

--Дополняем БД

ALTER TABLE DoctorsExaminations
ADD DiseasID INT NOT NULL REFERENCES Diseases(Id) DEFAULT 1

CREATE TABLE Interns
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DoctorId INT NOT NULL REFERENCES Doctors(Id),
)

Insert Interns VALUES
((SELECT Id FROM Doctors WHERE Name = 'Николай Николаевич')),
((SELECT Id FROM Doctors WHERE Name = 'Василий Андреевич')),
((SELECT Id FROM Doctors WHERE Name = 'Петр Алексеевич'))

CREATE TABLE Professors
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DoctorId INT NOT NULL REFERENCES Doctors(Id),
)

Insert Professors VALUES
((SELECT Id FROM Doctors WHERE Name = 'Василий Павлович')),
((SELECT Id FROM Doctors WHERE Name = 'Петр Васильевич')),
((SELECT Id FROM Doctors WHERE Name = 'Анатолий Анатольевич'))

ALTER TABLE DoctorsExaminations
ADD DateExam DATE NOT NULL DEFAULT '2022-01-01'

--1. Вывести названия и вместимости палат, расположенных в 5-м корпусе, вместимостью 5 и более мест,
-- если в этом корпусе есть хотя бы одна палата вместимостью более 15 мест.
-- "EXISTS"
--Вариант 1
SELECT Wards.Name, Wards.Places
FROM Wards, Departments
WHERE Wards.DepartmentID = Departments.Id AND EXISTS (SELECT * FROM Wards WHERE Wards.DepartmentID = Departments.Id AND Wards.Places > 15) AND
Wards.Places > 5  AND Departments.Building = 5
--Вариант 2
SELECT Wards.Name, Wards.Places
FROM Wards
WHERE EXISTS (SELECT * FROM Departments WHERE Wards.DepartmentID = Departments.Id AND Wards.Places > 15 AND Departments.Building = 5) AND
Wards.Places > 5

--2. Вывести названия отделений в которых проводилось хотя бы одно обследование за последнюю неделю
-- "INNER JOIN"
SELECT Departments.Name, DoctorsExaminations.DateExam
FROM Departments
JOIN Wards ON Wards.DepartmentID = Departments.Id
JOIN DoctorsExaminations ON DoctorsExaminations.WardId = Wards.Id
WHERE DATEDIFF(day, DoctorsExaminations.DateExam, GETDATE()) < 7

--3. Вывести названия заболеваний, для которых не проводятся обследования.
-- "LEFT JOIN"
-- Выводим все строки, если обследования нет - DE.DiseasID NULL
SELECT Diseases.Name, DoctorsExaminations.DiseasID
FROM Diseases LEFT JOIN DoctorsExaminations ON DoctorsExaminations.DiseasID = Diseases.Id

--4. Вывести полные имена врачей, которые не проводят обследования.
-- "NOT EXISTS"
SELECT Doctors.Name
FROM Doctors
WHERE NOT EXISTS (SELECT * FROM DoctorsExaminations WHERE Doctors.Id = DoctorsExaminations.DoctorId)

--5. Вывести названия отделений, в которых не проводятся обследования.
-- "NOT EXISTS"
SELECT Departments.Name
FROM Departments
WHERE NOT EXISTS (SELECT * FROM DoctorsExaminations, Wards WHERE Wards.DepartmentID = Departments.Id AND DoctorsExaminations.WardId = Wards.Id)

--6. Вывести фамилии врачей, которые являются интернами
-- "INNER JOIN"
SELECT Doctors.Name
FROM Doctors
JOIN Interns ON Interns.DoctorId = Doctors.Id

--7. Вывести фамилии интернов, ставки которых больше, чем ставка хотя бы одного из врачей.
-- "INNER JOIN", "NOT EXISTS"
SELECT Doctors.Name
FROM Doctors
JOIN Interns ON Interns.DoctorId = Doctors.Id
WHERE Doctors.Salary > ANY (SELECT Doctors.Salary FROM Doctors WHERE NOT EXISTS (SELECT * FROM Interns WHERE Doctors.Id = Interns.DoctorId))

--8. Вывести названия палат, чья вместимость больше, чем вместимость каждой палаты, находящейся в 3-м корпусе.
-- "INNER JOIN"
SELECT Wards.Name, Wards.Places
FROM Wards
WHERE Wards.Places > ALL (SELECT Wards.Places FROM Wards JOIN Departments ON Wards.DepartmentID = Departments.Id AND Departments.Building = 3)

--9. Вывести фамилии врачей, проводящих обследования в отделениях “Травматология” и “Хирургическое”.
-- "INNER JOIN"
SELECT Doctors.Name, Departments.Name
FROM Doctors
JOIN DoctorsExaminations ON DoctorsExaminations.DoctorId = Doctors.Id
JOIN Wards ON Wards.Id = DoctorsExaminations.WardId
JOIN Departments ON Wards.DepartmentID = Departments.Id AND Departments.Name = 'Травматология' OR Departments.Name = 'Хирургическое'

--10. Вывести названия отделений, в которых работают интерны и профессоры
-- "INNER JOIN", "LEFT JOIN", "NOT EXISTS"
SELECT Departments.Name
FROM Departments
WHERE EXISTS
	(SELECT * FROM Professors
	JOIN Doctors ON Professors.DoctorId = Doctors.Id
	LEFT JOIN Interns ON Interns.DoctorId = Doctors.Id
	JOIN DoctorsExaminations ON DoctorsExaminations.DoctorId = Doctors.Id
	JOIN Wards ON Wards.Id = DoctorsExaminations.WardId
	WHERE Wards.DepartmentID = Departments.Id)
