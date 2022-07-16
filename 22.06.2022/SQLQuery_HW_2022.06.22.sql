--БД "Academy" https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/21.06.2022/SQLQuery_HW_21.06.2022.sql

USE Academy

--Дополняем БД

ALTER TABLE Faculties
ADD Building INT CHECK (Building > 0 AND Building < 6) NOT NULL DEFAULT 1

CREATE TABLE DEAN
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
TeacherId INT NOT NULL REFERENCES Teachers(Id)
)

CREATE TABLE Heads
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
TeacherId INT NOT NULL REFERENCES Teachers(Id)
)

INSERT DEAN VALUES
((SELECT Id FROM Teachers WHERE Name = 'Николай' AND Surname = 'Николаев')),
((SELECT Id FROM Teachers WHERE Name = 'Петр' AND Surname = 'Петров')),
((SELECT Id FROM Teachers WHERE Name = 'Анатолий' AND Surname = 'Анатольев'))

INSERT Heads VALUES
((SELECT Id FROM Teachers WHERE Name = 'Николай' AND Surname = 'Николаев')),
((SELECT Id FROM Teachers WHERE Name = 'Петр' AND Surname = 'Петров')),
((SELECT Id FROM Teachers WHERE Name = 'Анатолий' AND Surname = 'Анатольев'))

ALTER TABLE Departments
ADD HeadID INT NOT NULL REFERENCES Heads(Id) DEFAULT 1

CREATE TABLE Assistants
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
TeacherId INT NOT NULL REFERENCES Teachers(Id)
)

INSERT Assistants VALUES
((SELECT Id FROM Teachers WHERE Name = 'Николай' AND Surname = 'Николаев')),
((SELECT Id FROM Teachers WHERE Name = 'Петр' AND Surname = 'Петров')),
((SELECT Id FROM Teachers WHERE Name = 'Анатолий' AND Surname = 'Анатольев'))

CREATE TABLE Schedules
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Class INT NOT NULL CHECK(Class > 0 AND Class < 9),
DayOfWeek INT NOT NULL CHECK(DayOfWeek > 0 AND DayOfWeek < 8),
Week INT NOT NULL CHECK(Week > 0 AND Week < 53),
LectureId INT NOT NULL REFERENCES Lectures(Id),
LectureRoomID INT NOT NULL REFERENCES LectureRooms(Id)
)

INSERT Schedules Values
(1, 2, 3, (SELECT Id FROM Lectures WHERE DateOfLecture = '2022-09-02'), (SELECT Id FROM LectureRooms WHERE Name = '1l')),
(2, 3, 4, (SELECT Id FROM Lectures WHERE DateOfLecture = '2022-09-03'), (SELECT Id FROM LectureRooms WHERE Name = '2l')),
(3, 4, 5, (SELECT Id FROM Lectures WHERE DateOfLecture = '2022-09-04'), (SELECT Id FROM LectureRooms WHERE Name = '3a'))

CREATE TABLE LectureRooms
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Building INT CHECK (Building > 0 AND Building < 6) NOT NULL,
Name NVARCHAR(10) CHECK(Name != '') UNIQUE NOT NULL
)

INSERT LectureRooms VALUES
(1, '1l'),
(2, '2l'),
(3, '3a')

ALTER TABLE Curators
ADD TeacherId INT NOT NULL REFERENCES Teachers(Id) DEFAULT 1

--1. Вывести названия аудиторий, в которых читает лекции преподаватель “Сергей Сергеев”.
-- "INNER JOIN"
SELECT LectureRooms.Name
FROM LectureRooms
JOIN Schedules ON Schedules.LectureRoomID = LectureRooms.Id
JOIN Lectures ON Schedules.LectureId = Lectures.Id
JOIN Teachers ON Lectures.Teacher = Teachers.Id AND Teachers.Name = 'Сергей' AND Teachers.Surname = 'Сергеев'

--2. Вывести фамилии ассистентов, читающих лекции в группе “Группа 15”.
-- "INNER JOIN"
SELECT Teachers.Surname
FROM Teachers
JOIN Assistants ON Assistants.TeacherId = Teachers.Id
JOIN Lectures ON Lectures.Teacher = Teachers.Id
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN Groups ON GroupsLectures.GroupId = Groups.Id AND Groups.Name = 'Группа 15'

