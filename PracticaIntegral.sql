USE master; 
GO
ALTER DATABASE HospitalDB
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE HospitalDB;
GO

USE master; 
GO
DROP DATABASE IF EXISTS HospitalDB; 
GO

CREATE DATABASE HospitalDB; 
GO
USE HospitalDB; 
GO

Select * from sys.databases;
go

CREATE SCHEMA Personas;
go
CREATE SCHEMA Catalogos;
go
CREATE SCHEMA Atencion;
go
CREATE SCHEMA Infraestructura;
go

create table Personas.Pacientes(
	idPaciente int identity(1,1) constraint pk_pacientes primary key(idPaciente),
	nombres nvarchar(100) not null,
	apellidos nvarchar(100) not null,
	email varchar(100) null constraint ck_email_pacientes CHECK (email like '%@%.%'),
	constraint uq_email unique (email),
	created_at datetime constraint df_created_at_pacientes default getdate(),
    updated_at datetime null,
	deleted_at datetime,
	edad int null constraint ck_edad CHECK (edad >= 0)

);

create table Catalogos.Especialidades(
	idEspecialidad int identity(1,1) constraint pk_especialidades primary key(idEspecialidad),
	nombre nvarchar(100) not null,
	created_at datetime constraint df_created_at_especialidades default getdate(),
	updated_at datetime null,
	deleted_at datetime

);

create table Personas.Medicos(
	idMedico int identity(1,1) constraint pk_medicos primary key(idMedico),
	nombres nvarchar(100) not null,
	apellidos nvarchar(100) not null,
	email varchar(100) null constraint ck_email_medicos CHECK (email like '%@%.%'),
	constraint uq_email_medicos unique (email),
	created_at datetime constraint df_created_at_medicos default getdate(),
	updated_at datetime null,
	deleted_at datetime,
	salario decimal(10,2) null constraint ck_salario CHECK (salario >= 0),
	idEspecialidad int null constraint fk_especialidad foreign key (idEspecialidad) references Catalogos.Especialidades(idEspecialidad)
);


create table Atencion.Citas(
	idCita int identity(1,1) constraint pk_citas primary key(idCita),
	idPaciente int not null constraint fk_paciente foreign key (idPaciente) references Personas.Pacientes(idPaciente),
	idMedico int not null constraint fk_medico foreign key (idMedico) references Personas.Medicos(idMedico),
	fecha datetime not null,
	motivo text null,
	created_at datetime constraint df_created_at_citas default getdate(),
	updated_at datetime null,
	deleted_at datetime
);

create table Infraestructura.Habitaciones(
	idHabitacion int identity(1,1) constraint pk_habitaciones primary key(idHabitacion),
	idPaciente int null constraint fk_paciente_habitacion foreign key (idPaciente) references Personas.Pacientes(idPaciente),
	numero int not null constraint uq_numero unique (numero),
	tipo varchar(50) not null,
	created_at datetime constraint df_created_at_habitaciones default getdate(),
	updated_at datetime null,
	deleted_at datetime
);

create table Atencion.Tratamientos(
	idTratamiento int identity(1,1) constraint pk_tratamientos primary key(idTratamiento),
	idCita int not null constraint fk_cita_tratamiento foreign key (idCita) references Atencion.Citas(idCita),
	idPaciente int not null constraint fk_paciente_tratamiento foreign key (idPaciente) references Personas.Pacientes(idPaciente),
	descripcion text not null,
	estado VARCHAR(20) COnstraint df_estado DEFAULT 'Activo',
	created_at datetime constraint df_created_at_tratamientos default getdate(),
	updated_at datetime null,
	deleted_at datetime
);

create table Catalogos.Medicamentos(
	idMedicamento int identity(1,1) constraint pk_medicamentos primary key(idMedicamento),
	idTratamiento int not null constraint fk_tratamiento_medicamento foreign key (idTratamiento) references Atencion.Tratamientos(idTratamiento),
	nombre nvarchar(100) not null,
	dosis varchar(50) not null,
	fecha_vencimiento DATE not null,
	created_at datetime constraint df_created_at_medicamentos default getdate(),
	updated_at datetime null,
	deleted_at datetime
);

-- PACIENTES
ALTER TABLE Personas.Pacientes
ADD telefono VARCHAR(20);

ALTER TABLE Personas.Pacientes
ADD direccion NVARCHAR(200);

ALTER TABLE Personas.Pacientes
ADD genero CHAR(1);

ALTER TABLE Personas.Pacientes
ADD tipo_sangre VARCHAR(5);

ALTER TABLE Personas.Pacientes
ADD fecha_nacimiento DATE;

ALTER TABLE Personas.Pacientes
ALTER COLUMN nombres NVARCHAR(150) NOT NULL;

ALTER TABLE Personas.Pacientes
ALTER COLUMN direccion NVARCHAR(300);

-- MEDICOS
ALTER TABLE Personas.Medicos
ADD experiencia INT;

ALTER TABLE Personas.Medicos
ADD turno VARCHAR(20);

ALTER TABLE Personas.Medicos
ADD observaciones NVARCHAR(500);

ALTER TABLE Personas.Medicos
DROP COLUMN observaciones;

-- CITAS
ALTER TABLE Atencion.Citas
ADD estado VARCHAR(20) DEFAULT 'Pendiente';

ALTER TABLE Atencion.Citas
ADD costo_consulta DECIMAL(8,2);

ALTER TABLE Atencion.Citas
ALTER COLUMN costo_consulta DECIMAL(10,2);

-- HABITACIONES
ALTER TABLE Infraestructura.Habitaciones
ADD disponibilidad BIT DEFAULT 1;



