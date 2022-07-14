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
SELECT Wards.Name, Wards.Places
FROM Wards
WHERE Wards.Places >
	(SELECT AVG(Wards.Places) FROM Wards, Departments
	WHERE Departments.Id = Wards.DepartmentID AND Departments.Name = 'Приёмный покой')

--6. Вывести полные имена врачей, зарплаты которых (сумма ставки и надбавки) превышают более чем на 100 зарплату врача “Анатолий Анатольевич”.
SELECT Doctors.Name AS 'ФИО Врача', Doctors.Salary + Doctors.Premium AS 'Зарплата'
FROM Doctors
WHERE Doctors.Salary + Doctors.Premium > (SELECT Doctors.Salary + Doctors.Premium FROM Doctors WHERE Doctors.Name = 'Анатолий Анатольевич') + 100

--7. Вывести названия отделений, в которых проводит обследования врач “Анатолий Анатольевич”.
SELECT Departments.Name AS Отделение
FROM Departments
WHERE Departments.Name =
	(SELECT Departments.Name
	FROM Departments, Wards, DoctorsExaminations, Doctors
	WHERE DoctorsExaminations.DoctorId = Doctors.Id AND DoctorsExaminations.WardId = Wards.Id AND
	Wards.DepartmentID = Departments.Id AND Doctors.Name = 'Анатолий Анатольевич')

--8. Вывести названия спонсоров, которые не делали пожертвования отделениям “Травмотология” и “Хирургическое”.
SELECT Sponsors.Name
FROM Sponsors
WHERE Sponsors.Name != ALL
	(SELECT Sponsors.Name
	FROM Donations
	JOIN Departments ON Donations.DepartmentId = Departments.Id
	JOIN Sponsors ON Donations.SponsorId = Sponsors.Id
	WHERE Departments.Name = 'Травматология' OR Departments.Name = 'Хирургическое')

--9. Вывести фамилии врачей, которые проводят обследования в период с 12:00 до 15:00.
SELECT Doctors.Name
FROM Doctors
WHERE Doctors.Id =
	(SELECT DoctorsExaminations.Id
	FROM DoctorsExaminations
	WHERE DoctorsExaminations.StartTime BETWEEN '12:00:00' AND '15:00:00')
