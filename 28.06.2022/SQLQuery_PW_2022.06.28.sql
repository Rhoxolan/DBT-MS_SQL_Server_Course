-- ������� 1. �������� ��������� ���������������� �������:

--1. ���������������� ������� ���������� ����������� � ����� �Hello, ���!� ��� ���
-- ��������� � �������� ���������. ��������, ���� �������� Nick, �� ����� Hello, Nick!
GO
CREATE FUNCTION HelloFunctions (@name NVARCHAR(max))
RETURNS NVARCHAR(max)
AS
BEGIN RETURN CONCAT('Hello, ', @name, '!')
END

SELECT dbo.HelloFunctions('��� ���')

--2. ���������������� ������� ���������� ���������� � ������� ���������� ����� 
GO
CREATE FUNCTION GetMinutes()
RETURNS INT
AS
BEGIN RETURN MINUTE(GETDATE())
END