-- Задание 1. Создайте следующие хранимые процедуры:

--1. Хранимая процедура выводит «Hello, world!»
GO
CREATE PROCEDURE HelloWorld
AS PRINT 'Hello, World!'

EXEC HelloWorld

--2. Хранимая процедура возвращает информацию о текущем времени
GO
CREATE PROCEDURE GetCurTime
AS PRINT GETDATE()

EXEC GetCurTime

--3. Хранимая процедура возвращает информацию о текущей дате
GO
CREATE PROCEDURE GetCurDate
AS PRINT CONVERT(DATE, GETDATE()) --Добавить в примечание

EXEC GetCurDate

--4. Хранимая процедура принимает три числа и возвращает их сумму
GO
CREATE PROCEDURE GetSumThreeNums @num1 INT, @num2 INT, @num3 INT 
AS RETURN (@num1 + @num2 + @num3)

DECLARE @sumVal INT
EXEC @sumVal = GetSumThreeNums 1, 2, 3
PRINT @sumVal

--5. Хранимая процедура принимает три числа и возвращает среднеарифметическое трёх чисел
GO
CREATE PROCEDURE GetAVGThreeNums @num1 REAL, @num2 REAL, @num3 REAL, @avgnums REAL OUTPUT
AS SET @avgnums = (@num1 + @num2 + @num3) / 3

DECLARE @avgVal REAL
EXEC GetAVGThreeNums 1,2,3.5, @avgVal OUTPUT
PRINT @avgVal


