USE SportShop

--1. Забороніть користувачеві з логіном Марк отримувати інформацію про продавців;
DENY SELECT ON OBJECT::Salesmans TO Mark

SELECT * FROM Products
SELECT * FROM Salesmans

--2. Дозвольте користувачеві з логіном Boris отримувати інформацію тільки про продавців;GRANT SELECT ON OBJECT::Salesmans TO Boris

SELECT * FROM Products
SELECT * FROM Salesmans

--3. Надайте повний доступ до бази даних користувачеві з логіном Irina;
ALTER SERVER ROLE [sysadmin] ADD MEMBER [Irina]
GO

EXEC sp_addrolemember 'db_owner', 'Irina'

--4. Надайте доступ тільки на читання таблиць з інформацією про продавців, товарах в наявності користувачеві з логіном Констянтин.
GRANT SELECT ON OBJECT::Salesmans TO Boris
GRANT SELECT ON OBJECT::Products TO Boris