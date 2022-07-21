-- ������� 1. �������� ��������� �������� ���������:

--1. �������� ��������� ������� �Hello, world!�
GO
CREATE PROCEDURE HelloWorld
AS PRINT 'Hello, World!'

EXEC HelloWorld

--2. �������� ��������� ���������� ���������� � ������� �������
GO
CREATE PROCEDURE GetCurTime
AS PRINT GETDATE()

EXEC GetCurTime

--3. �������� ��������� ���������� ���������� � ������� ����
GO
CREATE PROCEDURE GetCurDate
AS PRINT CONVERT(DATE, GETDATE()) --�������� � ����������

EXEC GetCurDate

--4. �������� ��������� ��������� ��� ����� � ���������� �� �����
GO
CREATE PROCEDURE GetSumThreeNums @num1 INT, @num2 INT, @num3 INT 
AS RETURN (@num1 + @num2 + @num3)

DECLARE @sumVal INT
EXEC @sumVal = GetSumThreeNums 1, 2, 3
PRINT @sumVal

--5. �������� ��������� ��������� ��� ����� � ���������� �������������������� ��� �����
GO
CREATE PROCEDURE GetAVGThreeNums @num1 REAL, @num2 REAL, @num3 REAL, @avgnums REAL OUTPUT
AS SET @avgnums = (@num1 + @num2 + @num3) / 3

DECLARE @avgVal REAL
EXEC GetAVGThreeNums 1,2,3.5, @avgVal OUTPUT
PRINT @avgVal


