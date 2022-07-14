--БД "Hospital" https://github.com/Rhoxolan/DBT-MS_SQL_Server_Course/blob/main/21.06.2022/SQLQuery_PW_21.06.2022.sql

USE Hospital

--Дополняем БД

ALTER TABLE DoctorsExaminations
ADD DiseasID INT NOT NULL REFERENCES Diseases(Id) DEFAULT 1

CREATE TABLE Interns
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DoctorId INT NOT NULL REFERENCES Doctors(Id),
)

Insert Interns VALUES
((SELECT Id FROM Doctors WHERE Name = 'Николай Николаевич')),
((SELECT Id FROM Doctors WHERE Name = 'Василий Андреевич')),
((SELECT Id FROM Doctors WHERE Name = 'Петр Алексеевич'))

CREATE TABLE Professors
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
DoctorId INT NOT NULL REFERENCES Doctors(Id),
)

Insert Professors VALUES
((SELECT Id FROM Doctors WHERE Name = 'Василий Павлович')),
((SELECT Id FROM Doctors WHERE Name = 'Петр Васильевич')),
((SELECT Id FROM Doctors WHERE Name = 'Анатолий Анатольевич'))