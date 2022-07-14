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
SELECT Teachers.Name AS 'Имя преподавателя', Teachers.Surname AS 'Фамилия преподавателя', Teachers.Salary as 'Ставка'
FROM Teachers
WHERE Teachers.Salary > (SELECT AVG(Teachers.Salary) FROM Teachers WHERE Teachers.IsProfessor = 1)

--5. Вывести названия групп, у которых больше одного куратора.
SELECT Groups.Name, COUNT(GroupsCurators.GroupId)
FROM Groups
JOIN GroupsCurators ON GroupsCurators.GroupId = Groups.Id
GROUP BY Groups.Name
HAVING COUNT(GroupsCurators.GroupId) > 1

--6. Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) меньше, чем минимальный рейтинг групп 5-го курса.
SELECT Groups.Name, Groups.AvgRating
FROM Groups
WHERE Groups.AvgRating <
	(SELECT MIN(Students.Rating)
	FROM Students, GroupsStudents, Groups
	WHERE GroupsStudents.GroupId = Groups.Id AND GroupsStudents.StudentId = Students.Id AND Groups.Year = 5)

--7. Вывести названия факультетов, суммарный фонд финансирования кафедр которых больше суммарного фонда финансирования
--кафедр факультета “Факультет АСУ ТП”.
SELECT Faculties.Name, SUM(Departments.Financing)
FROM Faculties
JOIN Departments ON Departments.FacultyId = Faculties.Id
GROUP BY Faculties.Name
HAVING SUM(Departments.Financing) >
	(SELECT Departments.Financing
	FROM Departments, Faculties
	WHERE Departments.FacultyId = Faculties.Id AND Faculties.Name = 'Факультет АСУ ТП')

--8. Вывести названия дисциплин и полные имена преподавателей, читающих наибольшее количество лекций по ним.
SELECT Subjects.Name AS 'Предмет', Teachers.Name AS 'Имя преподавателя', Teachers.Surname AS 'Фамилия преподавателя', COUNT(Subjects.Id)
FROM Subjects
JOIN Lectures ON Lectures.SubjectId = Subjects.Id
JOIN Teachers ON Lectures.Teacher = Teachers.Id
GROUP BY Subjects.Name, Teachers.Name, Teachers.Surname
ORDER BY COUNT(Subjects.Id) DESC

--9. Вывести название дисциплины, по которому читается меньше всего лекций.

--10. Вывести количество студентов и читаемых дисциплин на кафедре “Департамент информационных технологий”
