CREATE DATABASE Academy

USE Academy

CREATE TABLE Groups
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(10) CHECK(Name != '') UNIQUE NOT NULL,
Rating INT CHECK(Rating > -1 AND Rating < 6) NOT NULL,
Year INT CHECK(Year > 0 AND Year < 6) NOT NULL,
)

CREATE TABLE Departments
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Financing MONEY CHECK(Financing > -1) DEFAULT 0 NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL,
)


CREATE TABLE Faculties
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL,
)

CREATE TABLE Teachers
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
EmploymentDate DATE CHECK(EmploymentDate > '1990-01-01'),
Name NVARCHAR(max) CHECK(Name != '') NOT NULL,
Surname NVARCHAR(100) CHECK(Surname != '') NOT NULL,
Premium MONEY CHECK(Premium > -1) DEFAULT 0 NOT NULL,
Salary MONEY CHECK(Salary > 0) NOT NULL,
)

--Заполняем таблицы

INSERT Departments VALUES
(1000, 'Департамент информационных технологий')

--Добавляем данные в таблицу, явно указывая столбцы
INSERT Departments (Financing, Name)
VALUES (1000, 'Департамент технологий производства')

INSERT Faculties VALUES
('Факультет АСУ ТП')

--Намеренно ошибочный запрос - пустое поле
INSERT Faculties VALUES
('')

--Исправляем
INSERT Faculties VALUES
('Факултьтет электротехнии и КИПиА')

INSERT Teachers VALUES
('2009-07-25', 'Петр', 'Петров', 1000, 17000),
('2011-08-23', 'Иван', 'Иванов', 1000, 16000),
('2014-09-01', 'Василий', 'Васильев', 1000, 19000)

INSERT Groups VALUES
('Группа 15', 3, 5),
('Группа 17', 5, 3),
('Группа 13', 5, 3)

--Выборка данных

--Отображаем всё с тблицы департаментов
SELECT * FROM Departments

--Отображаем все группы, с указанием необходимых столбцов
SELECT Name, Rating, Year FROM Groups

--Отображаем все факультеты с добавлением текста
SELECT 'Название факультета: ' + Name FROM Faculties

--Отображаем всх учителей, меняя название столбцов и используя выражение для вывода информации
SELECT
Name AS Имя,
Surname AS Фамилия,
EmploymentDate AS 'Дата приёма на работу',
Salary + Premium AS 'Зарплата с премией'
FROM Teachers

--Выбираем уникалньые курсы групп через DISTINCT
SELECT DISTINCT Year FROM Groups

-- Выбранные данные из таблицы учителей помещаяем в нову таблицу зарплат через SELECT INTO
SELECT
Name AS Имя,
Surname AS Фамилия,
Salary + Premium AS 'Зарплата с премией'
INTO Salaries
FROM Teachers

SELECT * FROM Salaries