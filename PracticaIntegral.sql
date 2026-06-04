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

-- MODULO IV

-- Tabla temporal
CREATE TABLE #Temporal(
    id INT
);

DROP TABLE #Temporal;

-- Eliminar CHECK
ALTER TABLE Personas.Pacientes
DROP CONSTRAINT ck_edad;

-- Eliminar UNIQUE
ALTER TABLE Personas.Pacientes
DROP CONSTRAINT uq_email;

ALTER TABLE Personas.Medicos
ADD experiencia12 INT;

-- Eliminar columna
ALTER TABLE Personas.Medicos
DROP COLUMN experiencia12;

-- Tabla de pruebas
CREATE TABLE Pruebas(
    id INT
);

DROP TABLE Pruebas;

-- Auditoria
CREATE TABLE Auditoria(
    id INT IDENTITY PRIMARY KEY,
    descripcion VARCHAR(200)
);

DROP TABLE Auditoria;

-- Logs
CREATE TABLE Logs(
    id INT IDENTITY PRIMARY KEY,
    mensaje VARCHAR(200)
);

DROP TABLE dbo.Logs;

-- Eliminar FK
ALTER TABLE Catalogos.Medicamentos
DROP CONSTRAINT fk_tratamiento_medicamento;

-- MedicamentosPrueba
CREATE TABLE MedicamentosPrueba(
    id INT
);

DROP TABLE MedicamentosPrueba;

-- Base de datos de pruebas
CREATE DATABASE HospitalDB_Prueba;
GO

DROP DATABASE HospitalDB_Prueba;
GO


--Modulo V
INSERT INTO Catalogos.Especialidades(nombre)
VALUES
('Cardiología'),
('Pediatría'),
('Neurología'),
('Dermatología'),
('Traumatología');

INSERT INTO Personas.Medicos
(nombres,apellidos,email,salario,idEspecialidad,experiencia,turno)
VALUES
('Juan','Pérez','juan.perez@hospital.com',1200,1,5,'Mañana'),
('Ana','López','ana.lopez@hospital.com',1300,2,8,'Tarde'),
('Carlos','Ruiz','carlos.ruiz@hospital.com',1400,3,10,'Noche'),
('María','Gómez','maria.gomez@hospital.com',1250,4,4,'Mañana'),
('Pedro','Castillo','pedro.castillo@hospital.com',1500,5,12,'Tarde'),
('Sofía','Martínez','sofia.martinez@hospital.com',1350,1,7,'Noche'),
('Luis','Torres','luis.torres@hospital.com',1450,2,9,'Mañana'),
('Elena','Morales','elena.morales@hospital.com',1550,3,15,'Tarde'),
('Jorge','Silva','jorge.silva@hospital.com',1600,4,18,'Noche'),
('Marta','Rojas','marta.rojas@hospital.com',1700,5,20,'Mañana');



INSERT INTO Personas.Pacientes
(nombres,apellidos,email,edad,telefono,direccion,genero,tipo_sangre,fecha_nacimiento)
VALUES
('Alberto','Ramírez','alberto@gmail.com',25,'88880001','Managua','M','O+','2001-01-01'),
('Lucía','Pérez','lucia@gmail.com',30,'88880002','León','F','A+','1996-02-15'),
('Mario','Gómez','mario@gmail.com',22,'88880003','Masaya','M','B+','2004-03-12'),
('Paula','Díaz','paula@gmail.com',27,'88880004','Granada','F','AB+','1999-04-22'),
('Kevin','López','kevin@gmail.com',35,'88880005','Chinandega','M','O-','1991-05-10'),
('Rosa','Ruiz','rosa@gmail.com',29,'88880006','Estelí','F','A-','1997-06-18'),
('Andrés','Silva','andres@gmail.com',41,'88880007','Rivas','M','B-','1985-07-08'),
('Diana','Torres','diana@gmail.com',20,'88880008','Jinotega','F','O+','2006-08-09'),
('José','Mena','jose@gmail.com',32,'88880009','Boaco','M','A+','1994-09-11'),
('Laura','Castillo','laura@gmail.com',28,'88880010','Matagalpa','F','AB-','1998-10-10'),
('David','Rivas','david@gmail.com',45,'88880011','Managua','M','O+','1981-11-02'),
('Patricia','Rojas','patricia@gmail.com',38,'88880012','León','F','B+','1988-12-03'),
('Ricardo','Flores','ricardo@gmail.com',31,'88880013','Masaya','M','A-','1995-01-14'),
('Carmen','Vega','carmen@gmail.com',24,'88880014','Granada','F','O-','2002-02-16'),
('Miguel','Mora','miguel@gmail.com',36,'88880015','Rivas','M','AB+','1990-03-18'),
('Silvia','Navarro','silvia@gmail.com',27,'88880016','Estelí','F','A+','1999-04-21'),
('Oscar','Reyes','oscar@gmail.com',40,'88880017','Boaco','M','B+','1986-05-25'),
('Julia','Blandón','julia@gmail.com',26,'88880018','Jinotepe','F','O+','2000-06-30'),
('Fernando','Ortiz','fernando@gmail.com',34,'88880019','Matagalpa','M','AB-','1992-07-07'),
('Teresa','Salazar','teresa@gmail.com',23,'88880020','Managua','F','A-','2003-08-11');


