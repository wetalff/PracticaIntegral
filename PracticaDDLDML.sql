 USE master; 
GO
ALTER DATABASE EmpresaSQL
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE EmpresaSQL;
GO

USE master; 
GO
DROP DATABASE IF EXISTS EmpresaSQL; 
GO

CREATE DATABASE EmpresaSQL; 
GO
USE EmpresaSQL; 
GO

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

