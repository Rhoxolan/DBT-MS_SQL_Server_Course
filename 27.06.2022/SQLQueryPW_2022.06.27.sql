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
AS RETURN (@num1 + @num2 + @num3) -- Примечание - RETURN возвращяет только int --Добавить в примечание

DECLARE @sumVal INT
EXEC @sumVal = GetSumThreeNums 1, 2, 3
PRINT @sumVal

--5. Хранимая процедура принимает три числа и возвращает среднеарифметическое трёх чисел
GO
CREATE PROCEDURE GetAVGThreeNums @num1 REAL, @num2 REAL, @num3 REAL, @avgnums REAL OUTPUT --Добавить в примечание
AS SET @avgnums = (@num1 + @num2 + @num3) / 3

DECLARE @avgVal REAL
EXEC GetAVGThreeNums 1,2,3.5, @avgVal OUTPUT
PRINT @avgVal

--6. Хранимая процедура принимает три числа и возвращает максимальное значение
GO
CREATE PROCEDURE GetMaxValue @num1 INT, @num2 INT, @num3 INT
AS RETURN (SELECT MAX(N) FROM(VALUES(@num1),(@num2),(@num3)) T (N))

DECLARE @maxVal INT
EXEC @maxVal = GetMaxValue 1, 2, 3
PRINT @maxVal

--7. Хранимая процедура принимает три числа и возвращает минимальное значение
GO
CREATE PROCEDURE GetMinValue @num1 INT, @num2 INT, @num3 INT
AS RETURN (SELECT Min(N) FROM(VALUES(@num1),(@num2),(@num3)) T (N))

DECLARE @MinVal INT
EXEC @MinVal = GetMinValue 1, 2, 3
PRINT @MinVal

--8. Хранимая процедура принимает число и символ. В результате работы хранимой процедуры
-- отображается линия длиной равной числу. Линия построена из символа, указанного во втором
-- параметре. Например, если было передано 5 и #, мы получим линию такого вида #####
GO
CREATE PROCEDURE CharMultDig @character NCHAR(1), @digit INT, @string NVARCHAR(max) OUTPUT
AS
SET @string = replicate(@character, @digit)

DECLARE @multchar NVARCHAR(MAX)
EXEC @multchar = CharMultDig '#', 10, @multchar OUTPUT
PRINT @multchar

--Разобраться
