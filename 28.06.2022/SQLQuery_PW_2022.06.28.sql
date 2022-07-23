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
BEGIN RETURN MINUTE(GETDATE())
END