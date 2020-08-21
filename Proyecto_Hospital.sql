USE Master
DROP DATABASE ProyectoBases


CREATE DATABASE ProyectoBases
GO


USE ProyectoBases
GO


--TABLA PADRE ENTRE EMPLEADO Y PACIENTE-- CATALOGO DE PERSONA--


CREATE TABLE Genero(
ID_Genero VARCHAR(1) PRIMARY KEY,
NombreGenero VARCHAR(10) NOT NULL,
UNIQUE (ID_Genero, NombreGenero),
UNIQUE (NombreGenero),
CHECK(ID_Genero LIKE 'M' OR ID_Genero LIKE 'F' OR ID_Genero LIKE 'f' OR ID_Genero LIKE 'm' AND NombreGenero NOT LIKE '%[0-9@$%]%')
);
GO



CREATE TABLE Persona(
ID_Persona VARCHAR(13) PRIMARY KEY,
PrimerNombre VARCHAR(50) NOT NULL,
SegundoNombre VARCHAR(50),
PrimerApellido VARCHAR(50) NOT NULL,
SegundoApellido VARCHAR(50),
FechaNacimiento DATE NOT NULL,
E_Mail VARCHAR(150),
Num_Telefono VARCHAR(8),
Genero VARCHAR(1) NOT NULL REFERENCES Genero(ID_Genero),
Direccion VARCHAR(170) NULL,
CHECK(PrimerNombre NOT LIKE '%[0-9@$%_-]%' AND SegundoNombre NOT LIKE '%[0-9@$%_-]%' AND PrimerApellido NOT LIKE '%[0-9@$%_-]%' AND SegundoApellido NOT LIKE '%[0-9@$%_-]%'
AND E_Mail LIKE '%_@_%._%' AND ID_Persona LIKE '%[0-9]%' )
);
GO




--CATALOGOS EMPLEADO--


CREATE TABLE Especialidad(
ID_Especialidad INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreEspecialidad VARCHAR(100) NOT NULL,
DescripcionEspecialidad VARCHAR(250) NOT NULL,
UNIQUE(ID_Especialidad, NombreEspecialidad),
UNIQUE(NombreEspecialidad),
CHECK(NombreEspecialidad NOT LIKE '%[0-9@$%_-]%')
);
GO



CREATE TABLE Tipo_Servicio(
ID_Servicio VARCHAR(2) PRIMARY KEY,
NombreServicio VARCHAR(50) NOT NULL,
CHECK (NombreServicio NOT LIKE '%[0-9@$%_-]%' AND ID_Servicio LIKE '%__%'),
UNIQUE(ID_Servicio, NombreServicio),
UNIQUE(NombreServicio)
);
GO



CREATE TABLE Personal_Servicio(
ID_PServicio VARCHAR(2),
NombrePersonalServicio VARCHAR(50) NOT NULL,
ID_Servicio VARCHAR(2) NOT NULL REFERENCES Tipo_Servicio(ID_Servicio),
PRIMARY KEY(ID_PServicio, ID_Servicio),
UNIQUE(ID_PServicio, NombrePersonalServicio, ID_Servicio),
UNIQUE(ID_PServicio, NombrePersonalServicio),
UNIQUE(NombrePersonalServicio),
CHECK (NombrePersonalServicio NOT LIKE '%[0-9@$%_-]%' AND ID_PServicio LIKE '%__%')

);
GO



CREATE TABLE Area(
ID_Area INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreArea VARCHAR(50) NOT NULL,
DescripcionArea VARCHAR(100) NOT NULL,
UNIQUE(ID_Area, NombreArea),
UNIQUE(NombreArea),
CHECK (NombreArea NOT LIKE '%[0-9@$%_-]%' AND DescripcionArea NOT LIKE '%[0-9@$%_-]%')
);
GO



CREATE TABLE Cargo(
ID_Cargo INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreCargo VARCHAR(50) NOT NULL,
DescripcionCargo VARCHAR(100) NOT NULL,
UNIQUE(ID_Cargo, NombreCargo),
UNIQUE(NombreCargo),
CHECK (NombreCargo NOT LIKE '%[0-9@$%_-]%' AND DescripcionCargo NOT LIKE '%[0-9@$%_-]%')
);
GO



CREATE TABLE Turno(
ID_Turno VARCHAR(1) PRIMARY KEY,
NombreTurno VARCHAR(50) NOT NULL,
HoraInicio TIME NOT NULL,
HoraFin TIME NOT NULL,
UNIQUE(ID_Turno, NombreTurno),
UNIQUE(NombreTurno),
CHECK(ID_Turno NOT LIKE '%[0-9@$%_-]%' AND NombreTurno NOT LIKE '%[0-9@$%_-]%' AND HoraInicio != HoraFin)
);
GO




--TABLAS DEPENDIENTES EMPLEADO--

CREATE TABLE Empleado_Header(
ID_Empleado VARCHAR(10) PRIMARY KEY,
ID_Persona VARCHAR(13) NOT NULL REFERENCES Persona(ID_Persona),
FechaContratacion DATE NOT NULL,
FechaDespido DATE NULL,
Empleado_Activo BIT NOT NULL,
ID_PServicio VARCHAR(2) NOT NULL,
ID_TServicio VARCHAR(2) NOT NULL REFERENCES Tipo_Servicio(ID_Servicio),
FOREIGN KEY(ID_PServicio, ID_TServicio) REFERENCES Personal_Servicio(ID_PServicio, ID_Servicio),
UNIQUE (ID_Empleado, ID_Persona),
UNIQUE(ID_Persona),
CHECK (ID_Empleado LIKE '%'+ID_TServicio+ID_PServicio+'[0-9]%' AND FechaContratacion < FechaDespido)
);
GO




CREATE TABLE Especialidad_Empleado(
ID_Especialidad INTEGER NOT NULL  REFERENCES Especialidad(ID_Especialidad),
ID_Empleado VARCHAR(10) NOT NULL REFERENCES Empleado_Header(ID_Empleado),
UNIQUE(ID_Especialidad, ID_Empleado)
);
GO



CREATE TABLE Empleado_Areas(
ID_Empleado VARCHAR(10) NOT NULL REFERENCES Empleado_Header(ID_Empleado),
ID_Area INTEGER NOT NULL REFERENCES Area(ID_Area),
PRIMARY KEY(ID_Empleado, ID_Area)
);
GO



CREATE TABLE Calendario_Turnos(
ID_Empleado VARCHAR(10) NOT NULL REFERENCES Empleado_Header(ID_Empleado),
ID_Area INTEGER NOT NULL REFERENCES Area(ID_Area),
FechaTurno DATE NOT NULL,
ID_Turno VARCHAR(1) NOT NULL REFERENCES Turno(ID_Turno),
HoraEntrada TIME NOT NULL,
HoraSalida TIME NOT NULL,
FOREIGN KEY(ID_Empleado, ID_Area) REFERENCES Empleado_Areas(ID_Empleado, ID_Area),
UNIQUE(ID_Turno,ID_Empleado,FechaTurno)
);
GO


CREATE TABLE Empleado_Cargos(
ID_Empleado VARCHAR(10) NOT NULL REFERENCES Empleado_Header(ID_Empleado),
ID_Area INTEGER NOT NULL REFERENCES Area(ID_Area),
ID_Cargo INTEGER NOT NULL REFERENCES Cargo(ID_Cargo),
FOREIGN KEY(ID_EMPLEADO, ID_AREA) REFERENCES Empleado_Areas(ID_Empleado, ID_Area),
PRIMARY KEY(ID_Empleado, ID_Area),
UNIQUE(ID_Empleado, ID_Area, ID_Cargo),
UNIQUE(ID_Area, ID_Cargo)
);
GO




---PACIENTES-------

---CATALOGOS--

CREATE TABLE Alergia(
ID_Alergia INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreAlergia VARCHAR(50) NOT NULL,
DescripcionAlergia VARCHAR(250) NOT NULL,
UNIQUE (ID_Alergia, NombreAlergia),
UNIQUE (NombreAlergia),
CHECK (NombreAlergia NOT LIKE '%[0-9@$%_-]%' AND DescripcionAlergia NOT LIKE '%[0-9@$%_-]%')
);
GO


CREATE TABLE TipoConsulta(
ID_TipoConsulta INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreTipoConsulta VARCHAR(50) NOT NULL,
PrecioConsulta DECIMAL(13,2) NOT NULL,
UNIQUE (ID_TipoConsulta, NombreTipoConsulta),
CHECK (NombreTipoConsulta NOT LIKE '%[0-9@$%_-]%')
);
GO


CREATE TABLE Enfermedad(
ID_Enfermedad INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreEnfermedad VARCHAR(50) NOT NULL
UNIQUE (ID_Enfermedad, NombreEnfermedad),
UNIQUE(NombreEnfermedad),
CHECK (NombreEnfermedad NOT LIKE '%[0-9@$%_-]%')
);
GO


