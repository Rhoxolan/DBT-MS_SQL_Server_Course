USE Hospital

/*БД создана https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/13.06.2022/PracticWork.sql
В этом документе мы дополняем необходимую таблицу*/
CREATE TABLE Wards
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Building INT CHECK(Building > -1 AND Building < 6) NOT NULL,
Floor INT CHECK (Floor > 0),
Name NVARCHAR(20) CHECK(Name != '') UNIQUE NOT NULL
)

INSERT Wards VALUES
(5, 3, 'Палата 3'),
(5, 1, 'Палата 1'),
(3, 7, 'Палата 7')

--1. Вывести содержимое таблицы палат
SELECT * FROM Wards

--2. Вывести фамилии и телефоны всех врачей
SELECT Name, Phone FROM Doctors

--3. Вывести все этажи без повторений, на которых располагаются палаты
SELECT DISTINCT Floor FROM Wards

--4. Вывести названия заболеваний под именем "Name of Disease" и степень их тяжести под именем "Severity of Disease"
SELECT
Name AS 'Name of Disease',
Severity AS 'Severity of Disease'
FROM Diseases

--5. Использовать выражение FROM для любых трех таблиц базы данных, используя для них псевдонимы
SELECT
Департамент.Name AS 'Название Департамента',
Палата.Name AS Палата,
Обследование.Name AS 'Название обследования'
FROM
Departments AS Департамент,
Wards AS Палата,
Examinations AS Обследование

--6. Вывести названия отделений, расположенных в корпусе 5 и имеющих фонд финансирования менее 500
SELECT Name FROM Departments
WHERE Building = 5 AND Financing > 500

--7. Вывести названия отделений, расположенных в 1-м корпусе с фондом финансирования в диапазоне от 500 до 15000
SELECT Name FROM Departments
WHERE Building = 1 AND Financing BETWEEN 500 AND 15000

--8. Вывести названия палат, расположенных в корпусах 4 и 5 на 1-м этаже.
SELECT Name FROM Wards
Where Building IN (4, 5) AND Floor = 1

--9. Вывести названия, корпуса и фонды финансирования отделений, расположенных в корпусах 1 или 5 и имеющих фонд финансирования меньше 11000 или больше 25000.
SELECT Name, Building, Financing FROM Departments
WHERE Building IN (1, 5) AND Financing < 11000 OR Financing > 25000

--10. Вывести фамилии врачей, чья зарплата (сумма ставки и надбавки) превышает 1500.
--Роль строки надбавки играет зарплата
SELECT Name FROM Doctors
WHERE Salary + Salary > 1500

--11. Вывести фамилии врачей, у которых половина зарплаты превышает троекратную надбавку.
--За надбавку взято значение 1500
SELECT Name FROM Doctors
WHERE (Salary / 2) > (1500 * 3)

--12. Вывести названия обследований без повторений, проводимых в первые три дня недели с 08:00 до 11:00.
SELECT Name FROM Examinations
WHERE DayOfWeek IN (1,2,3) AND StartTime BETWEEN '08:00:00' AND '11:00:00'

--13. Вывести названия и номера корпусов отделений, расположенных в корпусах 1, 3 или 5.
SELECT Name, Building FROM Departments
WHERE Building IN (1,3,5)

--14. Вывести названия заболеваний всех степеней тяжести, кроме 2-й и 3-й.
SELECT Name FROM Diseases
WHERE Severity NOT IN (2,3)

--15. Вывести названия отделений, которые не располагаются в 1-м или 3-м корпусе
SELECT Name FROM Departments
WHERE Building NOT IN (1,3)

--16. Вывести названия отделений, которые располагаются в 1-м или 3-м корпусе.
SELECT Name FROM Departments
WHERE Building IN (1,3)

--17. Вывести фамилии врачей, начинающиеся на букву "П".
SELECT Name FROM Doctors
WHERE Name LIKE 'П%'
