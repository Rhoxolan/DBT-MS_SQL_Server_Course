-- Создаём БД Hospital
CREATE DATABASE Hospital

--Устанавливаем БД текущей
USE Hospital

--Создаём таблицу Обследования (Examinations)
CREATE TABLE Examinations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DayOfWeek INT CHECK(DayOfWeek > 0 AND DayOfWeek < 8) NOT NULL,
StartTime TIME CHECK(StartTime > '07:59:00' AND StartTime < '17:30:00') NOT NULL,
EndTime TIME NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL,
CHECK(EndTime > StartTime)
)

--Создаём таблицу Отделения (Departments)
CREATE TABLE Departments
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Building INT CHECK (Building >= 0 AND Building < 16) NOT NULL,
Financing MONEY CHECK(Financing > 0) DEFAULT 0 NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL,
)

--Создаём таблицу Заболевания (Diseases)
CREATE TABLE Diseases
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL,
Severity INT CHECK (Severity > 0) DEFAULT 1 NOT NULL
)

--Создаём таблицу Врачи (Doctors)
CREATE TABLE Doctors
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(max) CHECK(Name != '') NOT NULL,
Phone CHAR(10) NOT NULL,
Salary MONEY CHECK(Salary > 0) NOT NULL
)

--Тестируем таблицу!

--Добавляем 3 отделения
INSERT Departments VALUES
(1, 1000, 'Приёмный покой'),
(2, 1000, 'Травмотология'),
(5, 1000, 'Хурургическое')

--Добавляем 3 врача
INSERT Doctors VALUES
('Василий Павлович', '093XXXXXXX', 25000),
('Петр Васильевич', '073XXXXXXX', 23000),
('Анатолий Анатольевич', '068XXXXXXX', 17000),
('Петя', '050XXXXXXX', 5000)

--Добавляем 2 заболевания
INSERT Diseases VALUES
('Перелом', 3),
('Вывих', 2)

--Намеренно создаём ошибочный запрос - пустое поле
INSERT Diseases VALUES
('', 1)

--"Исправляем ошибку"
INSERT Diseases VALUES
('Ушиб', 1)

--Добавляем обследование
INSERT Examinations VALUES
(3, '08:30:00', '09:00:00', 'Снимок перелома')

--Намеренно создаём ошибочные запросы - Время начала меньше разрешенного и время окончания меньше времени начала
INSERT Examinations VALUES
(3, '06:25:00', '09:00:00', 'Снимок вывиха')
INSERT Examinations VALUES
(3, '10:25:00', '09:00:00', 'Помазать ушиб кремом')

--Исправляем
INSERT Examinations VALUES
(3, '08:25:00', '09:00:00', 'Снимок вывиха'),
(3, '10:25:00', '10:30:00', 'Помазать ушиб кремом')