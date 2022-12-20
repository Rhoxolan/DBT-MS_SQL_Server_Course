-- Задание 1

--1. Предоставьте пользователю с логином Марк возможность выполнять любые операции на уровне сервера
CREATE LOGIN [Mark] WITH PASSWORD=N'RFYvORjHV7n7xseYVfjVmP0JZj5AEtvB9QZkWYddp3w=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO

ALTER LOGIN [Mark] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [Mark]
GO

--2. Предоставьте пользователю с логином Ирина возможность создавать базы данных
CREATE LOGIN [Irina] WITH PASSWORD=N'VN0M1Enc0iYH5E66bSCmtA5SgkbBmn9LsCLXZd1vOyA=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

ALTER LOGIN [Irina] DISABLE
GO

ALTER SERVER ROLE [dbcreator] ADD MEMBER [Irina]
GO

--3. Предоставьте пользователям с логинами Борис, Александр, Алексей, Ольга, Елена возможность выполнять любые операции на уровне сервера
CREATE LOGIN [Boris] WITH PASSWORD=N'GJChrcY/O7hOo1tqW53jg8Mid6jRI8RxgSl0ESM6LpQ=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

ALTER LOGIN [Boris] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [Boris]
GO

CREATE LOGIN [Alexandr] WITH PASSWORD=N'4JwUVRTZj6MZJeWDjlKjfy1UCzDbKd/ATHL0dx7gmKw=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

ALTER LOGIN [Alexandr] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [Alexandr]
GO

CREATE LOGIN [Alexey] WITH PASSWORD=N'eSFsg5Udh93P29ejjcVrWi1dlLCuhFIUnlpPuj6FK18=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

ALTER LOGIN [Alexey] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [Alexey]
GO

CREATE LOGIN [Olga] WITH PASSWORD=N'Hs2W61xSH1hwdXhgO+TyCGjajt4k80ZSZcm393YKd+A=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

ALTER LOGIN [Olga] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [Olga]
GO

CREATE LOGIN [Elena] WITH PASSWORD=N'wSv6kZyr9UfIApufVHnkIxtDbwUUEbnNVJHDxsTQI+A=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=ON, CHECK_POLICY=ON
GO

ALTER LOGIN [Elena] DISABLE
GO

ALTER SERVER ROLE [sysadmin] ADD MEMBER [Elena]
GO

-- Задание 2. Выполните задания используя хранимые процедуры или запросы

--1. Показать список серверных ролей
SELECT * FROM sys.server_principals

--2. Показать разрешения серверных ролей
SELECT * FROM sys.fn_builtin_permissions('SERVER') ORDER BY permission_name;

--3. Показать членов серверной роли sysadmin
SELECT SP.name										 --Another version: https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-server-role-members-transact-sql?view=sql-server-ver16
FROM sys.server_principals SP
JOIN sys.server_role_members SRM ON SRM.member_principal_id = SP.principal_id
JOIN sys.server_principals SP2 ON SP2.principal_id = SRM.role_principal_id AND SP2.name = 'sysadmin'

-- 4. Показать членов серверной роли dbcreator
SELECT SP.name
FROM sys.server_principals SP
JOIN sys.server_role_members SRM ON SRM.member_principal_id = SP.principal_id
JOIN sys.server_principals SP2 ON SP2.principal_id = SRM.role_principal_id AND SP2.name = 'dbcreator'

-- 5. Проверить является ли пользователь с логином Марк членом серверной роли sysadmin.
IF EXISTS (
SELECT SP.name
FROM sys.server_principals SP
JOIN sys.server_role_members SRM ON SRM.member_principal_id = SP.principal_id
JOIN sys.server_principals SP2 ON SP2.principal_id = SRM.role_principal_id AND SP2.name = 'sysadmin'
WHERE SP.name = 'Mark'
)
PRINT 'YES'

-- Задание 3. Для базы данных «Продажи» из практического задания модуля «Работа с
-- таблицами и представлениями в MS SQL Server» выполните набор действий:

--1. Предоставьте пользователю с логином Марк полный доступ к базе данных
CREATE USER [Mark] FOR LOGIN [Mark] WITH DEFAULT_SCHEMA=[dbo]
GO

--2. Разрешите пользователю с логином Ирина читать данные из всех таблиц
USE SportShop

CREATE USER [Irina] FOR LOGIN [Irina]

EXEC sp_addrolemember 'db_datareader', 'Irina'

--3. Запретите пользователю с логином Ирина запись данных во все таблицы
EXEC sp_droprolemember 'db_datawriter', 'Irina'

--4. Разрешите пользователю с логином Boris создавать резервные копии базы данных
CREATE USER [Boris] FOR LOGIN [Boris]
EXEC sp_addrolemember 'db_backupoperator', 'Boris'

--5. Предоставьте пользователю с логином Alexey возможность создавать объекты внутри базы данных (таблицы, представления и т.д.).
CREATE USER [Alexey] FOR LOGIN [Alexey]
EXEC sp_addrolemember 'db_ddladmin', 'Alexey'
