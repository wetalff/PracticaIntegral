 USE master;
GO

IF DB_ID('EmpresaSQL') IS NOT NULL
BEGIN
    ALTER DATABASE EmpresaSQL
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE EmpresaSQL;
END
GO

CREATE DATABASE EmpresaSQL;
GO

USE EmpresaSQL;
GO

--Parte I
Create schema Usuario;
go
Create Schema Administracion;
go


Create table Administracion.TDepartamento(
nDepartamentoID int identity(1,1) Constraint pk_nDepID primary key,
cNombreDepartamento Nvarchar(100) Not null constraint uq_cNomDep unique,
created_at datetime constraint df_createdatdep default getdate(),
updated_at datetime null,
deleted_at datetime
);

Create table Usuario.TCargo(
nCargoID int identity(1,1) Constraint pk_nCarID primary key,
cNombreCargo Nvarchar(100) Not null constraint uq_cNomCar unique,
created_at datetime constraint df_createdatcar default getdate(),
updated_at datetime null,
deleted_at datetime
);

Create table Usuario.TEmpleado(
nEmpleadoID int identity(1,1) Constraint pk_EmpID primary key,
cNIF char(50) constraint uq_NIF unique,
cNombre Nvarchar(50) Not null,
cApellido Nvarchar(50) Not null,
nDepartamentoID int null constraint fk_nDEPID foreign key (nDepartamentoID) references Administracion.TDepartamento(nDepartamentoID),
nCargoID int null constraint fk_nCARID foreign key (nCargoID) references Usuario.TCargo(nCargoID),
dFechaContratacion datetime not null constraint df_dFecCont default getdate(),
nSalario decimal(10,2) null constraint ck_salario CHECK (nSalario >300),
created_at datetime constraint df_createdatemp default getdate(),
updated_at datetime null,
deleted_at datetime);

Create table Administracion.TProyecto(
TProyectoID int identity(1,1) constraint pk_Pro primary key,
cNombre Nvarchar(100) not null,
dFechaInicio datetime not null constraint df_FeIni default getdate(),
dFechaFinalizacion datetime null,
created_at datetime constraint df_createdatpro default getdate(),
updated_at datetime null,
deleted_at datetime
);

CREATE TABLE TEmpleadoProyecto (
    nEmpleadoID INT,
    nProyectoID INT,
    dFechaAsignacion DATE constraint df_dFeAsi DEFAULT GETDATE(),
    COnstraint pk_EmpPro PRIMARY KEY (nEmpleadoID, nProyectoID), 
    Constraint fk_empleID FOREIGN KEY (nEmpleadoID) REFERENCES Usuario.TEmpleado(nEmpleadoID) ON DELETE CASCADE,
    Constraint fk_proyID FOREIGN KEY (nProyectoID) REFERENCES Administracion.TProyecto(TProyectoID) ON DELETE CASCADE,
    created_at datetime constraint df_createdatempr default getdate(),
updated_at datetime null,
deleted_at datetime
);

-- Parte II

Alter table Usuario.TEmpleado
Add cEmail Nvarchar(100) not null constraint uq_cEmail unique;

Alter table Usuario.TEmpleado
Add cTelefono nvarchar(20) not null ;

Alter table Usuario.TEmpleado
alter column cNombre Nvarchar(100) not null;

Alter table Usuario.TEmpleado
alter column cApellido Nvarchar(100) not null;

Alter table Usuario.TEmpleado
Add cDireccion nvarchar(200);

Alter table Usuario.TEmpleado
Add Edad int not null constraint ck_Edad CHeck(Edad between 18 and 65);

Alter table Usuario.TEmpleado
Add bActivo bit constraint df_Act default 1;

Alter table Usuario.TEmpleado
drop column cDireccion

Alter table Usuario.TEmpleado
Alter column cTelefono varchar(20) not null;

Alter table Usuario.TEmpleado
add cGenero char(1) constraint ck_cGEN check(cGenero in ('M', 'F'))


Alter table Usuario.TEmpleado
Add dFechaNacimiento Datetime null;


Create table Administracion.TSucursal(
TSucursalID int identity(1,1) Constraint pk_TSu primary key,
cNombre nvarchar(100) not null,
created_at datetime constraint df_createdatSUC default getdate(),
updated_at datetime null,
deleted_at datetime
);

--Parte III

INSERT INTO Administracion.TDepartamento(cNombreDepartamento)
VALUES
('Recursos Humanos'),
('Finanzas'),
('Tecnologia'),
('Ventas'),
('Marketing');


