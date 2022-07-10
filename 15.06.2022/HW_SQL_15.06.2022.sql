--БД создана https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/14.06.2022/HomeWork_14_06_2022.sql

USE Academy

--Дополняем БД

CREATE TABLE Curators
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(max) CHECK(Name != '') NOT NULL,
Surname NVARCHAR(max) CHECK(Surname != '') NOT NULL
)

INSERT Curators Values
('Василий','Петров'),
('Василий','Федоров'),
('Андрей','Петренко')

ALTER TABLE Departments
ADD FacultyId INT REFERENCES Faculties(Id) DEFAULT 1

ALTER TABLE Faculties
ADD Financing MONEY CHECK(Financing > -1) DEFAULT 0 NOT NULL

ALTER TABLE Groups
ADD DepartmentID INT REFERENCES Departments(Id)

CREATE TABLE GroupsCurators
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
CuratorId INT NOT NULL REFERENCES Curators(Id),
GroupId INT NOT NULL REFERENCES Groups(Id),
)

INSERT GroupsCurators Values
(
(SELECT Id FROM Curators WHERE Name = 'Василий' AND Surname = 'Петров'),
(SELECT Id FROM Groups WHERE Name = 'Группа 15')
),
(
(SELECT Id FROM Curators WHERE Name = 'Василий' AND Surname = 'Федоров'),
(SELECT Id FROM Groups WHERE Name = 'Группа 17')
),
(
(SELECT Id FROM Curators WHERE Name = 'Андрей' AND Surname = 'Петренко'),
(SELECT Id FROM Groups WHERE Name = 'Группа 13')
)

CREATE TABLE GroupsLectures
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
GroupId INT NOT NULL REFERENCES Groups(Id),
LectureId INT NOT NULL REFERENCES Lectures(Id),
)

INSERT GroupsLectures VALUES
(
(SELECT Id FROM Groups WHERE Name = 'Группа 15'),
(SELECT Id FROM Lectures WHERE LectureRoom = '1')
),
(
(SELECT Id FROM Groups WHERE Name = 'Группа 17'),
(SELECT Id FROM Lectures WHERE LectureRoom = '2')
),
(
(SELECT Id FROM Groups WHERE Name = 'Группа 13'),
(SELECT Id FROM Lectures WHERE LectureRoom = '3')
)

CREATE TABLE Lectures
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
LectureRoom NVARCHAR(max) CHECK (LectureRoom != '') NOT NULL,
SubjectId INT NOT NULL REFERENCES Subjects(Id),
Teacher INT NOT NULL REFERENCES Teachers(Id)
)

INSERT Lectures VALUES
('1',
(SELECT Id FROM Subjects WHERE Name = 'Низкоуровневое программирование'),
(SELECT Id FROM Teachers WHERE Name = 'Петр' AND Surname = 'Петров' AND IsProfessor = 1)
),
('2',
(SELECT Id FROM Subjects WHERE Name = 'Электротехника'),
(SELECT Id FROM Teachers WHERE Name = 'Иван' AND Surname = 'Иванов')
),
('3',
(SELECT Id FROM Subjects WHERE Name = 'Основы автоматизации'),
(SELECT Id FROM Teachers WHERE Name = 'Василий' AND Surname = 'Васильев' AND IsProfessor = 1)
)

CREATE TABLE Subjects
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(max) CHECK(Name != '') NOT NULL
)

INSERT Subjects Values
('Низкоуровневое программирование'),
('Электротехника'),
('Основы автоматизации')

--1. Вывести все возможные пары строк преподавателей и групп.
SELECT Teachers.Name, Teachers.Surname, Groups.Name
FROM Teachers, Groups

--2. Вывести названия факультетов, фонд финансирования кафедр которых превышает фонд финансирования факультета
SELECT Faculties.Name AS Факультет, Faculties.Financing AS 'Финансирование факультета',
Departments.Name AS Департамент, Departments.Financing AS 'Финансирование департамента'
FROM Faculties, Departments
WHERE Departments.FacultyId = Faculties.Id AND Faculties.Financing > Departments.Financing

