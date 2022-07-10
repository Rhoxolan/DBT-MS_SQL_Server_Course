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