INSERT INTO Usuario.TCargo(cNombreCargo)
VALUES
('Gerente'),
('Analista'),
('Programador'),
('Contador'),
('Asistente');

INSERT INTO Usuario.TEmpleado
(
    cNIF,
    cNombre,
    cApellido,
    nDepartamentoID,
    nCargoID,
    nSalario,
    cEmail,
    cTelefono,
    Edad,
    cGenero,
    dFechaNacimiento
)
VALUES
('001-010190-0001A','Juan','Perez',1,1,1200,'juan@empresa.com','88881111',35,'M','1990-01-01'),
('002-020291-0002B','Maria','Lopez',2,4,1000,'maria@empresa.com','88882222',34,'F','1991-02-02'),
('003-030392-0003C','Carlos','Gomez',3,3,1500,'carlos@empresa.com','88883333',33,'M','1992-03-03'),
('004-040493-0004D','Ana','Martinez',4,2,1100,'ana@empresa.com','88884444',32,'F','1993-04-04'),
('005-050594-0005E','Luis','Rodriguez',5,5,800,'luis@empresa.com','88885555',31,'M','1994-05-05'),
('006-060695-0006F','Sofia','Ruiz',1,2,950,'sofia@empresa.com','88886666',30,'F','1995-06-06'),
('007-070796-0007G','Pedro','Morales',2,3,1400,'pedro@empresa.com','88887777',29,'M','1996-07-07'),
('008-080897-0008H','Elena','Castro',3,1,2000,'elena@empresa.com','88888888',28,'F','1997-08-08'),
('009-090998-0009I','Miguel','Torres',4,5,850,'miguel@empresa.com','88999999',27,'M','1998-09-09'),
('010-101099-0010J','Laura','Vega',5,4,1050,'laura@empresa.com','88777777',26,'F','1999-10-10');

INSERT INTO Administracion.TProyecto
(
    cNombre,
    dFechaInicio,
    dFechaFinalizacion
)
VALUES
('Sistema de Inventario','2025-01-01','2025-12-31'),
('Portal Web Corporativo','2025-02-01','2025-11-30'),
('Aplicacion Movil','2025-03-01','2025-10-31');


INSERT INTO TEmpleadoProyecto
(
    nEmpleadoID,
    nProyectoID
)
VALUES
(1,1),
(2,1),
(3,1),
(4,2),
(5,2),
(6,2),
(7,3),
(8,3),
(9,3),
(10,1);

INSERT INTO Usuario.TEmpleado
(
    cNIF,
    cNombre,
    cApellido,
    nDepartamentoID,
    nCargoID,
    nSalario,
    cEmail,
    cTelefono,
    Edad,
    cGenero
)
VALUES
(
    '011-111100-0011K',
    'Ricardo',
    'Mena',
    1,
    3,
    1300,
    'ricardo@empresa.com',
    '88666666',
    25,
    'M'
);

INSERT INTO Usuario.TEmpleado
(
    cNIF,
    cNombre,
    cApellido,
    nDepartamentoID,
    nCargoID,
    nSalario,
    cEmail,
    cTelefono,
    Edad,
    cGenero
)
VALUES
(
    '012-121200-0012L',
    'Patricia',
    'Flores',
    2,
    2,
    1250,
    'patricia.flores@empresa.com',
    '88555555',
    29,
    'F'
);

INSERT INTO Usuario.TEmpleado
(
    cNIF,
    cNombre,
    cApellido,
    nDepartamentoID,
    nCargoID,
    nSalario,
    cEmail,
    cTelefono,
    Edad,
    cGenero
)
VALUES
(
    '013-131300-0013M',
    'Roberto',
    'Silva',
    3,
    1,
    1800,
    'roberto@empresa.com',
    '88444444',
    40,
    'M'
);

INSERT INTO Administracion.TSucursal(cNombre)
VALUES
('Sucursal Managua'),
('Sucursal Leon'),
('Sucursal Chinandega'),
('Sucursal Masaya'),
('Sucursal Esteli');

/*Eror de CHECK
INSERT INTO Usuario.TEmpleado
(
    --cNIF,
    cNombre,
    cApellido,
    nDepartamentoID,
    nCargoID,
    nSalario,
    cEmail,
    cTelefono,
    Edad,
    cGenero
)
VALUES
(
    '014-141400-0014N',
    'Prueba',
    'Error',
    1,
    1,
    -500,
    'error@empresa.com',
    '88333333',
    25,
    'M'
);
*/

--Parte IV