CREATE TABLE Sintomas(
ID_Sintoma INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreSintoma VARCHAR(50) NOT NULL,
UNIQUE (NombreSintoma),
CHECK (NombreSintoma NOT LIKE '%[0-9@$%_-]%')
);
GO


CREATE TABLE Medicamentos(
ID_Medicamento INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreMedicamento VARCHAR(50) NOT NULL,
ComposicionMedicamento VARCHAR(100) NOT NULL,
Dosis VARCHAR(10) NOT NULL,
Codigo CHAR(100) NOT NULL,
UNIQUE (ID_Medicamento, NombreMedicamento),
UNIQUE(NombreMedicamento),
UNIQUE(Codigo),
UNIQUE(ID_Medicamento, NombreMedicamento, Codigo),
CHECK (NombreMedicamento NOT LIKE '%[0-9@$%_-]%' AND Dosis LIKE '[0-9]%[A-Z]%')
);
GO


CREATE TABLE Examenes(
ID_Examen INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreExamen VARCHAR(50) NOT NULL,
DescripcionExamen VARCHAR(250) NOT NULL
UNIQUE (ID_Examen, NombreExamen),
UNIQUE(NombreExamen),
CHECK (NombreExamen NOT LIKE '%[0-9@$%_-]%')
);
GO


CREATE TABLE Seguro(
ID_Seguro INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreSeguro VARCHAR(50) NOT NULL,
DescripcionSeguro VARCHAR(250) NOT NULL,
DescuentoSeguro INTEGER NOT NULL,
PrecioSeguro DECIMAL(13,2) NOT NULL,
UNIQUE (ID_Seguro, NombreSeguro),
UNIQUE(NombreSeguro),
CHECK (NombreSeguro NOT LIKE '%[0-9@$%_-]%' AND DescuentoSeguro <=100)
);
GO



---TABLAS DEPENDIENTES---


CREATE TABLE Expediente_Paciente(
Num_Expediente INTEGER IDENTITY(1,1) PRIMARY KEY,
ID_Persona VARCHAR(13) NOT NULL REFERENCES Persona(ID_PErsona),
FechaCreacion DATE NOT NULL,
FechaUltModificacion DATE NOT NULL,
Descripcion VARCHAR(250),
ID_Seguro INTEGER NULL REFERENCES Seguro(ID_Seguro),
UNIQUE(Num_Expediente, ID_Persona),
UNIQUE(ID_Persona)
);
GO


CREATE TABLE Consulta(
ID_Consulta INTEGER IDENTITY(1,1) PRIMARY KEY,
Num_Expediente INTEGER NOT NULL REFERENCES Expediente_Paciente(Num_Expediente),
ID_Empleado VARCHAR(10) NOT NULL REFERENCES Empleado_Header(ID_Empleado),
FechaConsulta DATE NOT NULL,
HoraConsulta TIME NOT NULL,
Observacion VARCHAR(250) NOT NULL,
ID_Area INTEGER NOT NULL REFERENCES Area(ID_Area),
ID_TipoConsulta INTEGER NOT NULL REFERENCES TipoConsulta(ID_TipoConsulta),
FOREIGN KEY(ID_Empleado, ID_Area) REFERENCES Empleado_Areas(ID_Empleado, ID_Area),
CHECK(ID_Empleado LIKE 'SDMD%')
);
GO


CREATE TABLE Recetas(
ID_Receta INTEGER IDENTITY(1,1) PRIMARY KEY,
FechaReceta DATE,
ID_Consulta INTEGER NOT NULL REFERENCES Consulta(ID_Consulta),
UNIQUE(ID_Receta, ID_Consulta)
);
GO



CREATE TABLE Instrumentos(
ID_Instrumento INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreInstrumento VARCHAR(100) NOT NULL,
DescripcionInstrumento VARCHAR(150) NOT NULL,
PrecioInstrumento DECIMAL(13,2) NOT NULL,
UNIQUE(ID_Instrumento, NombreInstrumento),
UNIQUE(NombreInstrumento),
CHECK(NombreInstrumento NOT LIKE '%[0-9@$%_-]%')
);
GO



CREATE TABLE TipoMovimiento(
ID_TipoMovimiento INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreTipoMovimiento VARCHAR(100) NOT NULL,
DescripcionMovimiento VARCHAR(150) NOT NULL,
CHECK(NombreTipoMovimiento NOT LIKE '%[0-9@$%_-]%' AND DescripcionMovimiento NOT LIKE '%[0-9@$%_-]%')
);
GO



CREATE TABLE Ficha_Instrumentos(
ID_FichaInstrumento INTEGER IDENTITY(1,1) PRIMARY KEY,
ID_Instrumento INTEGER NOT NULL REFERENCES Instrumentos(ID_Instrumento),
Fecha DATE NOT NULL,
Referencia CHAR(100) NOT NULL,
Cantidad DECIMAL(13,2) NOT NULL,
ID_TipoMovimiento INTEGER NOT NULL REFERENCES TipoMovimiento(ID_TipoMovimiento),
Entrada BIT NOT NULL,
);
GO



CREATE TABLE Ficha_Medicamentos(
ID_FichaMedicamento INTEGER IDENTITY(1,1) PRIMARY KEY,
ID_Medicamento INTEGER NOT NULL REFERENCES Medicamentos(ID_Medicamento),
Fecha DATE NOT NULL,
Referencia CHAR(100) NOT NULL,
Cantidad DECIMAL(13,2) NOT NULL,
ID_TipoMovimiento INTEGER NOT NULL REFERENCES TipoMovimiento(ID_TipoMovimiento),
Entrada BIT NOT NULL,
);
GO


CREATE TABLE Medicamentos_Recetados(
ID_Medicamento INTEGER NOT NULL REFERENCES Medicamentos(ID_Medicamento),
ID_Receta INTEGER NOT NULL REFERENCES Recetas(ID_Receta),
Dosis VARCHAR(100) NOT NULL,
Instruccion VARCHAR(100) NOT NULL,
PRIMARY KEY(ID_Medicamento, ID_Receta),
CHECK(Dosis LIKE '[0-9]%[A-Z]%')
);
GO


CREATE TABLE Examenes_Recetados(
ID_Examen INTEGER NOT NULL REFERENCES Examenes(ID_Examen),
ID_Receta INTEGER NOT NULL REFERENCES Recetas(ID_Receta),
Instruccion VARCHAR(100) NOT NULL,
PRIMARY KEY(ID_Examen, ID_Receta)
);
GO


CREATE TABLE Diagnostico(
ID_Diagnostico INTEGER IDENTITY(1,1) PRIMARY KEY,
ID_Consulta INTEGER NOT NULL REFERENCES Consulta(ID_Consulta),
FechaDiagnostico DATE NOT NULL,
Observacion TEXT NOT NULL,
UNIQUE(ID_Diagnostico, ID_Consulta)
);
GO


CREATE TABLE Enfermedad_Diagnosticada(
ID_Enfermedad INTEGER NOT NULL REFERENCES Enfermedad(ID_Enfermedad),
ID_Diagnostico INTEGER NOT NULL REFERENCES Diagnostico(ID_Diagnostico),
Observacion TEXT NOT NULL,
UNIQUE(ID_Enfermedad, ID_Diagnostico)
);
GO


CREATE TABLE Historial_Enfermedad(
ID_Enfermedad INTEGER NOT NULL REFERENCES Enfermedad(ID_Enfermedad),
Num_Expediente INTEGER NOT NULL REFERENCES Expediente_Paciente(Num_Expediente),
Observacion VARCHAR(250) NOT NULL,
Enfermedad_Preexistente BIT NOT NULL,
Enfermedad_Herencia BIT NOT NULL
UNIQUE(ID_Enfermedad, Num_Expediente)
);
GO


CREATE TABLE Alergias_Paciente(
ID_Alergia INTEGER NOT NULL REFERENCES Alergia(ID_Alergia),
Num_Expediente INTEGER NOT NULL REFERENCES Expediente_Paciente(Num_Expediente),
Observaciones TEXT NOT NULL,
UNIQUE(ID_Alergia, Num_Expediente)
);
GO


CREATE TABLE Enfermedad_Sintomas(
ID_Enfermedad INTEGER NOT NULL REFERENCES Enfermedad(ID_Enfermedad),
ID_Sintoma INTEGER NOT NULL REFERENCES Sintomas(ID_Sintoma),
UNIQUE(ID_Enfermedad, ID_Sintoma)
);
GO



CREATE TABLE Cita(
ID_Cita INTEGER IDENTITY(1,1) PRIMARY  KEY,
ID_Empleado VARCHAR(10) REFERENCES Empleado_Header(ID_Empleado),
ID_Area INTEGER REFERENCES Area(ID_Area),
Num_Expediente INTEGER NOT NULL REFERENCES Expediente_Paciente(Num_Expediente),
FechaCita DATE NOT NULL,
HoraCita TIME NOT NULL,
FOREIGN KEY(ID_Empleado, ID_Area) REFERENCES Empleado_Areas(ID_Empleado, ID_Area),
UNIQUE(ID_Empleado, FechaCita, HoraCita),
UNIQUE(Num_Expediente, FechaCita, HoraCita),
CHECK(ID_Empleado LIKE 'SDMD%')
);
GO