--3. Вывести фамилии кураторов групп и названия групп, которые они курируют.
SELECT Curators.Surname, Groups.Name
FROM Groups, GroupsCurators, Curators
WHERE GroupsCurators.CuratorId = Curators.Id AND GroupsCurators.GroupId = Groups.Id

--4. Вывести имена и фамилии преподавателей, которые читают лекции у группы “Группа 15”.
SELECT Teachers.Name AS 'Имя преподавателя', Teachers.Surname AS 'Фамилия преподавателя', Groups.Name AS 'Группа'
FROM Teachers, Groups, GroupsLectures, Lectures
WHERE GroupsLectures.GroupId = Groups.Id AND GroupsLectures.LectureId = Lectures.Id AND Lectures.Teacher = Teachers.Id AND
Groups.Name = 'Группа 15'

--5. Вывести фамилии преподавателей и названия факультетов на которых они читают лекции.
SELECT Teachers.Name AS 'Имя преподавателя', Teachers.Surname AS 'Фамилия преподавателя', Faculties.Name AS 'Факультет'
FROM Teachers, Lectures, GroupsLectures, Groups, Departments, Faculties
WHERE Teachers.Id = Lectures.Teacher AND GroupsLectures.LectureId = Lectures.Id AND GroupsLectures.GroupId = Groups.Id AND
Groups.DepartmentID = Departments.Id AND Departments.FacultyId = Faculties.Id

--6. Вывести названия кафедр и названия групп, которые к ним относятся.
SELECT Departments.Name AS 'Департамент', Groups.Name AS 'Группа'
FROM Departments, Groups
WHERE Groups.DepartmentID = Departments.Id

--7. Вывести названия дисциплин, которые читает преподаватель “Василий Васильев”
SELECT Subjects.Name AS Дисциплина, Teachers.Name AS 'Имя преподавателя', Teachers.Surname AS 'Фамилия преподавателя'
FROM Teachers, Lectures, Subjects
WHERE Lectures.Teacher = Teachers.Id AND Lectures.SubjectId = Subjects.Id AND Teachers.Name = 'Василий' AND Teachers.Surname = 'Васильев'

--8. Вывести названия кафедр, на которых читается дисциплина “Основы автоматизации”.
SELECT Departments.Name AS Департамент, Subjects.Name AS Дисциплина
FROM Departments, Groups, GroupsLectures, Lectures, Subjects
WHERE Departments.Id = Groups.DepartmentID AND GroupsLectures.GroupId = Groups.Id AND
GroupsLectures.LectureId = Lectures.Id AND Lectures.SubjectId = Subjects.Id AND Subjects.Name = 'Основы автоматизации'

--9. Вывести названия групп, которые относятся к факультету “Факультет АСУ ТП”.
SELECT Groups.Name AS Группа, Faculties.Name AS Факультет
FROM Groups, Departments, Faculties
WHERE Groups.DepartmentID = Departments.Id AND Departments.FacultyId = Faculties.Id AND Faculties.Name = 'Факультет АСУ ТП'

--10. Вывести названия групп 5-го курса, а также название факультетов, к которым они относятся.
SELECT Groups.Name AS Група, Groups.Year AS Год, Faculties.Name AS Факультет
FROM Groups, Departments, Faculties
WHERE Groups.DepartmentID = Departments.Id AND Departments.FacultyId = Faculties.Id AND Groups.Year = 5

--11. Вывести полные имена преподавателей и лекции, которые они читают (названия дисциплин и групп),
-- причем отобрать только те лекции, которые читаются в аудитории “1l”.
SELECT Teachers.Name AS 'Имя преподавателя', Teachers.Surname AS 'Фамилия преподавателя', Subjects.Name AS 'Лекция по предмету',
Lectures.LectureRoom AS Аудитория
FROM Teachers, Lectures, Subjects
WHERE Lectures.Teacher = Teachers.Id AND Lectures.SubjectId = Subjects.Id AND Lectures.LectureRoom = '1l'
