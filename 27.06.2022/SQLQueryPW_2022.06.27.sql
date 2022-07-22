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
AS PRINT CONVERT(DATE, GETDATE())

EXEC GetCurDate

--4. Хранимая процедура принимает три числа и возвращает их сумму
GO
CREATE PROCEDURE GetSumThreeNums @num1 INT, @num2 INT, @num3 INT 
AS RETURN (@num1 + @num2 + @num3) -- Примечание - RETURN возвращяет только int

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
EXEC CharMultDig '#', 10, @multchar OUTPUT
PRINT @multchar

--9. Хранимая процедура принимает в качестве параметра число и возвращает его факториал.
-- Формула расчета факториала: n! = 1*2*…n. Например, 3! = 1*2*3 = 6
GO
CREATE PROCEDURE factorial @digit REAL, @factorialDigit REAL OUTPUT
AS
SET @factorialDigit = 1
WHILE @digit > 0
	BEGIN
	SET @factorialDigit = @factorialDigit * @digit
	SET @digit = @digit - 1
	END

Go
DECLARE @digit REAL
EXEC factorial 3, @digit OUTPUT
PRINT @digit

--10. Хранимая принимает два числовых параметра. Первый параметр — это число. Второй параметр — это степень.
-- Процедура возвращает число, возведенное в степень. Например, если параметры равны 2 и 3, тогда вернется 2 
-- в третьей степени, то есть 8.
GO
CREATE PROCEDURE exponentiation @digit REAL, @expd REAL, @prod REAL OUTPUT
AS
SET @prod = POWER(@digit, @expd)

GO
DECLARE @digit REAL
EXEC exponentiation 2.5, 3.1, @digit OUTPUT
PRINT @digit


-- Задание 2. Для базы данных «Продажи» из практического задания модуля «Работа с таблицами и представлениями в MS SQL Server»
-- создайте следующие хранимые процедуры:

USE SportShop

--1. Хранимая процедура показывает информацию о всех продавцах
GO
CREATE PROCEDURE ShowSalesmans AS
SELECT * FROM Salesmans

EXEC ShowSalesmans

--2. Хранимая процедура показывает информацию о всех покупателях
GO
CREATE PROCEDURE ShowBuyers AS
SELECT * FROM Buyers

EXEC ShowBuyers

--3. Хранимая процедура показывает полную информацию о продажах
GO
CREATE PROCEDURE ShowSellings AS
SELECT * FROM Sellings

EXEC ShowSellings

--4. Хранимая процедура показывает полную информацию о всех продажах в конкретный день. Дата продажи передаётся в качестве параметра
GO
CREATE PROCEDURE ShowSellingsOnDate @date DATE
AS
SELECT * FROM Sellings WHERE Sellings.SellingDate = @date

EXEC ShowSellingsOnDate '2022-07-19'

--5. Хранимая процедура показывает полную информацию о всех продажах в некотором временном сегменте. Дата
-- старта и конца сегмента передаётся в качестве параметра
GO
CREATE PROCEDURE ShowSellingsOnDates @startdate DATE, @enddate DATE
AS
SELECT * FROM Sellings WHERE Sellings.SellingDate BETWEEN @startdate AND @enddate

EXEC ShowSellingsOnDates '2022-07-19', '2022-07-20'

--6. Хранимая процедура отображает информацию о продажах конкретного продавца.
-- ФИО продавца передаётся в качестве параметра хранимой процедуры
GO
CREATE PROCEDURE ShowSalesmansSellings @fullName NVARCHAR(max)
AS
SELECT * FROM Sellings JOIN Salesmans ON Sellings.SalesmanId = Salesmans.Id WHERE Salesmans.FullName = @fullName

EXEC ShowSalesmansSellings 'Федоренко Марина Валентиновна'

--7. Хранимая процедура возвращает среднеарифметическую цену продажи в конкретный год. Год передаётся в качестве параметра.
GO
CREATE PROCEDURE ShowAVGSellingsOnYear @year INT, @avgPrice INT OUTPUT
AS
SELECT @avgPrice = AVG(Products.Price) FROM Sellings JOIN Products ON Sellings.ProductId = Products.Id AND YEAR(Sellings.SellingDate) = @year

GO
DECLARE @avgPrice INT
EXEC ShowAVGSellingsOnYear 2022, @avgPrice OUTPUT
PRINT @avgPrice
