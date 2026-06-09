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
created_at datetime constraint df_created_at_habitaciones default getdate(),
updated_at datetime null,
deleted_at datetime
);

Create table Usuario.TCargo(
nCargoID int identity(1,1) Constraint pk_nCarID primary key,
cNombreCargo Nvarchar(100) Not null constraint uq_cNomCar unique,
created_at datetime constraint df_created_at_habitaciones default getdate(),
updated_at datetime null,
deleted_at datetime
);

Create table Usuario.TEmpleado(
nEmpleadoID int identity(1,1) Constraint pk_EmpID primary key,
cNIF char(14) constraint uq_NIF unique,
cNombre Nvarchar(50) Not null,
cApellido Nvarchar(50) Not null,
nDepartamentoID int null constraint fk_nDEPID foreign key (nDepartamentoID) references Administracion.TDepartamento(nDepartamentoID),
nCargoID int null constraint fk_nCARID foreign key (nCargoID) references Usuario.TCargo(nCargoID),
dFechaContratacion datetime not null constraint df_dFecCont default getdate(),
nSalario decimal(10,2) null constraint ck_salario CHECK (salario >300),
created_at datetime constraint df_created_at_habitaciones default getdate(),
updated_at datetime null,
deleted_at datetime);

Create table Administracion.TProyecto(
TProyectoID int identity(1,1) constraint pk_Pro primary key,
cNombre Nvarchar(100) not null,
dFechaInicio datetime not null constraint df_FeIni default getdate(),
dFechaFinalizacion datetime null,
);

CREATE TABLE TEmpleadoProyecto (
    nEmpleadoID INT,
    nProyectoID INT,
    dFechaAsignacion DATE constraint df_dFeAsi DEFAULT GETDATE(),
    COnstraint pk_EmpPro PRIMARY KEY (nEmpleadoID, nProyectoID), 
    Constraint fk_empleID FOREIGN KEY (nEmpleadoID) REFERENCES Usuario.TEmpleado(nEmpleadoID) ON DELETE CASCADE,
    Constraint fk_proyID FOREIGN KEY (nProyectoID) REFERENCES Administracion.TProyecto(TProyectoID) ON DELETE CASCADE
);

Alter table Usuario.TEmpleado
Add cEmail Nvarchar(100) not null constraint uq_cEmail unique;

Alter table Usuario.TEmpleado
Add cTelefono varchar(20) not null ;

Alter table Usuario.TEmpleado
alter column cNombre Nvarchar(100) not null;

Alter table Usuario.TEmpleado
alter column cApellido Nvarchar(100) not null;

Alter table Usuario.TEmpleado
Add cDireccion navarchar(200);

Alter table Usuario.TEmpleado
Add Edad int not null constraint ck_Edad CHeck(Edad between 18 and 65);




