--БД создана https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/15.06.2022/HW_SQL_15.06.2022.sql

USE Academy

--Дополняем БД
ALTER TABLE Groups
ADD Students INT NOT NULL DEFAULT 0

ALTER TABLE GroupsLectures
ADD DayOfTheWeek INT NOT NULL CHECK (DayOfTheWeek > 0 AND DayOfTheWeek < 8) DEFAULT 1

--1. Вывести количество преподавателей кафедры “Департамент информационных технологий”.
SELECT COUNT(Lectures.Teacher) AS 'К-во преподавателей'
FROM Departments, Groups, GroupsLectures, Lectures
WHERE Departments.Name = 'Департамент информационных технологий' AND Groups.DepartmentID = Departments.Id AND
GroupsLectures.GroupId = Groups.Id AND GroupsLectures.LectureId = Lectures.Id

--2. Вывести количество лекций, которые читает преподаватель “Иван Иванов”.
SELECT Teachers.Name AS Имя, Teachers.Surname AS Фамилия, COUNT(Lectures.Teacher) AS 'К-во лекций'
FROM Lectures, Teachers
WHERE Lectures.Teacher = Teachers.Id AND Teachers.Name = 'Иван' AND Teachers.Surname = 'Иванов'
GROUP BY Teachers.Name, Teachers.Surname

--3. Вывести количество занятий, проводимых в аудитории “3ar”.
SELECT COUNT(Lectures.Id) AS 'К-во занятий'
FROM Lectures
WHERE Lectures.LectureRoom = '3ar'

--4. Вывести названия аудиторий и количество лекций, проводимых в них.
SELECT Lectures.LectureRoom AS 'Аудитория', COUNT(Lectures.Id) AS 'К-во лекций'
FROM Lectures
GROUP BY Lectures.LectureRoom

--5. Вывести количество студентов, посещающих лекции преподавателя “Иван Иванов”.
SELECT Teachers.Name AS Имя, Teachers.Surname AS Фамилия, SUM(Groups.Students) AS 'К-во студентов'
FROM Groups, GroupsLectures, Lectures, Teachers
WHERE Lectures.Teacher = Teachers.Id AND Teachers.Name = 'Иван' AND Teachers.Surname = 'Иванов' AND
GroupsLectures.LectureId = Lectures.Id AND GroupsLectures.GroupId = Groups.Id
GROUP BY Teachers.Name, Teachers.Surname

SELECT Teachers.Name AS Имя, Teachers.Surname AS Фамилия, COUNT(Groups.Id) AS 'К-во групп'
FROM Groups, GroupsLectures, Lectures, Teachers
WHERE Lectures.Teacher = Teachers.Id AND Teachers.Name = 'Иван' AND Teachers.Surname = 'Иванов' AND
GroupsLectures.LectureId = Lectures.Id AND GroupsLectures.GroupId = Groups.Id
GROUP BY Teachers.Name, Teachers.Surname

--6. Вывести среднюю ставку преподавателей факультета “Факультет АСУ ТП”.
SELECT AVG(Teachers.Salary) AS 'Средняя ставка преподавателей'
FROM Teachers, Lectures, GroupsLectures, Groups, Departments, Faculties
WHERE Faculties.Name = 'Факультет АСУ ТП' AND Teachers.Id = Lectures.Teacher AND GroupsLectures.GroupId = Groups.Id AND
GroupsLectures.LectureId = Lectures.Id AND Groups.DepartmentID = Departments.Id AND Departments.FacultyId = Faculties.Id

--7. Вывести минимальное и максимальное количество студентов среди всех групп.
SELECT MIN(Students) AS 'Мин', MAX(Students) AS 'Макс'
FROM Groups

--8. Вывести средний фонд финансирования кафедр
SELECT AVG(Financing)
FROM Departments

--9. Вывести полные имена преподавателей и количество читаемых ими дисциплин.
SELECT Teachers.Name, Teachers.Surname, COUNT(Lectures.SubjectId) AS 'Количество читаемых дисциплин'
FROM Teachers, Lectures
WHERE Lectures.Teacher = Teachers.Id
GROUP BY Teachers.Name, Teachers.Surname

--10. Вывести количество лекций в каждый день недели.
SELECT DayOfTheWeek AS 'День', COUNT(Id)
FROM GroupsLectures
GROUP BY DayOfTheWeek

--11. Вывести номера аудиторий и количество кафедр, чьи лекции в них читаются.
SELECT Lectures.LectureRoom as 'Аудитория', COUNT(Groups.DepartmentID) AS 'Количество кафедр'
FROM Groups, GroupsLectures, Lectures
WHERE GroupsLectures.GroupId = Groups.Id AND GroupsLectures.LectureId = Lectures.Id
GROUP BY Lectures.LectureRoom