Select * from Personas.Medicos;

INSERT INTO Atencion.Citas
(idPaciente,idMedico,fecha,motivo,estado,costo_consulta)
VALUES
(1,1,GETDATE(),'Control general','Pendiente',25.00),
(2,2,DATEADD(DAY,1,GETDATE()),'Consulta pediátrica','Pendiente',20.00),
(3,3,DATEADD(DAY,2,GETDATE()),'Dolor de cabeza','Confirmada',30.00),
(4,4,DATEADD(DAY,3,GETDATE()),'Alergia','Pendiente',25.00),
(5,5,DATEADD(DAY,4,GETDATE()),'Fractura','Pendiente',40.00),
(6,6,DATEADD(DAY,5,GETDATE()),'Chequeo','Pendiente',25.00),
(7,7,DATEADD(DAY,6,GETDATE()),'Consulta','Confirmada',20.00),
(8,8,DATEADD(DAY,7,GETDATE()),'Dermatitis','Pendiente',30.00),
(9,9,DATEADD(DAY,8,GETDATE()),'Control','Pendiente',25.00),
(10,10,DATEADD(DAY,9,GETDATE()),'Chequeo','Pendiente',20.00),
(11,1,DATEADD(DAY,10,GETDATE()),'Seguimiento','Confirmada',25.00),
(12,2,DATEADD(DAY,11,GETDATE()),'Consulta','Pendiente',20.00),
(13,3,DATEADD(DAY,12,GETDATE()),'Migraña','Pendiente',30.00),
(14,4,DATEADD(DAY,13,GETDATE()),'Control','Pendiente',25.00),
(15,5,DATEADD(DAY,14,GETDATE()),'Revisión','Pendiente',40.00);


INSERT INTO Infraestructura.Habitaciones
(idPaciente,numero,tipo,disponibilidad)
VALUES
(1,101,'Individual',0),
(2,102,'Individual',0),
(3,103,'Doble',0),
(4,104,'Doble',0),
(5,105,'Suite',0),
(NULL,106,'Individual',1),
(NULL,107,'Individual',1),
(NULL,108,'Doble',1),
(NULL,109,'Doble',1),
(NULL,110,'Suite',1);

INSERT INTO Atencion.Tratamientos
(idCita,idPaciente,descripcion,estado)
VALUES
(1,1,'Tratamiento cardíaco','Activo'),
(2,2,'Control pediátrico','Activo'),
(3,3,'Tratamiento neurológico','Activo'),
(4,4,'Tratamiento dermatológico','Activo'),
(5,5,'Rehabilitación','Activo'),
(6,6,'Tratamiento general','Finalizado'),
(7,7,'Control médico','Finalizado'),
(8,8,'Aplicación de medicamentos','Finalizado'),
(9,9,'Seguimiento clínico','Finalizado'),
(10,10,'Observación médica','Finalizado');


INSERT INTO Catalogos.Medicamentos
(idTratamiento,nombre,dosis,fecha_vencimiento)
VALUES
(1,'Paracetamol','500 mg','2027-01-15'),
(1,'Ibuprofeno','400 mg','2027-02-10'),
(2,'Amoxicilina','500 mg','2027-03-05'),
(2,'Loratadina','10 mg','2027-04-20'),
(3,'Omeprazol','20 mg','2027-05-18'),
(3,'Diclofenaco','50 mg','2027-06-11'),
(4,'Metformina','850 mg','2027-07-01'),
(4,'Losartan','50 mg','2027-08-08'),
(5,'Atorvastatina','20 mg','2027-09-12'),
(5,'Aspirina','100 mg','2027-10-15'),
(6,'Vitamina C','500 mg','2027-11-20'),
(6,'Calcio','600 mg','2027-12-01'),
(7,'Hierro','300 mg','2028-01-01'),
(7,'Azitromicina','500 mg','2028-02-01'),
(8,'Cefalexina','500 mg','2028-03-01'),
(8,'Salbutamol','2 mg','2028-04-01'),
(9,'Prednisona','5 mg','2028-05-01'),
(9,'Enalapril','10 mg','2028-06-01'),
(10,'Clonazepam','2 mg','2028-07-01'),
(10,'Insulina','10 UI','2028-08-01');

--Modulo IV
-- Actualizar teléfono de un paciente
UPDATE Personas.Pacientes
SET telefono = '88889999'
WHERE idPaciente = 1;

-- Actualizar dirección de un paciente
UPDATE Personas.Pacientes
SET direccion = 'Carretera a Masaya, Managua'
WHERE idPaciente = 2;

-- Actualizar salario de un médico
UPDATE Personas.Medicos
SET salario = 1800.00
WHERE idMedico = 1;

