-- Задание 1. Создайте следующие пользовательские функции:

--1. Пользовательская функция возвращает приветствие в стиле «Hello, ИМЯ!» Где ИМЯ
-- передаётся в качестве параметра. Например, если передали Nick, то будет Hello, Nick!
GO
CREATE FUNCTION HelloFunctions (@name NVARCHAR(max))
RETURNS NVARCHAR(max)
AS
BEGIN RETURN CONCAT('Hello, ', @name, '!')
END

SELECT dbo.HelloFunctions('Тут имя')

--2. Пользовательская функция возвращает информацию о текущем количестве минут 
GO
CREATE FUNCTION GetMinutes()
RETURNS INT
AS
BEGIN RETURN DATEPART(MINUTE, GETDATE()) --ДОБАВИТЬ В ПРИМЕЧАНИЕ!
END

SELECT dbo.GetMinutes()

--3. Пользовательская функция возвращает информацию о текущем годе
GO
CREATE FUNCTION GetYear()
RETURNS INT
AS
BEGIN RETURN DATEPART(YEAR, GETDATE())
END

SELECT dbo.GetYear()

--4. Пользовательская функция возвращает информацию о том: чётный или нечётный год
GO
CREATE FUNCTION GetIsEvenYear()
RETURNS NVARCHAR(15)
AS
BEGIN
IF (DATEPART(YEAR, GETDATE()) % 2 != 0)
	RETURN 'Год не четный!'
RETURN 'Год четный!'
END

SELECT dbo.GetIsEvenYear()

--5. Пользовательская функция принимает число и возвращает yes, если число простое и no, если число не простое. 
GO
CREATE FUNCTION GetIsInt(@digit REAL) --https://russianblogs.com/article/5306451125/
RETURNS NVARCHAR(3)
AS
BEGIN
DECLARE @str NVARCHAR(max)
SELECT @str = CONVERT(NVARCHAR(max), @digit)
SET @str = ISNULL(LTRIM(RTRIM(@str)), N'-')
IF @str LIKE '%[^0-9]%' OR @str = N''
	RETURN 'No'
RETURN 'Yes'
END

SELECT dbo.GetIsInt(11)

--6. Пользовательская функция принимает в качестве параметров пять чисел. Возвращает сумму
-- минимального и максимального значения из переданных пяти параметров
GO
CREATE FUNCTION GetSumMinMaxFromFive(@val1 INT, @val2 INT, @val3 INT, @val4 INT, @val5 INT)
RETURNS INT
AS
BEGIN
DECLARE @MinV INT, @MaxV INT
SELECT @MinV = (SELECT MIN(m) FROM(VALUES(@val1),(@val2),(@val3),(@val4),(@val5)) T (m))
SELECT @MaxV = (SELECT MAX(m) FROM(VALUES(@val1),(@val2),(@val3),(@val4),(@val5)) T (m))
RETURN @MinV + @MaxV
END

SELECT dbo.GetSumMinMaxFromFive(1,2,3,4,5)

--7. Пользовательская функция показывает все четные или нечетные числа в переданном диапазоне. Функция принимает
-- три параметра: начало диапазона, конец диапазона, чёт или нечет показывать.
CREATE FUNCTION GetEvensOnDiapason(@startD INT, @endD INT, @evenornot BIT)
RETURNS NVARCHAR(max)
AS
BEGIN
DECLARE @_str NVARCHAR(max)
WHILE (@startD < @endD)
	BEGIN
	if (@evenornot = 1)
		if(@startD % 2 = 0)
			SET @_str = CONCAT(@_str, ' ', @startD)
	if (@evenornot = 0)
		if(@startD % 2 != 0)
			SET @_str = CONCAT(@_str, ' ', @startD)
	SET @startD += 1
	END
	RETURN @_str
END

SELECT dbo.GetEvensOnDiapason(1, 10, 1)
SELECT dbo.GetEvensOnDiapason(1, 10, 0)
