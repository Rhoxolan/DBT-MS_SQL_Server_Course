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
Manufacturer NVARCHAR(MAX) NOT NULL
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
StartDate DATE CHECK(StartDate > '2010-01-01' AND StartDate < DATEADD(year, 5, GETDATE())) NOT NULL
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
CREATE TRIGGER Sellings_INSERT --Протестировано
ON Sellings
AFTER INSERT
AS
INSERT INTO History
SELECT Id FROM inserted

--2. Если после продажи товара не осталось ни одной единицы данного товара, необходимо перенести информацию
-- о полностью проданном товаре в таблицу «Архив»
DROP TRIGGER Sellings_INSERT_4
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
CREATE TRIGGER Buyers_INSERT --Протестировано, перепроверить EXISTS
ON Buyers
INSTEAD OF INSERT
AS
BEGIN
IF EXISTS (SELECT Buyers.Email, Buyers.Phone FROM Buyers JOIN inserted ON Buyers.Email = inserted.Email OR Buyers.Phone = inserted.Phone)
	BEGIN
	raiserror('Пользователь с такими данными уже зарегестрирован',16,1)
	RETURN
	END
ELSE
	BEGIN
	INSERT INTO Buyers(FullName, Email, Phone, Gender, IsSubs, SailPercent)
	SELECT FullName, Email, Phone, Gender, IsSubs, SailPercent
	FROM inserted
	END
END

DROP TRIGGER Buyers_INSERT

--4. Запретить удаление существующих клиентов
CREATE TRIGGER Buyers_DELETE --Протестировано
ON Buyers
INSTEAD OF DELETE
AS
	BEGIN
	raiserror('Мы не можем удалять зарегестрированного клиента!',16,1)
	RETURN
	END

--5. Запретить удаление сотрудников, принятых на работу до 2015 года
CREATE TRIGGER Salesmans_DELETE --Протестировано, перепроверить if
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
CREATE TRIGGER Sellings_INSERT_3 -- Протестировано
ON Sellings
AFTER INSERT
AS
BEGIN
UPDATE Buyers -- Триггер работает при покупке товара на >50000, не на всю сумму чека
SET SailPercent = 15
FROM
(SELECT Sellings.BuyerId
FROM Sellings
JOIN inserted ON inserted.Id = Sellings.Id
JOIN Products ON Sellings.ProductId = Products.Id
WHERE Sellings.BuyerId is not null AND Products.Price > 50000) AS Selected
WHERE Selected.BuyerId = Buyers.Id
END;

--7. Запретить добавлять товар конкретной фирмы. Например, товар фирмы «Спорт, солнце и штанга»
CREATE TRIGGER Products_INSERT --Протестировано, перепроверить exists
ON Products
INSTEAD OF INSERT
AS
BEGIN
IF EXISTS (SELECT Manufacturer from inserted WHERE Manufacturer = 'TurboSport')
	BEGIN
	raiserror('Мы не можем добавлять товары этой фирмы!',16,1)
	RETURN
	END
ELSE
	BEGIN
	INSERT INTO Products(Name, CategoryId, ProductsAmount, CostPrice, Price, Manufacturer)
	SELECT Name, CategoryId, ProductsAmount, CostPrice, Price, Manufacturer
	FROM inserted
	END
END

--8. При продаже проверять количество товара в наличии. Если осталась одна единица товара,
-- необходимо внести информацию об этом товаре в таблицу «Последняя Единица».
CREATE TRIGGER Sellings_INSERT_2 --Протестировано
ON Sellings
AFTER INSERT
AS
BEGIN
--Уменьшаем к-во товара
UPDATE Products
SET ProductsAmount = ProductsAmount - 1
FROM (SELECT Products.Id FROM Products JOIN inserted ON inserted.ProductId = Products.Id) AS Selected
WHERE Products.Id = Selected.Id
--Добавляем в таблицу "Последняя единица" при достижении ProductsAmount = 1:
INSERT LastUnit VALUES
((SELECT Products.Id FROM Products WHERE Products.Id = ANY(SELECT inserted.ProductId FROM inserted)))
--Убираем из таблицы "Последняя единица" при достижении ProductsAmount = 0:
DELETE LastUnit
WHERE LastUnit.ProductId = (SELECT Products.Id FROM Products WHERE Products.Id = ANY(SELECT inserted.ProductId FROM inserted) AND Products.ProductsAmount = 0)
END

--Тестируем БД и триггеры

INSERT Positions VALUES
('Продавец'),
('Старший продавец'),
('Начальник отдела продаж')

INSERT Salesmans VALUES
('Петрова Галина Павловна', (SELECT Id FROM Positions WHERE Name = 'Продавец'), 'Жен', 10000, '2018-03-03'),
('Федоренко Марина Валентиновна', (SELECT Id FROM Positions WHERE Name = 'Продавец'), 'Жен', 10000, '2021-07-20'),
('Васильева Татьяна Петровна', (SELECT Id FROM Positions WHERE Name = 'Продавец'), 'Жен', 12000, '2014-09-03'),
('Петренко Антон Петрович', (SELECT Id FROM Positions WHERE Name = 'Старший продавец'), 'Муж', 15000, '2013-01-05'),
('Василюк Антонина Павловна', (SELECT Id FROM Positions WHERE Name = 'Старший продавец'), 'Жен', 15000, '2019-04-05'),
('Романюк Галина Борисовна', (SELECT Id FROM Positions WHERE Name = 'Начальник отдела продаж'), 'Жен', 21000, '2015-05-05')
--Тестируем триггер №5 Salesmans_DELETE, пытаемся удалить пользователя принятого на работу до 2015 года
DELETE FROM Salesmans WHERE Salesmans.FullName = 'Васильева Татьяна Петровна'
--Другого удалить можем
INSERT Salesmans VALUES
('Петрова Марина Павловна', (SELECT Id FROM Positions WHERE Name = 'Продавец'), 'Жен', 9000, '2018-03-03')
DELETE FROM Salesmans WHERE Salesmans.FullName = 'Петрова Марина Павловна'