--3. Вывести дисциплины, которые читает преподаватель “Сергей Сергеев” для групп 5-го курса.
-- "INNER JOIN"
SELECT Subjects.Name
FROM Subjects
JOIN Lectures ON Lectures.SubjectId = Subjects.Id
JOIN Teachers ON Lectures.Teacher = Teachers.Id AND Teachers.Name = 'Сергей' AND Teachers.Surname = 'Сергеев'
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN Groups ON GroupsLectures.GroupId = Groups.Id AND Groups.Year = 5

--4. Вывести фамилии преподавателей, которые не читают лекции по понедельникам.
-- "INNER JOIN"
SELECT Teachers.Surname
FROM Teachers
JOIN Lectures ON Lectures.Teacher = Teachers.Id
JOIN Schedules ON Schedules.LectureId = Lectures.Id AND Schedules.DayOfWeek != 1

--5. Вывести названия аудиторий, с указанием их корпусов, в которых нет лекций в среду второй недели на третьей паре.
-- "NOT EXISTS"
SELECT LectureRooms.Name, LectureRooms.Building
FROM LectureRooms
WHERE NOT EXISTS
	(SELECT * FROM Schedules
	WHERE Schedules.LectureRoomID = LectureRooms.Id AND
	Schedules.DayOfWeek = 3 AND
	Schedules.Week = 2 AND
	Schedules.Class = 3)

--6. Вывести полные имена преподавателей факультета “Департамент информационных технологий”, которые не курируют группы кафедры “Факультет АСУ ТП”.
-- "NOT EXISTS"
SELECT Teachers.Name, Teachers.Surname
FROM Teachers
WHERE NOT EXISTS
	(SELECT * FROM Heads
	JOIN Departments ON Departments.HeadID = Heads.Id
	JOIN Faculties ON Departments.FacultyId = Faculties.Id
	WHERE Heads.TeacherId = Teachers.Id AND
	Departments.Name = 'Департамент информационных технологий' AND
	Faculties.Name = 'Факультет АСУ ТП')

--7. Вывести список номеров всех корпусов, которые имеются в таблицах факультетов, кафедр и аудиторий.
-- "UNION"
-- Вариант 1
SELECT Building
FROM Departments
UNION SELECT Building FROM Faculties
UNION SELECT Building FROM LectureRooms
-- Вариант 2
SELECT Building
FROM Departments
UNION ALL SELECT Building FROM Faculties
UNION ALL SELECT Building FROM LectureRooms

--8. Вывести полные имена преподавателей в следующем порядке: деканы факультетов, заведующие кафедрами, преподаватели, кураторы, ассистенты.
-- "UNION", "LEFT JOIN"
SELECT Teachers.Name, Teachers.Surname, 'Деканы' AS Kind
FROM DEAN LEFT JOIN Teachers ON DEAN.TeacherId = Teachers.Id
UNION ALL SELECT Teachers.Name, Teachers.Surname, 'Главы' AS Kind
FROM Heads LEFT JOIN Teachers ON Heads.TeacherId = Teachers.Id
UNION ALL SELECT Teachers.Name, Teachers.Surname, 'Учителя' AS Kind
FROM Lectures LEFT JOIN Teachers ON Lectures.Teacher = Teachers.Id
UNION ALL SELECT Teachers.Name, Teachers.Surname, 'Кураторы' AS Kind
FROM Curators LEFT JOIN Teachers ON Curators.TeacherId = Teachers.Id
UNION ALL SELECT Teachers.Name, Teachers.Surname, 'Ассистенты' AS Kind
FROM Assistants LEFT JOIN Teachers ON Assistants.TeacherId = Teachers.Id

--9. Вывести дни недели (без повторений), в которые имеются занятия в аудиториях “1l” и “2l” корпуса 5.
-- "INNER JOIN"
SELECT DISTINCT Schedules.DayOfWeek
FROM Schedules
JOIN LectureRooms ON LectureRooms.Building = 5 AND LectureRooms.Name = '1l' OR LectureRooms.Name = '2l'
