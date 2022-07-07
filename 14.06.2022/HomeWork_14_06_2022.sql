USE Academy

--�� ������� https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/13.06.2022/HomeWork.sql

--������ ����������� ��������� � �������
ALTER TABLE Faculties
ADD Dean NVARCHAR(max) CHECK(Dean != '') NULL --���������� - ��� ��������� NOT NULL � ������ ������ ��������� ������ ��������� ��������

ALTER TABLE Teachers
ADD IsAssistant BIT DEFAULT 0 NOT NULL

ALTER TABLE Teachers
ADD IsProfessor BIT DEFAULT 0 NOT NULL

ALTER TABLE Teachers
ADD Position NVARCHAR(max) CHECK(Position != '') DEFAULT '�������� ���' NOT NULL

--1. ������� ������� ������, �� ����������� �� ���� � �������� �������.
SELECT * FROM Departments
ORDER BY Name DESC

--2. ������� �������� ����� � �� ��������, ��������� � �������� �������� ��������� ����� "Group Name" � "Group Rating" ��������������.
SELECT Name AS 'Group Name', Rating AS 'Group Rating' FROM Groups

--3. ������� ��� �������������� �� �������, ������� ������ �� ��������� � �������� � ������� ������ �� ��������� � �������� (����� ������ � ��������).
SELECT Surname, Salary + Premium AS �������� FROM Teachers

--4. ������� ������� ����������� � ���� ������ ���� � ��������� �������: �The dean of faculty [faculty] is [dean].�.
SELECT 'The dean of faculty ' + Name + ' is ' + Dean AS '���� � ����������' FROM Faculties

--5. ������� ������� ��������������, ������� �������� ������������ � ������ ������� ��������� 1050.
SELECT Surname FROM Teachers
WHERE IsProfessor = 1 AND Salary > 1050

--6. ������� �������� ������, ���� �������������� ������� ������ 11000 ��� ������ 25000.
SELECT Name FROM Departments
WHERE Financing NOT BETWEEN 11000 AND 25000

--7. ������� �������� ����������� ����� ���������� ����������� ������������� � ������.
SELECT Name FROM Faculties
WHERE Name != '���������� ������������� � �����'

--8. ������� ������� � ��������� ��������������, ������� �� �������� ������������.
SELECT Surname, Position FROM Teachers
WHERE IsProfessor = 0

--9. ������� �������, ���������, ������ � �������� �����������, � ������� �������� � ��������� �� 160 �� 5550.
SELECT Surname, Position, Salary, Premium FROM Teachers
WHERE IsAssistant = 1 AND Premium BETWEEN 160 AND 5550

--10. ������� ������� � ������ �����������.
SELECT Surname, Salary FROM Teachers
WHERE IsAssistant = 1

--11. ������� ������� � ��������� ��������������, ������� ���� ������� �� ������ �� 01.01.2010.
SELECT Surname, Position FROM Teachers
WHERE EmploymentDate < '2010-01-01'

--12. ������� �������� ������, ������� � ���������� ������� ������������� �� ������� ������������ ���������� �������������. ��������� ���� ������ ����� �������� �Name of Department�.
SELECT Name FROM Departments
WHERE Name < '����������� ���������� ������������'
ORDER BY Name

--13. ������� ������� �����������, ������� �������� (����� ������ � ��������) �� ����� 100000
SELECT Surname FROM Teachers
WHERE IsAssistant = 1 AND (Salary + Premium) <= 100000

--14. ������� �������� ����� 5-�� �����, ������� ������� � ��������� �� 2 �� 4.
SELECT Name FROM Groups
WHERE Year = 5 AND Rating BETWEEN 2 AND 4

--15. ������� ������� ����������� �� ������� ������ 20000 ��� ��������� ������ 10000.
SELECT Surname FROM Teachers
WHERE Salary < 20000 AND Premium < 10000 AND IsAssistant = 1