CREATE TABLE Historial_Internos(
Num_Paciente INTEGER NOT NULL REFERENCES Expediente_Paciente(Num_Expediente),
ID_Area INTEGER NOT NULL REFERENCES Area(ID_Area),
FechaIngreso DATE NOT NULL,
FechaAlta DATE NULL,
UNIQUE(Num_Paciente, ID_Area),
UNIQUE(Num_Paciente, ID_Area, FechaIngreso)
);
GO




----HOSPITAL---

CREATE TABLE TipoOperacion(
ID_TOperacion INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreOperacion VARCHAR(100) NOT NULL,
DescripcionOperacion VARCHAR(150) NOT NULL,
PrecioOperacion DECIMAL(13,2) NOT NULL,
UNIQUE(ID_TOperacion, NombreOperacion),
UNIQUE(NombreOperacion),
CHECK(NombreOperacion NOT LIKE '%[0-9@$%]%')
);
GO


CREATE TABLE Quirofano(
ID_Quirofano INTEGER IDENTITY(1,1) PRIMARY KEY,
NombreQuirofano VARCHAR(100) NOT NULL,
UNIQUE(ID_Quirofano, NombreQuirofano),
UNIQUE(NombreQuirofano),
CHECK(NombreQuirofano NOT LIKE '%[0-9@$%]%')
);


CREATE TABLE Operacion_Paciente(
ID_Operacion INTEGER IDENTITY(1,1) PRIMARY KEY,
Num_Expediente INTEGER NOT NULL REFERENCES Expediente_Paciente(Num_Expediente),
ID_TOperacion INTEGER NOT NULL REFERENCES TipoOperacion(ID_TOperacion),
ID_Empleado VARCHAR(10) NOT NULL REFERENCES Empleado_Header(ID_Empleado),
FechaOperacion DATE NOT NULL,
Observacion TEXT NOT NULL,
HoraOperacion TIME NOT NULL,
ID_Quirofano INTEGER NOT NULL REFERENCES Quirofano(ID_Quirofano),
UNIQUE(Num_Expediente,FechaOperacion, HoraOperacion),
UNIQUE(ID_Empleado,FechaOperacion, HoraOperacion),
UNIQUE(Num_Expediente, ID_TOperacion, HoraOperacion, FechaOperacion),
UNIQUE(ID_Quirofano, FechaOperacion, HoraOperacion),
CHECK(ID_Empleado LIKE 'SDMD%')
);
GO

CREATE TABLE Operacion_Instrumentos(
ID_Operacion INTEGER NOT NULL REFERENCES Operacion_Paciente(ID_Operacion),
ID_Instrumento INTEGER NOT NULL REFERENCES Instrumentos(ID_Instrumento),
Cantidad INTEGER NOT NULL,
UNIQUE(ID_Operacion, ID_Instrumento),
CHECK(Cantidad >=1)
);
GO



CREATE TABLE Operacion_Medicamentos(
ID_Operacion INTEGER NOT NULL REFERENCES Operacion_Paciente(ID_Operacion),
ID_Medicamento INTEGER NOT NULL REFERENCES Medicamentos(ID_Medicamento),
Cantidad INTEGER NOT NULL,
UNIQUE(ID_Operacion, ID_Medicamento),
CHECK(Cantidad >=1)
);
GO


CREATE TABLE Operacion_Personal(
ID_Operacion INTEGER NOT NULL REFERENCES Operacion_Paciente(ID_Operacion),
ID_Empleado VARCHAR(10) NOT NULL REFERENCES Empleado_Header(ID_Empleado),
UNIQUE(ID_Operacion, ID_Empleado),
CHECK(ID_Empleado LIKE 'SD%')
);
GO






-----------CATALOGOS-------------

--Inserto Valores en cada catalogo-

INSERT INTO Genero VALUES('M', 'Masculino')
INSERT INTO Genero VALUES('F', 'Femenino')
SELECT * FROM Genero




INSERT INTO Especialidad VALUES('Pediatria', 'Especialidad médica que estudia al niño y sus enfermedades.')
INSERT INTO Especialidad VALUES('Ginecología', 'Especialidad médica y quirúrgica que estudia el sistema reproductor femenino.')
INSERT INTO Especialidad VALUES('Psiquiatría', 'Especialidad médica dedicada al estudio de los trastornos mentales.')
INSERT INTO Especialidad VALUES('Radiología', 'Especialidad médica, que se ocupa de generar imágenes del interior del cuerpo.')
INSERT INTO Especialidad VALUES('Alergología', 'Especialización clínica que comprende el conocimiento, diagnóstico y tratamiento de la patología producida por mecanismos inmunológicos.')
INSERT INTO Especialidad VALUES('Cardiología', 'Especialidad médica, que se encarga del estudio de las enfermedades del corazón y del aparato circulatorio.')
INSERT INTO Especialidad VALUES('Neumología', 'Especialidad médica, encargada del estudio de las enfermedades del aparato respiratorio.')
INSERT INTO Especialidad VALUES('Cirugía Cardíaca', 'Especialidad quirúrgica, que se ocupa del corazón o grandes vasos, realizada por un cirujano cardíaco.')
INSERT INTO Especialidad VALUES('Infectología', 'Especialidad médica, que se ocupa la prevención, el diagnóstico y el tratamiento de las enfermedades producidas por agentes infecciosos.')
INSERT INTO Especialidad VALUES('Medicina Interna', 'Especialidad médica, que atiende integralmente los problemas de salud en pacientes adultos.')
INSERT INTO Especialidad VALUES('Cirugía General', 'Especialidad quirúrgica que abarca las operaciones del aparato digestivo.')
INSERT INTO Especialidad VALUES('Medicina Deportiva', 'Especialidad médica, que estudia los efectos del ejercicio del deporte y, en general, de la actividad física.')
INSERT INTO Especialidad VALUES('Dermatología', 'Especialidad médica,  que estudia y trata el órgano cutáneo.')

INSERT INTO Especialidad VALUES('Administración y marketing', 'Especialización que se encarga del proceso que se desarrolla en la empresa, para planear, fruto del análisis previo de la situación.')
SELECT * FROM Especialidad


INSERT INTO Tipo_Servicio VALUES('MT','Mantenimiento')
INSERT INTO Tipo_Servicio VALUES('SD','Salud')
INSERT INTO Tipo_Servicio VALUES('AS','Aseo')
INSERT INTO Tipo_Servicio VALUES('AD','Administrativo')
INSERT INTO Tipo_Servicio VALUES('SG','Seguridad')
SELECT * FROM Tipo_Servicio



--------PERSONAL ADMINISTRATIVO-----
INSERT INTO Personal_Servicio VALUES ('CT','Contador', 'AD')
INSERT INTO Personal_Servicio VALUES ('FN','Financiero', 'AD')



--------PERSONAL MANTENIMIENTO-----
INSERT INTO Personal_Servicio VALUES ('TE','Tecnico Electricista', 'MT')



--------PERSONAL DE SEGURIDAD-----
INSERT INTO Personal_Servicio VALUES ('GR','Guardia', 'SG')
INSERT INTO Personal_Servicio VALUES ('OF','Oficial', 'SG')



--------PERSONAL ASEO-----
INSERT INTO Personal_Servicio VALUES ('CS','Conserje', 'AS')


--------PERSONAL SALUD-----
INSERT INTO Personal_Servicio VALUES ('MD','Medico', 'SD')
INSERT INTO Personal_Servicio VALUES ('AN','Anestecista', 'SD')
INSERT INTO Personal_Servicio VALUES ('EF','Enfermera', 'SD')
INSERT INTO Personal_Servicio VALUES ('IN','Instrumentista', 'SD')
SELECT * FROM Personal_Servicio



INSERT INTO Area VALUES('Pediatria', 'Area de atencion a infantes.')
INSERT INTO Area VALUES('Medicina Interna', 'Area de atencion a adultos.')
INSERT INTO Area VALUES('Radriografia', 'Area de realizacion de radiografias.')
INSERT INTO Area VALUES('Ginecología y Obstetricia', 'Area de atencion a mujeres.')
INSERT INTO Area VALUES('Dermatologia', 'Area de atención al cuidado de la piel.')
INSERT INTO Area VALUES('Oncologia', 'Area de realizacion de cancer, entre otros')
INSERT INTO Area VALUES('Medicina Preventiva', 'Area dedicada a prevenir el desarrollo de la enfermedad.')
INSERT INTO Area VALUES('Emergencia', 'Area emergencia.')
INSERT INTO Area VALUES('Anestesiología', 'Area para colocar anestesia.')
INSERT INTO Area VALUES('Olftamología', 'Area de tratamiento y atención de la vista.')
INSERT INTO Area VALUES('Rehabilitación', 'Area de rehabilitación.')
INSERT INTO Area VALUES('Digestivo', 'Area del cuidado del sistema digestivo.')
SELECT * FROM Area



