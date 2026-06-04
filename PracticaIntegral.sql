
USE master; 
GO
DROP DATABASE IF EXISTS HospitalDB; 
GO

CREATE DATABASE HospitalDB; 
GO
USE HospitalDB; 
GO

Select * from sys.databases;

CREATE SCHEMA Personas;
go
CREATE SCHEMA Catalogos;
go
CREATE SCHEMA Atencion;
go
CREATE SCHEMA Infraestructura;
go

create table Personas.Pacientes(
	idPaciente int identity(1,1), constraint pk_pacientes primary key(idPaciente),
	nombres nvarchar(100) not null,
	apellidos nvarchar(100) not null,
	email varchar(100) null, constraint ck_email_pacientes CHECK (email like '%@%.%'),
	constraint uq_email unique (email),
	created_at datetime, constraint df_created_at_pacientes default getdate(),
    updated_at datetime null,
	deleted_at datetime,
	edad int null, constraint ck_edad CHECK (edad >= 0)

);

create table Personas.Medicos(
	idMedico int identity(1,1), constraint pk_medicos primary key(idMedico),
	nombres nvarchar(100) not null,
	apellidos nvarchar(100) not null,
	email varchar(100) null, constraint ck_email_medicos CHECK (email like '%@%.%'),
	constraint uq_email_medicos unique (email),
	created_at datetime, constraint df_created_at_medicos default getdate(),
	updated_at datetime null,
	deleted_at datetime,
	salario decimal(10,2) null, constraint ck_salario CHECK (salario >= 0),
	idEspecialidad int null, constraint fk_especialidad foreign key (idEspecialidad) references Catalogos.Especialidades(idEspecialidad)
);



