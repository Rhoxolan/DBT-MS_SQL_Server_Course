-- ������ �� Hospital
CREATE DATABASE Hospital

--������������� �� �������
USE Hospital

--������ ������� ������������ (Examinations)
CREATE TABLE Examinations
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DayOfWeek INT CHECK(DayOfWeek > 0 AND DayOfWeek < 8) NOT NULL,
StartTime TIME CHECK(StartTime > '07:59:00' AND StartTime < '17:30:00') NOT NULL,
EndTime TIME NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL,
CHECK(EndTime > StartTime)
)

--������ ������� ��������� (Departments)
CREATE TABLE Departments
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Building INT CHECK (Building >= 0 AND Building < 16) NOT NULL,
Financing MONEY CHECK(Financing > 0) DEFAULT 0 NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL,
)

--������ ������� ����������� (Diseases)
CREATE TABLE Diseases
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') UNIQUE NOT NULL,
Severity INT CHECK (Severity > 0) DEFAULT 1 NOT NULL
)

--������ ������� ����� (Doctors)
CREATE TABLE Doctors
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(max) CHECK(Name != '') NOT NULL,
Phone CHAR(10) NOT NULL,
Salary MONEY CHECK(Salary > 0) NOT NULL
)

--��������� �������!

--��������� 3 ���������
INSERT Departments VALUES
(1, 1000, '������� �����'),
(2, 1000, '�������������'),
(5, 1000, '�������������')

--��������� 3 �����
INSERT Doctors VALUES
('������� ��������', '093XXXXXXX', 25000),
('���� ����������', '073XXXXXXX', 23000),
('�������� �����������', '068XXXXXXX', 17000),
('����', '050XXXXXXX', 5000)

--��������� 2 �����������
INSERT Diseases VALUES
('�������', 3),
('�����', 2)

--��������� ������ ��������� ������ - ������ ����
INSERT Diseases VALUES
('', 1)

--"���������� ������"
INSERT Diseases VALUES
('����', 1)

--��������� ������������
INSERT Examinations VALUES
(3, '08:30:00', '09:00:00', '������ ��������')

--��������� ������ ��������� ������� - ����� ������ ������ ������������ � ����� ��������� ������ ������� ������
INSERT Examinations VALUES
(3, '06:25:00', '09:00:00', '������ ������')
INSERT Examinations VALUES
(3, '10:25:00', '09:00:00', '�������� ���� ������')

--����������
INSERT Examinations VALUES
(3, '08:25:00', '09:00:00', '������ ������'),
(3, '10:25:00', '10:30:00', '�������� ���� ������')