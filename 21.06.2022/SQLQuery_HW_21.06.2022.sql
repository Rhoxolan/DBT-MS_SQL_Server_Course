--БД "Academy" https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/20.06.2022/SQLQueryHW_2022.06.20.sql

USE Academy

--Дополняем БД

CREATE TABLE GroupsStudents
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
GroupId INT NOT NULL REFERENCES Groups(Id),
StudentId INT NOT NULL REFERENCES Students(Id),
)

CREATE TABLE Students
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') NOT NULL,
Surname NVARCHAR(100) CHECK(Surname != '') NOT NULL,
Rating INT CHECK (Rating > -1) DEFAULT 0 NOT NULL
)

INSERT Students VALUES
('Вася', 'Васильев', 100),
('Нинита', 'Никитов', 75),
('Иммануил', 'Иммануиленко', 100)

INSERT GroupsStudents VALUES
(
(SELECT Id FROM Groups WHERE Groups.Name = 'Группа 15'),
(SELECT Id FROM Students WHERE Students.Name = 'Вася' AND Students.Surname = 'Васильев')
),
(
(SELECT Id FROM Groups WHERE Groups.Name = 'Группа 17'),
(SELECT Id FROM Students WHERE Students.Name = 'Нинита' AND Students.Surname = 'Никитов')
),
(
(SELECT Id FROM Groups WHERE Groups.Name = 'Группа 13'),
(SELECT Id FROM Students WHERE Students.Name = 'Иммануил' AND Students.Surname = 'Иммануиленко')
)

ALTER TABLE Departments
ADD Building  INT CHECK(Building > -1) NOT NULL DEFAULT 0

ALTER TABLE Lectures
ADD DateOfLecture DATE NOT NULL DEFAULT '2022-09-01'

ALTER TABLE Groups
ADD AvgRating INT DEFAULT 0 NOT NULL

--1. Вывести номера корпусов, если суммарный фонд финансирования расположенных в них кафедр превышает выше средней по кафедрам.
SELECT Departments.Building, Departments.Financing
FROM Departments
WHERE Departments.Financing > (SELECT AVG(Departments.Financing) FROM Departments)

--2. Вывести названия групп 5-го курса кафедры “Департамент информационных технологий”, которые имеют пары в первую неделю.
SELECT DISTINCT Groups.Name
FROM Groups, Departments, GroupsLectures
WHERE Groups.DepartmentID = Departments.Id AND Departments.Name = 'Департамент информационных технологий' AND
GroupsLectures.GroupId = Groups.Id AND GroupsLectures.LectureId = ANY(SELECT Lectures.Id FROM Lectures WHERE Lectures.DateOfLecture < '2022-09-07')

--3. Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) больше, чем рейтинг группы “Группа 15”
SELECT Groups.Name, Groups.AvgRating
FROM Groups
WHERE Groups.AvgRating > (SELECT Groups.AvgRating FROM Groups WHERE Groups.Name = 'Группа 15')

--4. Вывести фамилии и имена преподавателей, ставка которых выше средней ставки профессоров.
