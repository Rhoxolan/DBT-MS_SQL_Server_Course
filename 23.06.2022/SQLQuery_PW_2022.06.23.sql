CREATE DATABASE SportShop

USE SportShop

CREATE TABLE Products
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') NOT NULL,
CategoryId INT REFERENCES Categories(Id) ON DELETE CASCADE NOT NULL,
ProductsAmount INT CHECK(ProductsAmount > -1) NOT NULL,
CostPrice INT NOT NULL,
Price INT NOT NULL,
Manufacturer INT NOT NULL
)

CREATE TABLE Archive
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
ProductId INT REFERENCES Products(Id) NOT NULL
)

CREATE TABLE Categories
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') NOT NULL
)

CREATE TABLE Sellings
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
ProductId INT REFERENCES Products(Id) ON DELETE CASCADE NOT NULL,
SellingDate DATE CHECK(SellingDate > '2010-01-01' AND SellingDate <= GETDATE()) DEFAULT GETDATE() NOT NULL,
SalesmanId INT REFERENCES Salesmans(Id) NOT NULL,
BuyerId INT REFERENCES Buyers(Id) NULL
)

CREATE TABLE LastUnit
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
ProductId INT REFERENCES Products(Id) ON DELETE CASCADE NOT NULL
)

CREATE TABLE History
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
SellingId INT REFERENCES Sellings(Id) NOT NULL
)

CREATE TABLE Salesmans
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FullName NVARCHAR(100) CHECK(FullName != '') NOT NULL,
PositionId INT REFERENCES Positions(Id) NOT NULL,
Gender NVARCHAR(100) CHECK(Gender != '') NOT NULL,
Salary MONEY CHECK(Salary > -1) NOT NULL,
StartDate DATE CHECK(StartDate > '2010-01-01' AND DATEDIFF(year, StartDate, GETDATE()) < 5)
)

CREATE TABLE Positions
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(100) CHECK(Name != '') NOT NULL
)

CREATE TABLE Buyers
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FullName NVARCHAR(100) CHECK(FullName != '') NOT NULL,
Email NVARCHAR(100) CHECK(Email != '') NOT NULL,
Phone NVARCHAR(100) CHECK(Phone != '') NULL,
Gender NVARCHAR(100) CHECK(Gender != '') NOT NULL,
IsSubs BIT DEFAULT 0 NOT NULL
)

ALTER TABLE Buyers
ADD SailPercent INT CHECK(SailPercent > -1 AND SailPercent < 101) NOT NULL DEFAULT 0

--1. При продаже товара, заносить информацию о продаже в таблицу «История». Таблица «История» используется для дубляжа информации о всех продажах
CREATE TRIGGER Sellings_INSERT
ON Sellings
AFTER INSERT
AS
INSERT INTO History
SELECT Id FROM inserted

--2. Если после продажи товара не осталось ни одной единицы данного товара, необходимо перенести информацию
-- о полностью проданном товаре в таблицу «Архив»
CREATE TRIGGER Sellings_INSERT_4
ON Sellings
AFTER INSERT
AS
IF (SELECT ProductsAmount FROM Products JOIN inserted ON inserted.ProductId = Products.Id) = 0
	BEGIN
	INSERT Archive VALUES
	((SELECT inserted.ProductId FROM inserted))
	END;

--3. Не позволять регистрировать уже существующего клиента. При вставке проверять наличие клиента по номеру и email
-- https://dotnettutorials.net/lesson/instead-of-insert-trigger-in-sql-server/
CREATE TRIGGER Buyers_INSERT
ON Buyers
INSTEAD OF INSERT
AS
IF EXISTS (SELECT Buyers.Email, Buyers.Phone FROM Buyers JOIN inserted ON Buyers.Email = inserted.Email OR Buyers.Phone = inserted.Phone)
	BEGIN
	raiserror('Пользователь с такими данными уже зарегестрирован',16,1)
	RETURN
	END;
ELSE
	BEGIN
	INSERT INTO Buyers(Id, FullName, Email, Phone, Gender, IsSubs)
	SELECT Id, FullName, Email, Phone, Gender, IsSubs
	FROM inserted
END;

--4. Запретить удаление существующих клиентов
CREATE TRIGGER Buyers_DELETE
ON Buyers
INSTEAD OF DELETE
AS
	BEGIN
	raiserror('Мы не можем удалять зарегестрированного клиента!',16,1)
	RETURN
	END

--5. Запретить удаление сотрудников, принятых на работу до 2015 года
CREATE TRIGGER Salesmans_DELETE
ON Salesmans
INSTEAD OF DELETE
AS
IF (SELECT deleted.StartDate FROM deleted)  < '2015-01-01'
	BEGIN
	raiserror('Мы не можем удалить этого сотрудника!',16,1)
	RETURN
	END;
ELSE
	BEGIN
	DELETE FROM Salesmans
	WHERE Salesmans.Id = (SELECT deleted.Id from deleted)
	END;

--6. При новой покупке товара нужно проверять общую сумму покупок клиента.
-- Если сумма превысила 50000 грн, необходимо установить процент скидки в 15%
CREATE TRIGGER Sellings_INSERT_3
ON Sellings
AFTER INSERT
AS
	BEGIN
	DECLARE @buyrId INT;
	SET @buyrId = (SELECT inserted.BuyerId FROM inserted)
	IF (@buyrId is not null)
		BEGIN
		IF (SELECT SUM(Products.Price)
			FROM Products
			JOIN inserted ON inserted.ProductId = Products.Id
			JOIN Buyers ON Buyers.Id = inserted.BuyerId) > 50000
				BEGIN
				UPDATE Buyers
				SET SailPercent = 15
				WHERE Buyers.Id = @buyrId
				END;
		END;
	END;

--7. Запретить добавлять товар конкретной фирмы. Например, товар фирмы «Спорт, солнце и штанга»
CREATE TRIGGER Products_INSERT
ON Products
INSTEAD OF INSERT
AS
	BEGIN
	IF (SELECT Manufacturer from inserted) = 'TurboSport'
		BEGIN
		raiserror('Мы не можем добавлять товары этой фирмы!',16,1)
		RETURN
		END
	ELSE
		BEGIN
		INSERT INTO Products(Id, Name, CategoryId, ProductsAmount, CostPrice, Price, Manufacturer)
		SELECT Id, Name, CategoryId, ProductsAmount, CostPrice, Price, Manufacturer
		FROM inserted
		END
	END

--8. При продаже проверять количество товара в наличии. Если осталась одна единица товара,
-- необходимо внести информацию об этом товаре в таблицу «Последняя Единица».
CREATE TRIGGER Sellings_INSERT_2
ON Sellings
AFTER INSERT
AS
BEGIN
UPDATE Products
SET ProductsAmount = ((SELECT Products.ProductsAmount FROM Products JOIN inserted ON inserted.ProductId = Products.Id) - 1)
WHERE Products.Id = (SELECT Id FROM inserted)
IF (SELECT Products.ProductsAmount FROM Products JOIN inserted ON inserted.ProductId = Products.Id) = 1
	BEGIN
	INSERT INTO LastUnit
	SELECT Id FROM inserted
	END
END
