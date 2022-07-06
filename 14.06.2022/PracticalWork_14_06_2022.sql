USE Hospital

/*�� ������� https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/13.06.2022/PracticWork.sql
� ���� ��������� �� ��������� ����������� �������*/
CREATE TABLE Wards
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Building INT CHECK(Building > -1 AND Building < 6) NOT NULL,
Floor INT CHECK (Floor > 0),
Name NVARCHAR(20) CHECK(Name != '') UNIQUE NOT NULL
)

INSERT Wards VALUES
(5, 3, '������ 3'),
(5, 1, '������ 1'),
(3, 7, '������ 7')

--1. ������� ���������� ������� �����
SELECT * FROM Wards

--2. ������� ������� � �������� ���� ������
SELECT Name, Phone FROM Doctors

--3. ������� ��� ����� ��� ����������, �� ������� ������������� ������
SELECT DISTINCT Floor FROM Wards

--4. ������� �������� ����������� ��� ������ "Name of Disease" � ������� �� ������� ��� ������ "Severity of Disease"
SELECT
Name AS 'Name of Disease',
Severity AS 'Severity of Disease'
FROM Diseases

--5. ������������ ��������� FROM ��� ����� ���� ������ ���� ������, ��������� ��� ��� ����������
SELECT
�����������.Name AS '�������� ������������',
������.Name AS ������,
������������.Name AS '�������� ������������'
FROM
Departments AS �����������,
Wards AS ������,
Examinations AS ������������

--6. ������� �������� ���������, ������������� � ������� 5 � ������� ���� �������������� ����� 500
SELECT Name FROM Departments
WHERE Building = 5 AND Financing > 500

--7. ������� �������� ���������, ������������� � 1-� ������� � ������ �������������� � ��������� �� 500 �� 15000
SELECT Name FROM Departments
WHERE Building = 1 AND Financing BETWEEN 500 AND 15000

--8. ������� �������� �����, ������������� � �������� 4 � 5 �� 1-� �����.
SELECT Name FROM Wards
Where Building IN (4, 5) AND Floor = 1

--9. ������� ��������, ������� � ����� �������������� ���������, ������������� � �������� 1 ��� 5 � ������� ���� �������������� ������ 11000 ��� ������ 25000.
SELECT Name, Building, Financing FROM Departments
WHERE Building IN (1, 5) AND Financing < 11000 OR Financing > 25000

--10. ������� ������� ������, ��� �������� (����� ������ � ��������) ��������� 1500.
--���� ������ �������� ������ ��������
SELECT Name FROM Doctors
WHERE Salary + Salary > 1500

--11. ������� ������� ������, � ������� �������� �������� ��������� ����������� ��������.
--�� �������� ����� �������� 1500
SELECT Name FROM Doctors
WHERE (Salary / 2) > (1500 * 3)

--12. ������� �������� ������������ ��� ����������, ���������� � ������ ��� ��� ������ � 08:00 �� 11:00.
SELECT Name FROM Examinations
WHERE DayOfWeek IN (1,2,3) AND StartTime BETWEEN '08:00:00' AND '11:00:00'

--13. ������� �������� � ������ �������� ���������, ������������� � �������� 1, 3 ��� 5.
SELECT Name, Building FROM Departments
WHERE Building IN (1,3,5)

--14. ������� �������� ����������� ���� �������� �������, ����� 2-� � 3-�.
SELECT Name FROM Diseases
WHERE Severity NOT IN (2,3)

--15. ������� �������� ���������, ������� �� ������������� � 1-� ��� 3-� �������
SELECT Name FROM Departments
WHERE Building NOT IN (1,3)

--16. ������� �������� ���������, ������� ������������� � 1-� ��� 3-� �������.
SELECT Name FROM Departments
WHERE Building IN (1,3)

--17. ������� ������� ������, ������������ �� ����� "N".

-- �� ���. ��������� ��� LIKE
