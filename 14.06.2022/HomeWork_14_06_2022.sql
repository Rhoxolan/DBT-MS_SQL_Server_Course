USE Academy

--БД Создана https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/13.06.2022/HomeWork.sql

--Вносим необходимые изменения в таблицу
ALTER TABLE Faculties
ADD Dean NVARCHAR(max) CHECK(Dean != '') NULL --Примечание - для установки NOT NULL в данном случае требуется ввести дефолтное значение

ALTER TABLE Teachers
ADD IsAssistant BIT DEFAULT 0 NOT NULL

ALTER TABLE Teachers
ADD IsProfessor BIT DEFAULT 0 NOT NULL

ALTER TABLE Teachers
ADD Position NVARCHAR(max) CHECK(Position != '') DEFAULT 'Работник ВНЗ' NOT NULL

--1. Вывести таблицу кафедр, но расположить ее поля в обратном порядке.
SELECT * FROM Departments
ORDER BY Name DESC

--2. Вывести названия групп и их рейтинги, используя в качестве названий выводимых полей "Group Name" и "Group Rating" соответственно.
SELECT Name AS 'Group Name', Rating AS 'Group Rating' FROM Groups

--3. Вывести для преподавателей их фамилию, процент ставки по отношению к надбавке и процент ставки по отношению к зарплате (сумма ставки и надбавки).
SELECT Surname, Salary + Premium AS Зарплата FROM Teachers

--4. Вывести таблицу факультетов в виде одного поля в следующем формате: “The dean of faculty [faculty] is [dean].”.
SELECT 'The dean of faculty ' + Name + ' is ' + Dean AS 'Инфо о факультете' FROM Faculties

--5. Вывести фамилии преподавателей, которые являются профессорами и ставка которых превышает 1050.
SELECT Surname FROM Teachers
WHERE IsProfessor = 1 AND Salary > 1050

--6. Вывести названия кафедр, фонд финансирования которых меньше 11000 или больше 25000.
SELECT Name FROM Departments
WHERE Financing NOT BETWEEN 11000 AND 25000

--7. Вывести названия факультетов кроме факультета “Факултьтет электротехнии и КИПиА”.
SELECT Name FROM Faculties
WHERE Name != 'Факултьтет электротехнии и КИПиА'

--8. Вывести фамилии и должности преподавателей, которые не являются профессорами.
SELECT Surname, Position FROM Teachers
WHERE IsProfessor = 0

--9. Вывести фамилии, должности, ставки и надбавки ассистентов, у которых надбавка в диапазоне от 160 до 5550.
SELECT Surname, Position, Salary, Premium FROM Teachers
WHERE IsAssistant = 1 AND Premium BETWEEN 160 AND 5550

--10. Вывести фамилии и ставки ассистентов.
SELECT Surname, Salary FROM Teachers
WHERE IsAssistant = 1

--11. Вывести фамилии и должности преподавателей, которые были приняты на работу до 01.01.2010.
SELECT Surname, Position FROM Teachers
WHERE EmploymentDate < '2010-01-01'

--12. Вывести названия кафедр, которые в алфавитном порядке располагаются до кафедры “Департамент технологий производства”. Выводимое поле должно иметь название “Name of Department”.
SELECT Name FROM Departments
WHERE Name < 'Департамент технологий производства'
ORDER BY Name

--13. Вывести фамилии ассистентов, имеющих зарплату (сумма ставки и надбавки) не более 100000
SELECT Surname FROM Teachers
WHERE IsAssistant = 1 AND (Salary + Premium) <= 100000

--14. Вывести названия групп 5-го курса, имеющих рейтинг в диапазоне от 2 до 4.
SELECT Name FROM Groups
WHERE Year = 5 AND Rating BETWEEN 2 AND 4

--15. Вывести фамилии ассистентов со ставкой меньше 20000 или надбавкой меньше 10000.
SELECT Surname FROM Teachers
WHERE Salary < 20000 AND Premium < 10000 AND IsAssistant = 1