INSERT INTO Cargo VALUES('Jefe', 'Jefe de Area')
INSERT INTO Cargo VALUES('Presidente', 'Presidente de Area')
INSERT INTO Cargo VALUES('Vicepresidente', 'Vicepresidente de Area')
INSERT INTO Cargo VALUES('Coordinador', 'Coordinador de Area')
INSERT INTO Cargo VALUES('Supervisor', 'Supervisor General de Area')
INSERT INTO Cargo VALUES('Coordinador de Enfermeros', 'Coordinador de Enfermeros del Area')
SELECT * FROM Cargo



INSERT INTO Turno VALUES('A','Matutino','06:00', '02:00')
INSERT INTO Turno VALUES('B', 'Vespertino','02:00', '09:00')
INSERT INTO Turno VALUES('C', 'Nocturno','09:00', '06:00')
SELECT * FROM Turno



--0 Para Inactivo, 1 para Activo--
SELECT * FROM Persona;
SELECT * FROM Personal_Servicio;



--INSERTO VALORES---CATALOGOS---

INSERT INTO Alergia VALUES('Animales', 'Al pelo y la piel de los animales')
INSERT INTO Alergia VALUES('Polen', 'Causada por la sensibilización clínica a los alérgenos presentes en los pólenes')
INSERT INTO Alergia VALUES('Ácaros', 'La alergia a los ácaros es una enfermedad crónica')
INSERT INTO Alergia VALUES('Sol', 'Causada el golpe directo de los rayos ultravioleta del sol en la piel.')
INSERT INTO Alergia VALUES('Penicilina', ' Incluyen salpullido, urticaria (ronchas), comezón en los ojos e hinchazón en los labios, la lengua o la cara.')
INSERT INTO Alergia VALUES('Látex', 'Las personas con alergia a este material tienen reacciones como la dermatitis e incluso rinoconjuntivitis o asma.')
INSERT INTO Alergia VALUES('Picaduras', 'Pueden provocar reacciones que se extienden por todo el cuerpo, provocando un shock anafiláctico grave.')
INSERT INTO Alergia VALUES('Níquel', 'roduce síntomas en la piel como la dermatitis.')
INSERT INTO Alergia VALUES('Medicamentos', 'Causada por la sensibilización clínica a los alérgenos presentes en los pólenes')
INSERT INTO Alergia VALUES('Moho', 'causada por las esporas que desprende el moho en zonas húmedas.')
INSERT INTO Alergia VALUES('Fragancias', 'Causada por productos como perfumes, detergentes, velas aromáticas o cosméticos.')
INSERT INTO Alergia VALUES('Cucarachas', 'Causada como consecuencia de las proteínas que se desprenden de sus heces.')
INSERT INTO Alergia VALUES('Semen', 'Causa hinchazón, ronchas y quemazón en los genitales, e incluso puede provocar la muerte.')
INSERT INTO Alergia VALUES('Ejercicio', 'Causa desde picazón y urticaria hasta el colapso.')
INSERT INTO Alergia VALUES('Frío', 'Consecuencia de la exposición a bajas temperaturas también causa picazón, hinchazón y urticaria, y su exposición continuada puede causar la muerte.')

SELECT * FROM Alergia
GO



INSERT INTO TipoConsulta VALUES('Consulta General', 350.99)
INSERT INTO TipoConsulta VALUES('Consulta Con Especialista', 720.50)
SELECT * FROM TipoConsulta
GO



INSERT INTO Enfermedad VALUES('Ovarios Poliquisticos')
INSERT INTO Enfermedad VALUES('Hipotiroidismo')
INSERT INTO Enfermedad VALUES('Diabetes')
INSERT INTO Enfermedad VALUES('Dengue')
INSERT INTO Enfermedad VALUES('Asma')
INSERT INTO Enfermedad VALUES('Gripe y Resfriado común')
INSERT INTO Enfermedad VALUES('Rinitis')
INSERT INTO Enfermedad VALUES('Rinosinusitis')
INSERT INTO Enfermedad VALUES('Faringitis')
INSERT INTO Enfermedad VALUES('Amigdalitis')
INSERT INTO Enfermedad VALUES('Bronquitis')
INSERT INTO Enfermedad VALUES('Enfisema pulmonar')
INSERT INTO Enfermedad VALUES('Cáncer de pulmón')
INSERT INTO Enfermedad VALUES('Herpes labial')
INSERT INTO Enfermedad VALUES('Urticaria')
INSERT INTO Enfermedad VALUES('Queratosis actínica')
INSERT INTO Enfermedad VALUES('Rosácea')
INSERT INTO Enfermedad VALUES('Esguince grado uno')
INSERT INTO Enfermedad VALUES('Esguince grado dos')
INSERT INTO Enfermedad VALUES('Esguince grado tres')
INSERT INTO Enfermedad VALUES('Quebradura')

SELECT * FROM Enfermedad



INSERT INTO Sintomas VALUES('Fiebre')
INSERT INTO Sintomas VALUES('Acne')
INSERT INTO Sintomas VALUES('Dolor de Cabeza')
INSERT INTO Sintomas VALUES('Dolor de Oido')
INSERT INTO Sintomas VALUES('Mareos')
INSERT INTO Sintomas VALUES('Nauseas')
INSERT INTO Sintomas VALUES('Dolor de garganta')
INSERT INTO Sintomas VALUES('Tos')
INSERT INTO Sintomas VALUES('Malestar general ')
INSERT INTO Sintomas VALUES('Obstrucción nasal')
INSERT INTO Sintomas VALUES('Secreción postnasal')
INSERT INTO Sintomas VALUES('Opacidad de los senos')
INSERT INTO Sintomas VALUES('Dolor al tragar')
INSERT INTO Sintomas VALUES('Dificultad para deglutir')
INSERT INTO Sintomas VALUES('Dificultad para respirar')
INSERT INTO Sintomas VALUES('Acumulación de moco')
INSERT INTO Sintomas VALUES('Inflamación de los bronquios')
INSERT INTO Sintomas VALUES('Picor nasal')
INSERT INTO Sintomas VALUES('Fatiga')
INSERT INTO Sintomas VALUES('Pérdida del apetito')
INSERT INTO Sintomas VALUES('Respiración rápida')
INSERT INTO Sintomas VALUES('Ampolla roja')
INSERT INTO Sintomas VALUES('Dolores corporales')
INSERT INTO Sintomas VALUES('Parche de piel gruesa, escamosa o con costra')
INSERT INTO Sintomas VALUES('Rubor facial')
INSERT INTO Sintomas VALUES('Protuberancias elevadas')
INSERT INTO Sintomas VALUES('Sequedad de la piel')
INSERT INTO Sintomas VALUES('Hinchazon')
INSERT INTO Sintomas VALUES('Hueso quebrado')
SELECT * FROM Sintomas



SELECT * FROM Enfermedad
SELECT * FROM Sintomas
INSERT INTO Enfermedad_Sintomas VALUES(5, 20)
INSERT INTO Enfermedad_Sintomas VALUES(5, 16)
INSERT INTO Enfermedad_Sintomas VALUES(5, 8)
INSERT INTO Enfermedad_Sintomas VALUES(9, 1)
INSERT INTO Enfermedad_Sintomas VALUES(9, 14)
INSERT INTO Enfermedad_Sintomas VALUES(9, 8)
INSERT INTO Enfermedad_Sintomas VALUES(9, 9)
INSERT INTO Enfermedad_Sintomas VALUES(8, 13)
INSERT INTO Enfermedad_Sintomas VALUES(6, 1)
INSERT INTO Enfermedad_Sintomas VALUES(6, 7)
INSERT INTO Enfermedad_Sintomas VALUES(6, 8)
INSERT INTO Enfermedad_Sintomas VALUES(6, 9)
INSERT INTO Enfermedad_Sintomas VALUES(6, 10)
INSERT INTO Enfermedad_Sintomas VALUES(17, 27)
INSERT INTO Enfermedad_Sintomas VALUES(16, 26)
INSERT INTO Enfermedad_Sintomas VALUES(21, 28)
INSERT INTO Enfermedad_Sintomas VALUES(20, 21)
INSERT INTO Enfermedad_Sintomas VALUES(20, 28)
INSERT INTO Enfermedad_Sintomas VALUES(20, 23)
INSERT INTO Enfermedad_Sintomas VALUES(19, 28)
INSERT INTO Enfermedad_Sintomas VALUES(19, 1)
INSERT INTO Enfermedad_Sintomas VALUES(18, 28)
INSERT INTO Enfermedad_Sintomas VALUES(21, 29)
SELECT * FROM Enfermedad_Sintomas