UPDATE Usuario.TEmpleado
SET nSalario = nSalario * 1.10;

UPDATE Usuario.TEmpleado
SET nSalario = nSalario * 1.20
WHERE nDepartamentoID = 3;

UPDATE Usuario.TEmpleado
SET cEmail = 'juan.perez@empresa.com'
WHERE nEmpleadoID = 1;

UPDATE Usuario.TEmpleado
SET nCargoID = 2
WHERE nEmpleadoID = 3;

UPDATE Usuario.TEmpleado
SET nDepartamentoID = 2
WHERE nEmpleadoID = 1;

UPDATE Usuario.TEmpleado
SET nDepartamentoID = 4
WHERE nEmpleadoID = 2;

UPDATE Usuario.TEmpleado
SET bActivo = 0
WHERE nSalario < 500;

UPDATE Administracion.TProyecto
SET dFechaFinalizacion = '2026-12-31'
WHERE TProyectoID = 1;

INSERT INTO TEmpleadoProyecto
( nEmpleadoID,nProyectoID)
VALUES
(11,2);

-- Parte V

DELETE FROM Usuario.TEmpleado
WHERE cNIF = '001-010190-0001A';

DELETE FROM Usuario.TEmpleado
WHERE bActivo = 0;

DELETE FROM Administracion.TProyecto
WHERE TProyectoID = 3;

DELETE FROM TEmpleadoProyecto
WHERE nEmpleadoID = 5;

DELETE FROM Administracion.TDepartamento
WHERE nDepartamentoID = 5
AND NOT EXISTS
(
    SELECT 1
    FROM Usuario.TEmpleado
    WHERE nDepartamentoID = 5
);

-- Parte VI
SELECT *
FROM Usuario.TEmpleado
ORDER BY cApellido;

SELECT *
FROM Usuario.TEmpleado
WHERE nSalario > 1000;

SELECT *
FROM Usuario.TEmpleado
WHERE bActivo = 1;

SELECT *
FROM Usuario.TEmpleado
WHERE YEAR(dFechaContratacion) = YEAR(GETDATE());

SELECT E.cNombre,
       E.cApellido,
       D.cNombreDepartamento
FROM Usuario.TEmpleado E
INNER JOIN Administracion.TDepartamento D
ON E.nDepartamentoID = D.nDepartamentoID;

SELECT E.cNombre,
       E.cApellido,
       C.cNombreCargo
FROM Usuario.TEmpleado E
INNER JOIN Usuario.TCargo C
ON E.nCargoID = C.nCargoID;

SELECT E.cNombre,
       E.cApellido,
       P.cNombre AS Proyecto
FROM Usuario.TEmpleado E
INNER JOIN TEmpleadoProyecto EP
ON E.nEmpleadoID = EP.nEmpleadoID
INNER JOIN Administracion.TProyecto P
ON EP.nProyectoID = P.TProyectoID;

SELECT D.cNombreDepartamento,
       COUNT(E.nEmpleadoID) AS CantidadEmpleados
FROM Administracion.TDepartamento D
LEFT JOIN Usuario.TEmpleado E
ON D.nDepartamentoID = E.nDepartamentoID
GROUP BY D.cNombreDepartamento;

SELECT D.cNombreDepartamento,
       AVG(E.nSalario) AS SalarioPromedio
FROM Administracion.TDepartamento D
INNER JOIN Usuario.TEmpleado E
ON D.nDepartamentoID = E.nDepartamentoID
GROUP BY D.cNombreDepartamento;

SELECT D.cNombreDepartamento,
       MAX(E.nSalario) AS SalarioMaximo,
       MIN(E.nSalario) AS SalarioMinimo
FROM Administracion.TDepartamento D
INNER JOIN Usuario.TEmpleado E
ON D.nDepartamentoID = E.nDepartamentoID
GROUP BY D.cNombreDepartamento;

SELECT P.cNombre,
       COUNT(EP.nEmpleadoID) AS CantidadEmpleados
FROM Administracion.TProyecto P
INNER JOIN TEmpleadoProyecto EP
ON P.TProyectoID = EP.nProyectoID
GROUP BY P.cNombre
HAVING COUNT(EP.nEmpleadoID) > 2;

SELECT *
FROM Usuario.TEmpleado
WHERE cApellido LIKE 'G%';

SELECT *
FROM Usuario.TEmpleado
ORDER BY nSalario DESC;

SELECT TOP 3 *
FROM Usuario.TEmpleado
ORDER BY nSalario DESC;

SELECT *
FROM Usuario.TEmpleado
WHERE Edad BETWEEN 25 AND 40;