-- Actualizar turno de un médico
UPDATE Personas.Medicos
SET turno = 'Noche'
WHERE idMedico = 2;

-- Cambiar estado de una cita
UPDATE Atencion.Citas
SET estado = 'Completada'
WHERE idCita = 1;

-- Actualizar costo de consulta
UPDATE Atencion.Citas
SET costo_consulta = 35.00
WHERE idCita = 2;

-- Actualizar nombre de especialidad
UPDATE Catalogos.Especialidades
SET nombre = 'Cardiología Intervencionista'
WHERE idEspecialidad = 1;

-- Actualizar disponibilidad de habitación
UPDATE Infraestructura.Habitaciones
SET disponibilidad = 0
WHERE idHabitacion = 6;

-- Actualizar tratamiento activo
UPDATE Atencion.Tratamientos
SET estado = 'Finalizado'
WHERE idTratamiento = 1;

-- Actualizar medicamento
UPDATE Catalogos.Medicamentos
SET dosis = '750 mg'
WHERE idMedicamento = 1;

-- Actualizar correo de paciente
UPDATE Personas.Pacientes
SET email = 'alberto.actualizado@gmail.com'
WHERE idPaciente = 1;

-- Actualizar correo de médico
UPDATE Personas.Medicos
SET email = 'juan.actualizado@hospital.com'
WHERE idMedico = 1;

-- Actualizar fecha de cita
UPDATE Atencion.Citas
SET fecha = DATEADD(DAY, 30, GETDATE())
WHERE idCita = 3;

-- Actualizar experiencia del médico
UPDATE Personas.Medicos
SET experiencia = 8
WHERE idMedico = 1;

-- Actualizar tipo de sangre
UPDATE Personas.Pacientes
SET tipo_sangre = 'AB+'
WHERE idPaciente = 5;

Select * from Personas.Pacientes
WHERE idPaciente = 5;
--MODULO VII
-- Eliminar un paciente específico
--DELETE FROM Personas.Pacientes
--WHERE idPaciente = 5;

-- Eliminar una cita
--DELETE FROM Atencion.Citas
--WHERE idCita = 3;

-- Eliminar un medicamento
DELETE FROM Catalogos.Medicamentos
WHERE idMedicamento = 8;

-- Eliminar una habitación
DELETE FROM Infraestructura.Habitaciones
WHERE idHabitacion = 4;

-- Eliminar un tratamiento
DELETE FROM Atencion.Tratamientos
WHERE idTratamiento = 2;

-- Eliminar citas canceladas
DELETE FROM Atencion.Citas
WHERE estado = 'Cancelada';

-- Eliminar pacientes sin citas
DELETE FROM Personas.Pacientes
WHERE NOT EXISTS (
    SELECT 1
    FROM Atencion.Citas C
    WHERE C.idPaciente = Personas.Pacientes.idPaciente
);

-- Eliminar habitaciones vacías
DELETE FROM Infraestructura.Habitaciones
WHERE disponibilidad = 1
  AND idPaciente IS NULL;

-- Eliminar medicamentos vencidos
DELETE FROM Catalogos.Medicamentos
WHERE fecha_vencimiento < CAST(GETDATE() AS DATE);

-- Eliminar registros de prueba
DELETE FROM Personas.Pacientes
WHERE nombres = 'Prueba';

DELETE FROM Personas.Medicos
WHERE nombres = 'Prueba';

DELETE FROM Catalogos.Medicamentos
WHERE nombre = 'Medicamento Prueba';

--MODULO VIII

-- Mostrar todos los pacientes
SELECT *
FROM Personas.Pacientes;

-- Mostrar todos los médicos
SELECT *
FROM Personas.Medicos;

-- Mostrar todas las especialidades
SELECT *
FROM Catalogos.Especialidades;

-- Mostrar todas las citas
SELECT *
FROM Atencion.Citas;

-- Mostrar pacientes ordenados por apellido
SELECT *
FROM Personas.Pacientes
ORDER BY apellidos ASC;

-- Mostrar médicos ordenados por salario
SELECT *
FROM Personas.Medicos
ORDER BY salario DESC;

-- Mostrar citas del día actual
SELECT *
FROM Atencion.Citas
WHERE CAST(fecha AS DATE) = CAST(GETDATE() AS DATE);

-- Mostrar habitaciones disponibles
SELECT *
FROM Infraestructura.Habitaciones
WHERE disponibilidad = 1;

-- Mostrar cantidad de pacientes registrados
SELECT COUNT(*) AS CantidadPacientes
FROM Personas.Pacientes;

-- Mostrar cantidad de citas por médico
SELECT
    M.idMedico,
    M.nombres,
    M.apellidos,
    COUNT(C.idCita) AS CantidadCitas
FROM Personas.Medicos M
LEFT JOIN Atencion.Citas C
    ON M.idMedico = C.idMedico
GROUP BY
    M.idMedico,
    M.nombres,
    M.apellidos
ORDER BY CantidadCitas DESC;