INSERT INTO Medicamentos VALUES('METFORMINA AENOVA', 'Metformina hidrocloruro. Povidona, estearato de magnesio', '850mg', '8470006935798')
INSERT INTO Medicamentos VALUES('PARACETAMOL', 'Povidona, almidón de maíz pregelatinizado y ácido esteárico', '1g', '8470006620250')
INSERT INTO Medicamentos VALUES('ABIK Sol', 'Parahidroxibenzoato metilo (E-218), Fructosa, Sacarosa', '1 mg/ml', '9128737281')
INSERT INTO Medicamentos VALUES('ACETATO SODICO', 'Acetato sódico', '10ml', '9128787281')
INSERT INTO Medicamentos VALUES('ACICLOVIR STADA Crema', 'Propilenglicol y otros', '50 mg/g', '9126737281')
INSERT INTO Medicamentos VALUES('ACICLOVIR SALA Polvo para sol.', 'Aciclovir', '250mg', '8470007560982')
INSERT INTO Medicamentos VALUES('ACIDO ALENDRONICO/COLECALCIFEROL SEMANAL ARISTO ', 'Almidón de maiz, Lactosa, Sacarosa', '70 mg/2800', '8470007204374')
INSERT INTO Medicamentos VALUES('ACIDO IBANDRONICO NORMON', 'Lactosa monohidrato y otros.', '150mg', '8470006835258')
INSERT INTO Medicamentos VALUES('AMOXICILINA/ ACIDO CLAVULANICO MYLAN', ' Amoxicilina trihidrato, Clavulanato potásico', '875/125mg', '8470006136126')
INSERT INTO Medicamentos VALUES('WIBICAL', 'Lactosa monohidrato y otros.', '150mg', '8470007010999')
INSERT INTO Medicamentos VALUES('MAGNESIUM DUO NOCHE', ' Magnesio, Melissa officinalis, Pepitas de Vitis vinífera extracto', '57mg', '9128735281')
INSERT INTO Medicamentos VALUES('PARICALCITOL NORMON', ' Alcohol etílico, Propilenglicol y otros.', '2mcg', '8470007032168')
SELECT * FROM Medicamentos





INSERT INTO Examenes VALUES('Pruebas serológicas', 'Suero, líquido cefalorraquídeo')
INSERT INTO Examenes VALUES('Hemograma Completo', 'Mide el número y tipos de células en la sangre.')
INSERT INTO Examenes VALUES('Urinálisis', 'Detectar un problema de salud relacionado con el sistema urinario: una infección, diabetes, pobre funcionamiento de los riñones, cálculos o el primer indicio de una malignidad.')
INSERT INTO Examenes VALUES('Heces por Parásito', 'Determina si la causa de la diarrea se debe a parásitos, amebas o entero patógenos.')
INSERT INTO Examenes VALUES('Ácido úrico', 'Evalua la falla renal.')
INSERT INTO Examenes VALUES('TFour total', 'Evalua la función de las glándulas tiroides o para confirmar o excluir el hipertiroidismo.')
INSERT INTO Examenes VALUES('TFour libre', 'Detecta el hipotiroidismo.')
INSERT INTO Examenes VALUES('Glicemia', 'Mide la glucosa que hay en la sangre.')
INSERT INTO Examenes VALUES('Radiografía de pelvis', 'Se aplica para diagnosticar si hay displasia de caderas.')
INSERT INTO Examenes VALUES('Colorrectal', 'Examen para descartar el cáncer de colon o de recto.')
INSERT INTO Examenes VALUES('Análisis de colesterolemia', 'Mide el nivel de colesterol en la sangre.')
INSERT INTO Examenes VALUES('Colposcopía', 'Observa el estado del tejido del cuello uterino.')
INSERT INTO Examenes VALUES('Mamografía', 'Detectar cualquier tipo de cáncer de mama.')
INSERT INTO Examenes VALUES('Ecografía transvaginal', 'Observa el útero, las trompas de Falopio y los ovarios, para verificar que no haya presencia de tumores o quistes.')
INSERT INTO Examenes VALUES('Urocultivo', 'Detecta infecciones urinarias y su causa.')
INSERT INTO Examenes VALUES('Sangre', 'Verifica la correcta función del hígado, riñones, el nivel de triglicéridos y detecta o descarta el padecimiento de anemia.')
SELECT * FROM Examenes



INSERT INTO Seguro VALUES('Normal','Cubre el 10% de las consultas generales', 10, 100.00)
INSERT INTO Seguro VALUES('Premium','Cubre el 15% de las consultas generales', 15, 1200.00)
INSERT INTO Seguro VALUES('Platino','Cubre el 50% de las consultas generales y el 15% de las consultas con especialidad', 50, 1500.00)
SELECT * FROM Seguro



INSERT INTO Instrumentos VALUES('Bisturí eléctrico', 'Instrumento que corta el tejido, al mismo tiempo que lo cauteriza evitando la hemorragia.', 250.00)
INSERT INTO Instrumentos VALUES('Gasas', 'Se utiliza para limpiar y/o cubrir heridas', 05.00)
INSERT INTO Instrumentos VALUES('Máscara protectora autofiltrante', 'sirve para filtrar las partículas del aire', 45.00)
INSERT INTO Instrumentos VALUES('Aguja hipodérmica', 'Inyectar sustancias en el cuerpo o tomar muestras de fluidos y tejidos del cuerpo', 15.00)
INSERT INTO Instrumentos VALUES('Pulsioxímetro', 'Mide de manera indirecta la saturación de oxígeno de la sangre roja.', 150.00)
INSERT INTO Instrumentos VALUES('Jeringa', 'Utilizadas para introducir pequeñas cantidades de gases o líquidos en áreas inaccesibles o tomar muestras', 16.00)
INSERT INTO Instrumentos VALUES('Desfibrilador subcutáneo', 'Instrumento que detecta y trata a través de descargas eléctricas, las arritmias cardiacas potencialmente malignas', 10000.00)
INSERT INTO Instrumentos VALUES('Oftalmómetro', 'Utilizado para medir los eventuales errores de refracción del ojo', 1250.00)
INSERT INTO Instrumentos VALUES('Unidad electroquirúrgica', 'Utilizado para transformar la energía eléctrica en calor con el fin de coagular, cortar o eliminar tejido blando,', 5080.00)
INSERT INTO Instrumentos VALUES('Tubo traqueal', ' catéter que se inserta en la tráquea con el propósito de establecer y mantener una vía aérea permeable', 609.00)
INSERT INTO Instrumentos VALUES('Torniquete', 'Utilizado para comprimir una vena', 115.00)
INSERT INTO Instrumentos VALUES('Estetoscopio', 'Se utiliza para oír los sonidos internos del cuerpo',780.00)
SELECT * FROM Instrumentos




INSERT INTO TipoOperacion VALUES('Cirugía mayor', 'Cirugías de la cabeza, el cuello, el tórax (pecho) y algunas cirugías del abdomen', 2566.86)
INSERT INTO TipoOperacion VALUES('Cirugía neonatal', 'Cirugías que incluye:Teratomas, Higromas quísticos y otras malformaciones vasculares', 1800.50)
INSERT INTO TipoOperacion VALUES('Apendicectomía', 'La extracción quirúrgica del apéndice,', 1250.50)
INSERT INTO TipoOperacion VALUES('Biopsia de mama', 'Incluye la extracción de tejido o células y/o extraer tejido anormal de la mama', 560.50)
INSERT INTO TipoOperacion VALUES('Cirugía de cataratas', 'Extracción del cristalino nublado, que es reemplazado por un implante de cristalino artificial transparente.', 20000.50)
INSERT INTO TipoOperacion VALUES('Cesárea', 'Parto quirúrgico de un bebé por medio de una incisión practicada en el abdomen y el útero de la madre', 6000.90)
INSERT INTO TipoOperacion VALUES('Bypass de arteria coronaria', 'Permite que la sangre fluya alrededor de la obstrucción', 18600.50)
INSERT INTO TipoOperacion VALUES('Cirugía para la lumbalgia.', 'Desarrollo anormal de la espina dorsal, estrés en la espalda, lesiones o una enfermedad física que afecta los huesos de la columna vertebral', 2680.50)
INSERT INTO TipoOperacion VALUES('Prostatectomía', 'Extirpación quirúrgica total o parcial de la glándula prostática', 2972.50)
INSERT INTO TipoOperacion VALUES('Amigdalectomía', 'Extirpación quirúrgica de una o ambas amígdalas', 2000.50)
INSERT INTO TipoOperacion VALUES('Mastectomía', 'Es la extirpación de toda la mama o parte de ella', 28900.50)
INSERT INTO TipoOperacion VALUES('Reparación de hernia inguinal', 'Regresa el intestino hacia su ubicación original, y repara los defectos en la pared abdominal.', 19693.50)
INSERT INTO TipoOperacion VALUES('Dilatación y legrado', 'Consiste en dilatar el cuello uterino de modo que se pueda raspar el canal cervical y el revestimiento uterino con una cureta', 5800.50)
INSERT INTO TipoOperacion VALUES('Mastectomía parcial', 'Incluye la extirpación del cáncer de mama y de una porción de tejido normal de la mama alrededor del cáncer.', 26000.50)
SELECT * FROM TipoOperacion