--Тестируем триггер №3 Buyers_INSERT
INSERT Buyers VALUES
('Петров Петр Андреевич', 'partypetya@petrovich.com', '+358118629076', 'Муж', 1, 0),
('Василькович Анатолий Митрофанович', 'tolyatolyan@anatoliy.com', '+158178656077', 'Муж', 0, 0),
('Петрова Анастасия Васильевна', 'partypetya@petrovich.com', '+128314659677', 'Жен', 1, 0)
--Намеренно неверный запрос - добавление уже зарегестрированного пользоватлеля
INSERT Buyers VALUES
('Петров Петр Андреевич', 'partypetya@petrovich.com', '+358118629076', 'Муж', 1, 0)
--Тестируем триггер №4 Buyers_DELETE, пытаемся удалить зарегетрированного пользователя
DELETE FROM Buyers WHERE Buyers.FullName = 'Василькович Анатолий Митрофанович'


INSERT Categories VALUES
('Спортивная одежда'),
('Спортивная обувь'),
('Спортивный инвертарь')

--Тестируем триггер №7 Products_INSERT
INSERT Products VALUES
('Полуботинки MERREL трекинговые', (SELECT Id FROM Categories WHERE Name = 'Спортивная обувь'), 15, 2500, 3700, 'MERREL'),
('Полуботинки Columbia трекинговые', (SELECT Id FROM Categories WHERE Name = 'Спортивная обувь'), 15, 3500, 5700, 'Columbia'),
('Куртка Outventure демисезон', (SELECT Id FROM Categories WHERE Name = 'Спортивная одежда'), 35, 500, 1500, 'Outventure'),
('Куртка Merrel зима', (SELECT Id FROM Categories WHERE Name = 'Спортивная одежда'), 5, 3500, 7700, 'MERREL'),
('Гантели Интер-Атлетика 5 кг', (SELECT Id FROM Categories WHERE Name = 'Спортивный инвертарь'), 50, 200, 300, 'Интер-Атлетика'),
('Гантели Интер-Атлетика 7 кг', (SELECT Id FROM Categories WHERE Name = 'Спортивный инвертарь'), 50, 250, 350, 'Интер-Атлетика')
INSERT Products VALUES
('Велотренажер', (SELECT Id FROM Categories WHERE Name = 'Спортивный инвертарь'), 10, 45000, 55000, 'Интер-Атлетика')
--Пробуем вставить товар фирмы TurboSport
INSERT Products VALUES
('Гиря 16 кг', (SELECT Id FROM Categories WHERE Name = 'Спортивная обувь'), 15, 2500, 3700, 'TurboSport')

--Тестируем триггер №1 Sellings_INSERT (Добавление в таблицу История при добавлении в табилцу Покупки)
INSERT Sellings VALUES
((SELECT Id FROM Products WHERE Name = 'Куртка Merrel зима'), DEFAULT,
(SELECT Id FROM Salesmans WHERE FullName = 'Васильева Татьяна Петровна'), NULL),
((SELECT Id FROM Products WHERE Name = 'Полуботинки MERREL трекинговые'), DEFAULT,
(SELECT Id FROM Salesmans WHERE FullName = 'Васильева Татьяна Петровна'), (SELECT Id FROM Buyers WHERE FullName = 'Петров Петр Андреевич'))
--Тестируем триггер №6 Sellings_INSERT_3 (Скидка 15 % при сумме покупки (единоразовой) на >50000)
INSERT Sellings VALUES
((SELECT Id FROM Products WHERE Name = 'Куртка Merrel зима'), DEFAULT,
(SELECT Id FROM Salesmans WHERE FullName = 'Васильева Татьяна Петровна'), NULL),
((SELECT Id FROM Products WHERE Name = 'Велотренажер'), DEFAULT,
(SELECT Id FROM Salesmans WHERE FullName = 'Васильева Татьяна Петровна'), (SELECT Id FROM Buyers WHERE FullName = 'Петров Петр Андреевич'))
--Тестируем триггер №8 Sellings_INSERT_2 (Добавление в LastUnit если осталась последняя единца)
INSERT Sellings VALUES
((SELECT Id FROM Products WHERE Name = 'Куртка Merrel зима'), DEFAULT,
(SELECT Id FROM Salesmans WHERE FullName = 'Василюк Антонина Павловна'), (SELECT Id FROM Buyers WHERE FullName = 'Петрова Анастасия Васильевна')),
((SELECT Id FROM Products WHERE Name = 'Куртка Merrel зима'), DEFAULT,
(SELECT Id FROM Salesmans WHERE FullName = 'Петренко Антон Петрович'), (SELECT Id FROM Buyers WHERE FullName = 'Василькович Анатолий Митрофанович'))
--Тестируем триггер №2 Sellings_INSERT_4 (Добавляем в архив закончившиеся товары)
