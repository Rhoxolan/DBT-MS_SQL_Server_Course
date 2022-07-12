--�� "Hospital" https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/20.06.2022/PW_20.06.2022.sql

USE Hospital

--1. ������� �������� ���������, ��� ��������� � ��� �� �������, ��� � ��������� �������� �����.
SELECT Name
FROM Departments
WHERE Building = (SELECT Building FROM Departments WHERE Name = '������� �����')

--2. ������� �������� ���������, ��� ��������� � ��� �� �������, ��� � ��������� �������� ����� � ��������������.
SELECT Name
FROM Departments
WHERE Building = ANY(SELECT Building FROM Departments WHERE Name = '������� �����' OR Name = '������������')

--3. ������� �������� ���������, ������� �������� ������ ����� �������������.
SELECT Departments.Name, Donations.Amount
FROM Departments, Donations
WHERE Donations.DepartmentId = Departments.Id AND Donations.Amount = (SELECT MIN(Donations.Amount) FROM Donations)

--4. ������� ������� ������, ������ ������� ������, ��� � ����� ��������� ������������.
SELECT Doctors.Name
FROM Doctors
WHERE Doctors.Salary > (SELECT Doctors.Salary FROM Doctors WHERE Doctors.Name = '�������� �����������')

--5. ������� �������� �����, ����������� ������� ������, ��� ������� ����������� � ������� ��������� �������� �����.