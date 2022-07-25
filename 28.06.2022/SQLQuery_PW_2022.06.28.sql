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
BEGIN RETURN DATEPART(MINUTE, GETDATE())
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


-- Задание 2. Для базы данных «Продажи» из практического задания модуля «Работа с таблицами и представлениями в
-- MS SQL Server» создайте следующие пользовательские функции:

USE SportShop

--1. Пользовательская функция возвращает минимальную продажу конкретного продавца.
-- ФИО продавца передаётся в качестве параметра пользовательской функции
GO
CREATE FUNCTION GetMinSelling(@fullName NVARCHAR(max))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP(1) Products.Price, Products.Name, Sellings.SellingDate, Salesmans.FullName
	FROM Sellings
	JOIN Products ON Sellings.ProductId = Products.Id
	JOIN Salesmans ON Sellings.SalesmanId = Salesmans.Id
	WHERE Salesmans.FullName = @fullName
	ORDER BY Products.Price
);

SELECT * FROM GetMinSelling('Васильева Татьяна Петровна')

--2. Пользовательская функция возвращает минимальную покупку конкретного покупателя.
-- ФИО покупателя передаётся в качестве параметра пользовательской функции
CREATE FUNCTION GetMinSellingsOnBuyers(@fullName NVARCHAR(max))
RETURNS TABLE
AS
RETURN
(
	SELECT TOP(1) Products.Price, Products.Name, Sellings.SellingDate, Buyers.FullName
	FROM Sellings
	JOIN Products ON Sellings.ProductId = Products.Id
	JOIN Buyers ON Sellings.BuyerId = Buyers.Id
	WHERE Buyers.FullName = @fullName
	ORDER BY Products.Price
);

SELECT * FROM GetMinSellingsOnBuyers('Петров Петр Андреевич')

--3. Пользовательская функция возвращает общую сумму продаж на конкретную дату.
-- Дата продажи передаётся в качестве параметра
CREATE FUNCTION GetTotalSellingsSumOnDate(@date DATE)
RETURNS TABLE
AS
RETURN
(
	SELECT SUM(Products.Price) AS Sum, Sellings.SellingDate
	FROM Sellings
	JOIN Products ON Sellings.ProductId = Products.Id
	WHERE Sellings.SellingDate = @date
	GROUP BY Sellings.SellingDate
)

SELECT * FROM GetTotalSellingsSumOnDate('2022-07-19')

--4. Пользовательская функция возвращает дату, когда общая сумма продаж за день была максимальной
CREATE FUNCTION GetDateWhereMaxSellingsPrice()
RETURNS DATE
AS
BEGIN
	DECLARE @DateWhereMaxSellingsPrice DATE
	SELECT @DateWhereMaxSellingsPrice = Sellings.SellingDate
		FROM Sellings
		JOIN Products ON Sellings.ProductId = Products.Id
		WHERE Sellings.SellingDate = (
			SELECT TOP(1) Sellings.SellingDate
			FROM Sellings
			JOIN Products ON Sellings.ProductId = Products.Id
			GROUP BY Sellings.SellingDate
			ORDER BY SUM(Products.Price) DESC)
	RETURN @DateWhereMaxSellingsPrice
END

SELECT dbo.GetDateWhereMaxSellingsPrice()

--5. Пользовательская функция возвращает информацию о всех продажах заданного
-- товара. Название товара передаётся в качестве параметра
CREATE FUNCTION GetProductSellings(@productName NVARCHAR(50))
RETURNS TABLE
AS
RETURN
(
	SELECT Products.Name, Sellings.SellingDate
	FROM Sellings
	JOIN Products ON Sellings.ProductId = Products.Id
	WHERE Products.Name = @productName
)

SELECT * FROM GetProductSellings('Полуботинки MERREL трекинговые')

--6. Пользовательская функция возвращает информацию о всех продавцах с одинаковой ЗП
CREATE FUNCTION GetSalesmansWithTheSameSalary()
RETURNS TABLE
AS RETURN (
	SELECT S.FullName, S.Salary
	FROM Salesmans S
	WHERE EXISTS (SELECT Salesmans.Id FROM Salesmans WHERE Salesmans.Id != S.Id AND Salesmans.Salary = S.Salary)
)

SELECT * FROM GetSalesmansWithTheSameSalary()

--7. Пользовательская функция возвращает информацию о всех покупателях с одиноковым процентом скидки
CREATE FUNCTION GetBuyersWithTheSameSalary()
RETURNS TABLE
AS RETURN (
	SELECT B.FullName, B.SailPercent
	FROM Buyers B
	WHERE EXISTS (SELECT Buyers.Id FROM Buyers WHERE Buyers.Id != B.Id AND Buyers.SailPercent = B.SailPercent)
)

SELECT * FROM GetBuyersWithTheSameSalary()

--8. Пользовательская функция возвращает информацию о всех продавцах, которые являются покупателями
CREATE FUNCTION GetSalesmansWhoAreBuyers()
RETURNS TABLE
AS
RETURN
(
	SELECT Salesmans.FullName
	FROM Salesmans
	JOIN Buyers ON Salesmans.FullName = Buyers.FullName
)

SELECT FullName AS ФИО FROM GetSalesmansWhoAreBuyers()
