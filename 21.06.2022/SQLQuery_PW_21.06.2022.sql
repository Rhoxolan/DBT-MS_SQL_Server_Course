--БД "Hospital" https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/20.06.2022/PW_20.06.2022.sql

USE Hospital

--1. Вывести названия отделений, что находятся в том же корпусе, что и отделение “Приёмный покой”.
SELECT Name
FROM Departments
WHERE Building = (SELECT Building FROM Departments WHERE Name = 'Приёмный покой')

--2. Вывести названия отделений, что находятся в том же корпусе, что и отделения “Приёмный покой” и “Аллергология”.
SELECT Name
FROM Departments
WHERE Building = ANY(SELECT Building FROM Departments WHERE Name = 'Приёмный покой' OR Name = 'Аллергология')

--3. Вывести название отделения, которое получило меньше всего пожертвований.
SELECT Departments.Name, Donations.Amount
FROM Departments, Donations
WHERE Donations.DepartmentId = Departments.Id AND Donations.Amount = (SELECT MIN(Donations.Amount) FROM Donations)

--4. Вывести фамилии врачей, ставка которых больше, чем у врача “Анатолий Анатольевич”.
SELECT Doctors.Name
FROM Doctors
WHERE Doctors.Salary > (SELECT Doctors.Salary FROM Doctors WHERE Doctors.Name = 'Анатолий Анатольевич')

--5. Вывести названия палат, вместимость которых больше, чем средняя вместимость в палатах отделения “Приёмный покой”.