INSERT INTO Quirofano VALUES('Quirofano A')
INSERT INTO Quirofano VALUES('Quirofano B')
INSERT INTO Quirofano VALUES('Quirofano C')
INSERT INTO Quirofano VALUES('Quirofano D')
SELECT * FROM Quirofano










INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('9300760490654','Medge','Patrick','Head','Mclean','1929-08-16','pede.blandit.congue@Cumsociisnatoque.net','39113156','M','Apartado núm.: 759, 6707 Risus. Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1411471388453','Xantha','Savannah','Herring','Kelly','1911-01-01','ac.nulla@nonmagna.edu','00056389','F','7901 Sodales Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('9860398352717','Celeste','Odessa','Maldonado','Freeman','1972-08-08','mauris@Suspendisse.org','15704125','M','650-6664 Pellentesque Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5768297593993','Theodore','Anthony','Shaw','Middleton','1917-12-24','In@sollicitudin.net','14767380','F','Apartado núm.: 247, 6845 Adipiscing Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3488724907307','Jameson','Kiona','Silva','Chase','1957-07-31','ipsum.primis@Crassedleo.co.uk','99012433','M','6750 Amet Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('8525599216880','Amena','Madaline','Hunt','Santos','1983-06-08','sit.amet.ornare@inconsequat.net','37106688','F','Apdo.:715-5190 Tincidunt Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5802630400752','Wyoming','Paul','Perez','Walton','1940-04-01','nulla.at@semutdolor.com','07278720','F','Apartado núm.: 982, 8431 Orci, Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6294364962662','Arden','Emma','Pena','Stephens','1983-07-26','orci.in.consequat@arcuiaculisenim.net','55927795','M','4448 Dui, ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4525740278873','Branden','Marvin','Dennis','Buck','1924-02-13','non@vestibulum.com','69445411','M','650-6959 A, ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7126618901960','Aurelia','Kirsten','Barry','Bright','1936-05-04','ac.tellus@Loremipsumdolor.com','17553206','F','Apdo.:680-8105 Porttitor Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1708670768961','Jamal','Iris','Russell','Cooke','1944-12-12','Morbi@lorem.net','38368068','M','749-4554 Cum ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('9337356683433','Barrett','Warren','Calhoun','Burke','2013-11-24','non.magna@tinciduntDonec.co.uk','30768093','M','Apdo.:638-3679 Nec Carretera');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2746070146764','Tyler','Jesse','Frank','Russell','1969-03-21','aliquam.adipiscing.lacus@ut.co.uk','24169700','M','1841 Eget Carretera');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5400942854627','Keelie','Elliott','Stevens','White','2017-03-13','ligula@loremutaliquam.org','55374723','M','562-9231 Ut Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7122128080541','Breanna','Emily','Elliott','Martin','1994-12-15','Proin@sodaleseliterat.co.uk','60831164','M','3899 Vel Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3401090067420','Joelle','Oleg','Trujillo','Greer','1979-08-15','ante@Innec.org','83551475','F','530-4228 Ac Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2288094306636','Gavin','Stone','Combs','Drake','1942-04-08','quis@accumsanconvallisante.net','65104301','F','3521 Sagittis. Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4116839318047','Kaye','Ori','Obrien','Cochran','2012-03-08','mauris@convallisin.edu','06593988','M','Apdo.:947-8593 Hymenaeos. Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5104767435770','Lance','Maxwell','English','Weaver','2000-10-11','sit.amet.massa@Craseutellus.org','95960781','M','Apartado núm.: 670, 7473 Vitae Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4334601664425','Kermit','Juliet','Bradley','Miles','1959-04-13','sit.amet@molestiepharetra.edu','22619360','M','159-2444 Commodo Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1531012880333','Xantha','Cleo','Walton','Barrett','1929-02-04','ligula.eu@tinciduntduiaugue.co.uk','96713801','F','9433 Metus Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3013138952849','Channing','Joseph','Bryant','Wilson','2009-12-29','dui.semper.et@justoProinnon.net','04121971','M','5688 Facilisis ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2569539069941','Igor','Christopher','Witt','Atkinson','1956-01-10','magna.Praesent@purus.com','21801487','M','Apartado núm.: 701, 4195 Egestas Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1690224624800','Imelda','Sharon','Lynch','Robles','1980-12-15','nulla.ante.iaculis@Craseget.com','05731140','M','2865 Aliquam Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1575191900540','Julie','Hedy','Goodwin','Barlow','1989-12-23','et.euismod@aliquetdiamSed.co.uk','78033777','M','598-7786 Integer Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5158826297691','Mia','Chastity','Carter','Farmer','1911-07-18','elit@inaliquetlobortis.edu','12381590','F','Apdo.:551-3340 Ante. Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5341265875539','Coby','Rahim','Whitfield','Buck','1920-04-06','at.auctor.ullamcorper@posuerecubilia.co.uk','12197047','F','306 Feugiat C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3658070659388','Brady','Odette','Kemp','Kelly','1950-03-24','vestibulum@posuere.ca','42954542','M','405-8654 In C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6291108257006','Channing','Joy','Finley','Rocha','1965-04-11','elementum.purus@miDuisrisus.com','89219700','F','1953 Amet C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7384361617130','Alexander','Walter','Yates','Skinner','1985-07-22','iaculis@fringillaeuismod.com','74203578','M','673-8530 A C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7490370660173','Jeanette','Amir','Graves','Shelton','1966-10-10','non.feugiat@Loremipsumdolor.edu','30090404','F','Apdo.:921-5881 Rutrum, Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6984576242780','Dane','Evelyn','Marsh','Waller','1974-05-03','nunc@ametconsectetueradipiscing.edu','67274023','F','577-6889 Duis Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2585247357221','Upton','Hedda','Shields','Strickland','1984-10-31','dictum.magna@atnisi.com','39711855','M','Apartado núm.: 863, 2767 Aenean Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5733878739094','Ainsley','Janna','Cervantes','Good','1986-12-29','faucibus@enimEtiamgravida.com','17097120','F','245-2452 Ac Carretera');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7472853365599','Ivana','Nehru','Cash','Day','1942-09-19','risus.Nulla.eget@ipsumdolorsit.com','89068398','F','Apdo.:477-400 Enim ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6077254729858','Raphael','Lee','Rodriquez','Whitfield','1956-10-12','mi.lacinia.mattis@aliquetliberoInteger.net','50190275','F','Apdo.:444-6628 Ac Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('9578802592268','Noah','Hayfa','Bray','Bradford','1929-01-08','ultricies.ornare@nonummyultricies.com','61981337','F','Apdo.:972-5190 Sed ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('8375625037564','Maggie','Reagan','Norman','Case','1914-01-03','volutpat@gravida.edu','42343455','F','Apartado núm.: 182, 9322 In Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4520409742543','Branden','Hasad','Miles','Wooten','1930-09-08','eu.tempor.erat@magna.ca','25165084','M','Apdo.:239-178 Gravida Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4049883299007','Camden','Medge','Coleman','Guy','2007-09-02','eget.mollis@In.co.uk','83424372','F','Apdo.:341-7218 Augue Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2477220152522','Xanthus','Keely','Duke','Mcdonald','1938-11-05','et.commodo.at@Mauris.net','91661556','M','390-7778 Aliquam Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1473099549349','Hermione','Galena','Holland','Humphrey','2006-01-30','cursus.et@nuncac.net','16970759','F','Apdo.:236-7310 Integer Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6056500254745','Lee','Joel','Ramsey','Pittman','1972-10-01','non@semutcursus.com','19719493','M','9495 Sit Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('8208932962235','Ray','Thane','Brewer','Beck','1964-01-02','ut.erat.Sed@Etiamvestibulum.org','03607299','M','5580 Tincidunt C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3694934465125','Derek','Adria','Summers','Raymond','2004-07-14','Ut@egestasAliquam.co.uk','62836562','F','Apartado núm.: 906, 3896 Libero. Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5787382730267','Sharon','Jin','Finch','Miles','1992-03-15','Curabitur.ut@Phaselluslibero.edu','09745462','M','663-7235 Donec Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3461720116685','Matthew','Harper','Hester','Carver','1950-09-01','netus.et.malesuada@egestas.edu','45083894','F','704 Dapibus Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3405897959909','Stephen','Hyatt','Cox','Hood','1950-11-01','neque.Nullam.ut@Integereu.com','68060195','F','462-9251 Non, Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5877732058870','Jameson','Timon','Stevens','Mejia','1986-01-28','tempor@justoeuarcu.org','36461163','F','537-3828 Vitae, Carretera');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1279484303712','Chase','Eve','Sawyer','Pace','1937-07-01','Mauris.eu.turpis@per.co.uk','76494924','F','345 Tellus C/');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1935567874719','Sasha','Ulysses','Barlow','Whitley','1929-02-17','Vivamus.nisi.Mauris@dolorsitamet.net','33649017','F','Apartado núm.: 641, 1812 Est Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('8991891643550','Steven','Aladdin','Kaufman','Garcia','1983-08-25','ut@diamloremauctor.co.uk','88010390','M','4696 Vitae, ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1166301807673','Merritt','Wendy','Durham','Cline','1948-03-17','et.magnis@Craseutellus.com','14054247','F','5388 Lacinia Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6664883576842','Moses','Nathaniel','Wood','Andrews','1948-06-11','eu.arcu.Morbi@nuncQuisque.ca','03796605','M','412-6450 Pharetra C/');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5137739821170','Ann','Katelyn','Newman','Williams','1932-04-28','lacinia.mattis@nullaCraseu.edu','56655719','F','Apartado núm.: 101, 4784 Sit Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2678335791630','Hop','Sydnee','Moss','Powell','1953-05-08','eu@euplacerat.net','88864771','M','356-3490 Ac Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7112092890269','Hamish','Daphne','Kelley','Bonner','1989-04-17','augue@luctusetultrices.co.uk','65684220','F','Apartado núm.: 234, 9663 Pellentesque C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6556231868247','Lyle','Constance','Black','Yates','1928-10-26','mauris@Etiam.net','18506262','F','Apdo.:831-4483 Nec, Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4933788500865','Britanni','Kennedy','Collins','Holman','1952-02-29','pretium.neque@Sed.net','25727445','M','Apartado núm.: 799, 1674 Pellentesque Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6774261647486','Leslie','Regina','Haynes','Sykes','1991-04-24','a.malesuada@Sedcongueelit.net','81852113','M','Apdo.:548-5389 Augue C/');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1828755272155','Serena','Samuel','Townsend','George','1938-08-05','eu.elit.Nulla@liberoIntegerin.com','88772291','F','445-7834 Ac, Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('8832304536088','Oscar','Willow','Sargent','Fowler','1995-08-11','Lorem.ipsum.dolor@musAeneaneget.org','10738701','F','Apartado núm.: 175, 7604 In ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5986389877820','Irma','Adrian','Santiago','Chase','1921-12-14','ornare.In.faucibus@semper.ca','08086196','M','226-4713 Pretium C/');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7763317739155','Cedric','Autumn','Puckett','Hartman','1969-05-10','In.tincidunt.congue@risus.com','34365160','F','7204 Commodo ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5977854095407','Anthony','Aspen','Conley','Lewis','2013-05-02','semper.cursus@vulputate.ca','05619727','M','704-831 Vestibulum. Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('9945932480067','Clayton','Kato','Holder','Strong','1963-10-26','a.tortor.Nunc@ultricesposuerecubilia.org','28728986','F','Apartado núm.: 583, 8981 Convallis Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5710218811296','Vera','Vernon','Hickman','Bailey','1986-05-10','mauris.eu@egestasblanditNam.co.uk','27499260','M','Apartado núm.: 554, 2137 Aliquam, Carretera');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2171386775470','Garrison','Carlos','Acevedo','Nelson','1958-08-19','Donec.vitae@ipsumSuspendissenon.edu','97395565','M','6063 Aenean C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4315798115619','Iola','Akeem','Wiley','Olsen','2009-05-18','Praesent.interdum@Nunc.com','37565360','F','Apdo.:696-699 Donec C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('9997100877974','Erich','Sean','Carpenter','Spencer','1987-07-29','adipiscing.lobortis.risus@liberonecligula.net','20138338','F','Apdo.:657-2903 Donec Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4528333351690','Owen','Shelly','Glass','Gamble','2013-12-27','arcu.vel@AliquamnislNulla.net','64522323','F','Apdo.:996-1588 Vivamus Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5713573886083','Dawn','Simone','David','Medina','1946-03-14','interdum@eu.org','95579984','M','225-3620 Quam, Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('8658869095672','Jordan','Beck','Peters','Mckee','1941-03-16','Cras.eu.tellus@enim.org','38946443','M','5585 Nulla Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2331500261017','Roth','Lael','Rush','Dickson','1914-07-21','faucibus.orci.luctus@facilisiSedneque.net','15965352','M','4653 Non, Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4854164840920','Haley','Macy','Stout','Gardner','1973-01-25','Nam@lacinia.net','75506250','M','859-1864 Odio Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('8007246654780','Theodore','Arthur','Booker','Fitzgerald','1978-04-05','Nunc@interdumenim.co.uk','54066931','F','Apartado núm.: 297, 2506 In ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('9526265051694','Daryl','Hilda','Jenkins','Holloway','1956-01-30','mollis@lectusNullamsuscipit.com','61491642','F','726-4994 Dictum C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('9023307270393','Octavius','Quemby','Jennings','Drake','1945-02-14','sed.leo@Inat.net','09832390','F','Apdo.:461-7933 Ipsum Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('9546213011128','Flavia','Sheila','Brock','Koch','1964-04-23','a.facilisis@Donecnon.ca','80940385','F','5885 In, Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1588738547840','Ira','Tanya','Humphrey','Wilson','1935-02-06','magna.Praesent@ante.com','55722869','F','895-9831 Enim C/');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3482695781071','Signe','Wang','Erickson','Herman','1916-04-02','et.magna@magnis.net','26981706','M','Apdo.:609-2373 In Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4013041042048','Hector','Drew','Barber','Cotton','1958-10-04','quis.tristique.ac@Sedmalesuada.org','12742518','M','Apdo.:984-2486 Semper Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('1643696070686','Nathan','Martina','Dunn','Frost','1987-09-15','orci.lobortis@etrutrumnon.ca','95250250','F','865-9550 Luctus, Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7798225531616','May','Portia','Boyer','Jensen','1941-09-09','augue.ut@dictumeuplacerat.com','98143494','F','6296 Luctus C.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2489150551627','Willow','Larissa','Collier','Keith','1915-07-20','aliquet@dignissim.ca','42808460','F','Apartado núm.: 832, 2380 Interdum. Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4450600246883','Quamar','Emi','Orr','Acosta','1989-05-23','dolor@Intinciduntcongue.com','89312559','M','9804 Nullam Carretera');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6852426424306','Valentine','Nelle','Rice','Reynolds','1960-03-26','penatibus.et.magnis@temporest.net','70123892','M','657-5660 Tristique C/');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2197864393817','Florence','Barry','Stanton','Buckley','1930-12-22','nonummy.Fusce@turpisegestasAliquam.net','94245282','F','437-2458 Sed Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5608349889384','Carson','Patience','Christensen','Chaney','1996-03-11','vitae.sodales.at@dictum.org','74910543','M','322 Curabitur Carretera');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3640262132171','Jaquelyn','Lamar','Sharp','Price','1997-12-29','commodo.hendrerit.Donec@neque.ca','83933096','M','Apdo.:726-9408 Commodo Avda.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('6136863363166','George','Wynne','Baldwin','Brooks','1961-11-22','nec.urna@velitduisemper.co.uk','91282489','M','Apdo.:202-9862 Quis, Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3057555806652','Ginger','Charity','Mejia','Kim','1917-02-11','tincidunt.nibh.Phasellus@necmollisvitae.org','78958845','M','7838 Est Av.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('4981298420926','Christen','Mary','Franco','Christian','1991-05-27','Cras@orcilobortisaugue.org','08164453','F','774-9841 Duis Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7877314013474','Derek','Clayton','Wagner','Roberson','1966-12-14','risus.quis.diam@semper.co.uk','10640791','M','Apdo.:945-2198 Quis ');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2353113361254','Cole','Sopoline','Aguirre','Cleveland','2019-01-20','per.conubia.nostra@magna.com','11199434','F','163-6451 Risus, Ctra.');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('8608234807181','Xavier','Omar','Love','Pearson','1989-10-14','lectus@molestieintempus.co.uk','95956919','F','Apartado núm.: 690, 7967 Nec Carretera');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('2528991856857','Levi','Stone','Cortez','Berger','1991-05-31','eros.Proin@ultricies.net','92033425','M','Apartado núm.: 231, 3019 Ultricies Avenida');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('5156761575344','Fay','Molly','Salas','Small','1977-03-11','laoreet@Uttinciduntorci.edu','72943927','M','Apdo.:990-4470 Sit C/');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('7025352740614','Peter','Harriet','Sharpe','Velasquez','1964-01-07','vitae.risus.Duis@risus.edu','09914826','M','Apdo.:490-5888 Pede Calle');
INSERT INTO Persona([ID_Persona],[PrimerNombre],[SegundoNombre],[PrimerApellido],[SegundoApellido],[FechaNacimiento],[E_Mail],[Num_Telefono],[Genero],[Direccion]) VALUES('3225523305558','Robert','Odette','Crosby','Keith','1912-11-29','Aliquam.ornare@magnaatortor.co.uk','32032976','F','Apartado núm.: 231, 9465 Odio, Avda.');



INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SGOF01', '3225523305558', '2017-11-15', 1 ,'SG','OF')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SGOF02', '5156761575344', '2012-01-24', 1,'SG','OF')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SGOF03', '5986389877820', '2011-12-31',1,'SG','OF')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SGOF04', '4334601664425', '2008-10-10',1,'SG','OF')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SGGR01', '4116839318047', '2008-03-13',1,'SG','GR')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SGGR02', '2288094306636', '2011-10-20',1,'SG','GR')



INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('ADCT01', '8608234807181', '2005-05-11', 1,'AD','CT')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('ADCT02', '2353113361254', '2017-01-28',1,'AD','CT')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('ADFN01', '7798225531616',  '2004-10-06',1,'AD','FN')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('ADFN02', '5713573886083', '2009-11-28',1,'AD','FN')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('ADCT03', '3401090067420', '2004-03-14',1,'AD','CT')



INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('ASCS01', '7025352740614', '2012-12-19', 1 ,'AS','CS')



INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDIN01', '2197864393817', '2007-11-13',1,'SD','IN')




INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('MTTE01', '9997100877974', '2016-06-30',1,'MT','TE')


INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDMD01', '2528991856857', '2018-04-29', 1,'SD','MD')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDMD02', '4981298420926', '2015-07-10',1,'SD','MD')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDMD03', '6136863363166',  '2004-09-11',1,'SD','MD')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDMD04', '6291108257006', '2004-03-12',1,'SD','MD')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDMD06', '9300760490654', '2003-05-19',1,'SD','MD')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDMD07', '4525740278873', '2007-12-14',1,'SD','MD')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDMD08', '1708670768961', '2007-03-12',1,'SD','MD')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDMD09', '9337356683433', '2010-12-26',1,'SD','MD')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDMD05', '4854164840920', '2007-09-17',1,'SD','MD')

INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDEF1', '3013138952849', '2012-06-14',1,'SD','EF')


INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDAN01', '4450600246883', '2013-10-28',1,'SD','AN')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDAN02', '3640262132171', '2014-04-22',1,'SD','AN')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDAN03', '3488724907307', '2003-08-17',1,'SD','AN')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDAN04', '5802630400752', '2019-10-15', 1,'SD', 'AN')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDAN05', '1279484303712', '2019-10-15', 1,'SD', 'AN')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDAN06', '5158826297691', '2019-10-15', 1,'SD', 'AN')
INSERT INTO Empleado_Header(ID_Empleado, ID_Persona, FechaContratacion, Empleado_Activo,ID_TServicio, ID_Pservicio) VALUES('SDAN07', '6056500254745', '2019-10-15', 1,'SD', 'AN')


SELECT * FROM Especialidad

INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(9,'SDMD01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(4,'SDAN03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(7,'SDMD02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(13,'SDMD02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(10,'SDAN05');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDMD01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(10,'SDMD08');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(4,'SDMD02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(8,'SDMD04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(1,'SDAN03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(2,'SDMD04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(5,'SDAN04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(4,'SDAN02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(5,'SDEF1');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(14,'SDMD02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(7,'SDMD03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(7,'SDMD08');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(3,'SDEF1');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(3,'SDAN04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(2,'SDAN03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(5,'SDAN01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(8,'SDMD01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(2,'SDAN02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDMD08');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(11,'SDMD01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDMD07');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(8,'SDAN05');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(6,'SDAN04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(6,'SDMD01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(2,'SDMD02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(6,'SDAN05');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDAN04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDEF1');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(8,'SDMD02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDMD02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(2,'SDMD03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(10,'SDAN03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDMD04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(7,'SDMD07');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(9,'SDMD04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDAN05');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(6,'SDMD03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(8,'SDAN04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(2,'SDMD06');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(4,'SDEF1');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(4,'SDAN04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(4,'SDAN05');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(8,'SDMD03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(1,'SDMD07');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(14,'SDMD07');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(14,'SDAN04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(10,'SDAN01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(2,'SDMD07');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(9,'SDAN04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(8,'SDAN03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDMD06');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(9,'SDAN05');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(14,'SDMD04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(11,'SDMD03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(8,'SDAN01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(10,'SDMD04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(7,'SDMD04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(11,'SDMD07');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(1,'SDMD06');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(5,'SDMD01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(6,'SDMD02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(6,'SDMD07');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(13,'SDMD07');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(3,'SDMD04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(8,'SDEF1');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(1,'SDMD04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(7,'SDAN04');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(4,'SDMD01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(5,'SDAN05');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(7,'SDEF1');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(11,'SDMD02');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(6,'SDAN03');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(6,'SDAN01');
INSERT INTO Especialidad_Empleado([ID_Especialidad],[ID_Empleado]) VALUES(12,'SDAN03');



SELECT * FROM Area
SELECT * FROM Empleado_Areas

INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGOF02',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGOF01',4);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD01',8);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGOF02',4);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT01',11);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN02',6);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN04',11);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN05',1);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN04',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD07',12);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT02',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDEF1',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD08',8);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN02',10);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN05',2);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN05',4);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD02',3);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGOF01',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT01',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD03',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD02',9);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD08',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD06',1);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD03',3);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT03',8);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN03',11);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN05',9);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT03',2);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD03',1);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADFN01',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN01',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD08',2);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDEF1',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN04',9);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN05',12);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGOF02',11);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN03',2);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD06',6);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN01',11);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN04',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN05',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD05',12);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT01',8);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGGR01',4);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADFN01',10);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD03',4);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN02',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN01',8);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDEF1',9);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADFN02',3);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT03',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT02',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT01',2);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGGR01',3);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGGR01',10);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD02',10);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD01',2);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD04',12);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ASCS01',2);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD06',3);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD04',9);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD06',12);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD02',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN04',6);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGOF01',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD08',3);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD06',8);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDEF1',2);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADFN02',4);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADCT02',11);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGGR01',1);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD06',10);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN03',7);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN03',9);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADFN02',11);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD03',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SGGR01',5);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD08',4);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDAN05',6);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('ADFN02',2);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDEF1',12);
INSERT INTO Empleado_Areas([ID_Empleado],[ID_Area]) VALUES('SDMD07',3);




INSERT INTO Calendario_Turnos VALUES('ADCT02',11,'2011/10/20','C','09:00', '06:00')
INSERT INTO Calendario_Turnos VALUES('SDAN05',6, '2017/10/10','A','06:00', '02:00')
INSERT INTO Calendario_Turnos VALUES('ADFN02',2, '2014/07/17','A','06:00', '02:00')
INSERT INTO Calendario_Turnos VALUES('SDMD07',3, '2004/01/03','A','02:00', '08:00')
INSERT INTO Calendario_Turnos VALUES('SDMD01',2, '2010/12/01','C','09:00', '06:00')
INSERT INTO Calendario_Turnos VALUES('SDMD07',3, '2007/06/03','B','02:00', '09:00')
INSERT INTO Calendario_Turnos VALUES('SDAN05',9, '2006/09/22','B','02:00', '09:00')
INSERT INTO Calendario_Turnos VALUES('SDAN02',10, '2001/11/26','C','18:00', '02:00')
INSERT INTO Calendario_Turnos VALUES('ADFN01',10, '2004/03/08','B','08:00', '14:00')
INSERT INTO Calendario_Turnos VALUES('SDAN05',1, '2006/08/24','B','02:00', '09:00')
INSERT INTO Calendario_Turnos VALUES('ADCT01',8, '2015/03/24','C','09:00', '06:00')
INSERT INTO Calendario_Turnos VALUES('SDAN04',11, '2007/07/27','A','02:00', '08:00')
INSERT INTO Calendario_Turnos VALUES('SDAN04',7, '2011/01/11','B','08:00', '14:00')
INSERT INTO Calendario_Turnos VALUES('ADCT03',7, '2004/06/29','C','18:00', '02:00')
INSERT INTO Calendario_Turnos VALUES('SGOF02',5, '2012/12/04','A','02:00', '08:00')
INSERT INTO Calendario_Turnos VALUES('SDMD06',12, '2019/08/22','B','08:00', '14:00')
INSERT INTO Calendario_Turnos VALUES('SDAN01',7, '2004/06/29','C','09:00', '06:00')
INSERT INTO Calendario_Turnos VALUES('SGGR01',4, '2006/08/24','B','08:00', '14:00')
INSERT INTO Calendario_Turnos VALUES('ADCT02',11, '2020-08-18', 'A','02:00', '08:00')
INSERT INTO Calendario_Turnos VALUES('SDAN02',6, '2020-08-18', 'A','02:00', '08:00')
INSERT INTO Calendario_Turnos VALUES('SDMD06',12, '2007/07/27','B','08:00', '14:00')




INSERT INTO Empleado_Cargos VALUES('SDMD06', 12, 3)
INSERT INTO Empleado_Cargos VALUES('SDAN01', 7, 1)
INSERT INTO Empleado_Cargos VALUES('SDAN04',11, 3)
INSERT INTO Empleado_Cargos VALUES('SDMD07',3, 3)
INSERT INTO Empleado_Cargos VALUES('SDAN05',6, 3)
INSERT INTO Empleado_Cargos VALUES('SDAN02',6, 1)
INSERT INTO Empleado_Cargos VALUES('SDMD04',12, 1)
INSERT INTO Empleado_Cargos VALUES('SDAN04',9, 3)
INSERT INTO Empleado_Cargos VALUES('SDAN05',5, 3)