SELECT COUNT(*) AS TotalEmpleadosActivos
FROM Usuario.TEmpleado
WHERE bActivo = 1;

SELECT COUNT(*) AS TotalProyectos
FROM Administracion.TProyecto;

-- Desafios adicionales
CREATE TABLE TCliente(
    nClienteID INT IDENTITY(1,1) CONSTRAINT pk_Cliente PRIMARY KEY,
    cCedula VARCHAR(20) NOT NULL CONSTRAINT uq_ClienteCedula UNIQUE,
    cNombre NVARCHAR(100) NOT NULL,
    cApellido NVARCHAR(100) NOT NULL,
    cEmail NVARCHAR(100) CONSTRAINT uq_ClienteEmail UNIQUE,
    cTelefono VARCHAR(20) NOT NULL,
    cDireccion NVARCHAR(200) NULL,
    bActivo BIT NOT NULL CONSTRAINT df_ClienteActivo DEFAULT 1,
    created_at DATETIME CONSTRAINT df_ClienteCreated DEFAULT GETDATE()
);

CREATE TABLE TVenta(
    nVentaID INT IDENTITY(1,1) CONSTRAINT pk_Venta PRIMARY KEY,
    nClienteID INT NOT NULL,
    dFechaVenta DATETIME NOT NULL CONSTRAINT df_FechaVenta DEFAULT GETDATE(),
    nMonto DECIMAL(10,2) NOT NULL CONSTRAINT ck_Monto CHECK(nMonto > 0),
    cDescripcion NVARCHAR(200),
    CONSTRAINT fk_VentaCliente FOREIGN KEY(nClienteID)
    REFERENCES TCliente(nClienteID)
);

INSERT INTO TCliente(cCedula,cNombre,cApellido,cEmail,cTelefono,cDireccion)
VALUES
('001','Juan','Perez','juan1@gmail.com','80000001','Managua'),
('002','Maria','Lopez','maria2@gmail.com','80000002','Leon'),
('003','Carlos','Gomez','carlos3@gmail.com','80000003','Masaya'),
('004','Ana','Ruiz','ana4@gmail.com','80000004','Granada'),
('005','Luis','Torres','luis5@gmail.com','80000005','Esteli'),
('006','Pedro','Morales','pedro6@gmail.com','80000006','Rivas'),
('007','Sofia','Castro','sofia7@gmail.com','80000007','Boaco'),
('008','Elena','Silva','elena8@gmail.com','80000008','Jinotega'),
('009','Miguel','Vega','miguel9@gmail.com','80000009','Chinandega'),
('010','Laura','Flores','laura10@gmail.com','80000010','Matagalpa'),
('011','Roberto','Mena','roberto11@gmail.com','80000011','Managua'),
('012','Patricia','Rojas','patricia12@gmail.com','80000012','Leon'),
('013','Ricardo','Diaz','ricardo13@gmail.com','80000013','Masaya'),
('014','Gabriela','Perez','gabriela14@gmail.com','80000014','Granada'),
('015','Andres','Gonzalez','andres15@gmail.com','80000015','Esteli'),
('016','Carmen','Martinez','carmen16@gmail.com','80000016','Rivas'),
('017','Jose','Herrera','jose17@gmail.com','80000017','Boaco'),
('018','Daniela','Ramirez','daniela18@gmail.com','80000018','Jinotega'),
('019','Fernando','Navarro','fernando19@gmail.com','80000019','Chinandega'),
('020','Valeria','Ortiz','valeria20@gmail.com','80000020','Matagalpa');

INSERT INTO TVenta(nClienteID,dFechaVenta,nMonto,cDescripcion)
VALUES
(1,'2025-01-05',100,'Venta 1'),
(2,'2025-01-06',120,'Venta 2'),
(3,'2025-01-07',140,'Venta 3'),
(4,'2025-01-08',160,'Venta 4'),
(5,'2025-01-09',180,'Venta 5'),
(6,'2025-01-10',200,'Venta 6'),
(7,'2025-01-11',220,'Venta 7'),
(8,'2025-01-12',240,'Venta 8'),
(9,'2025-01-13',260,'Venta 9'),
(10,'2025-01-14',280,'Venta 10'),
(11,'2025-02-01',300,'Venta 11'),
(12,'2025-02-02',320,'Venta 12'),
(13,'2025-02-03',340,'Venta 13'),
(14,'2025-02-04',360,'Venta 14'),
(15,'2025-02-05',380,'Venta 15'),
(16,'2025-02-06',400,'Venta 16'),
(17,'2025-02-07',420,'Venta 17'),
(18,'2025-02-08',440,'Venta 18'),
(19,'2025-02-09',460,'Venta 19'),
(20,'2025-02-10',480,'Venta 20'),
(1,'2025-03-01',500,'Venta 21'),
(2,'2025-03-02',520,'Venta 22'),
(3,'2025-03-03',540,'Venta 23'),
(4,'2025-03-04',560,'Venta 24'),
(5,'2025-03-05',580,'Venta 25'),
(6,'2025-03-06',600,'Venta 26'),
(7,'2025-03-07',620,'Venta 27'),
(8,'2025-03-08',640,'Venta 28'),
(9,'2025-03-09',660,'Venta 29'),
(10,'2025-03-10',680,'Venta 30'),
(11,'2025-04-01',700,'Venta 31'),
(12,'2025-04-02',720,'Venta 32'),
(13,'2025-04-03',740,'Venta 33'),
(14,'2025-04-04',760,'Venta 34'),
(15,'2025-04-05',780,'Venta 35'),
(16,'2025-04-06',800,'Venta 36'),
(17,'2025-04-07',820,'Venta 37'),
(18,'2025-04-08',840,'Venta 38'),
(19,'2025-04-09',860,'Venta 39'),
(20,'2025-04-10',880,'Venta 40'),
(1,'2025-05-01',900,'Venta 41'),
(2,'2025-05-02',920,'Venta 42'),
(3,'2025-05-03',940,'Venta 43'),
(4,'2025-05-04',960,'Venta 44'),
(5,'2025-05-05',980,'Venta 45'),
(6,'2025-05-06',1000,'Venta 46'),
(7,'2025-05-07',1020,'Venta 47'),
(8,'2025-05-08',1040,'Venta 48'),
(9,'2025-05-09',1060,'Venta 49'),
(10,'2025-05-10',1080,'Venta 50');

UPDATE TVenta
SET nMonto = nMonto * 1.10
WHERE nMonto < 500;

DELETE FROM TCliente
WHERE nClienteID NOT IN
(
    SELECT DISTINCT nClienteID
    FROM TVenta
);

SELECT TOP 5
    C.nClienteID,
    C.cNombre,
    C.cApellido,
    SUM(V.nMonto) AS TotalCompras
FROM TCliente C
INNER JOIN TVenta V
ON C.nClienteID = V.nClienteID
GROUP BY C.nClienteID,C.cNombre,C.cApellido
ORDER BY TotalCompras DESC;

SELECT
    YEAR(dFechaVenta) AS Anio,
    MONTH(dFechaVenta) AS Mes,
    SUM(nMonto) AS TotalVentas
FROM TVenta
GROUP BY YEAR(dFechaVenta),MONTH(dFechaVenta)
ORDER BY Anio,Mes;

SELECT
    C.nClienteID,
    C.cNombre,
    C.cApellido,
    AVG(V.nMonto) AS PromedioCompras
FROM TCliente C
INNER JOIN TVenta V
ON C.nClienteID = V.nClienteID
GROUP BY C.nClienteID,C.cNombre,C.cApellido;

SELECT
    C.cNombre + ' ' + C.cApellido AS Cliente,
    V.nVentaID,
    V.dFechaVenta,
    V.nMonto,
    E.cNombre + ' ' + E.cApellido AS Empleado
FROM TCliente C
INNER JOIN TVenta V
ON C.nClienteID = V.nClienteID
INNER JOIN Usuario.TEmpleado E
ON E.nEmpleadoID = ((V.nVentaID - 1) % 10) + 1;


-- Parte VII
ALTER TABLE Usuario.TEmpleado
DROP CONSTRAINT ck_Edad;

ALTER TABLE Usuario.TEmpleado
DROP CONSTRAINT uq_cEmail;

ALTER TABLE Usuario.TEmpleado
ADD CONSTRAINT ck_Edad
CHECK (Edad BETWEEN 18 AND 65);

ALTER TABLE Usuario.TEmpleado
ADD CONSTRAINT uq_cEmail
UNIQUE (cEmail);

DROP TABLE TEmpleadoProyecto;

DROP TABLE Administracion.TProyecto;

DROP TABLE Usuario.TEmpleado;

DROP TABLE Usuario.TCargo;

DROP TABLE Administracion.TDepartamento;

DROP TABLE Administracion.TSucursal;

USE master;
GO

ALTER DATABASE EmpresaSQL
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE EmpresaSQL;
GO



