--------------------CONSULTAS-----------------------



-----TODO LO DE EMPLEADOS-----
USE ProyectoBases
GO



/*Mostrando todas las personas que son empleados*/
SELECT * FROM Empleado_Header
INNER JOIN Persona ON Empleado_Header.ID_Persona = Persona.ID_Persona;





/*Que tipo de personal tiene cada servicio*/
SELECT * FROM Personal_Servicio
INNER JOIN Tipo_Servicio ON Personal_Servicio.ID_Servicio = Tipo_Servicio.ID_Servicio;





/*Todos los empleados contratador en x fecha*/
SELECT * FROM Empleado_Header WHERE FechaContratacion = '2019-10-10';





/*Todos los empleados contratador en x mes*/
SELECT * FROM Empleado_Header WHERE FechaContratacion LIKE '2019-10%';





/*Empleados Activos y no despedidos*/
SELECT * FROM Empleado_Header WHERE Empleado_Activo = 1 AND FechaDespido IS NULL;





/*Todos los empleados que pertenecen a X Tipo de Servicio*/
SELECT * FROM Empleado_Header 
INNER JOIN Personal_Servicio ON Empleado_Header.ID_PServicio = Personal_Servicio.ID_PServicio
INNER JOIN Tipo_Servicio ON Personal_Servicio.ID_Servicio = Tipo_Servicio.ID_Servicio;





/*Contar los empleados que pertenecen a X Tipo de Servicio*/
SELECT COUNT(ID_Empleado) AS Empleados, Tipo_Servicio.NombreServicio AS Servicio FROM Empleado_Header 
INNER JOIN Personal_Servicio ON Empleado_Header.ID_PServicio = Personal_Servicio.ID_PServicio
INNER JOIN Tipo_Servicio ON Personal_Servicio.ID_Servicio = Tipo_Servicio.ID_Servicio
GROUP BY Tipo_Servicio.NombreServicio;



/*Cuantas especialidades tiene cada empleado*/
SELECT COUNT(ID_Especialidad) AS CantidadEspecialidad, Empleado_Header.ID_Empleado AS Empleado, Persona.PrimerNombre AS PrimerNombre  FROM Especialidad_Empleado
INNER JOIN Empleado_Header ON Especialidad_Empleado.ID_Empleado = Empleado_Header.ID_Empleado
INNER JOIN Persona ON Empleado_Header.ID_Persona = Persona.ID_Persona
GROUP BY Persona.PrimerNombre, Empleado_Header.ID_Empleado;



/*Cuantas empleados tiene cada especialidad*/
SELECT COUNT(ID_Empleado) AS CantidadEmpleados, Especialidad.NombreEspecialidad AS Especialidad FROM Especialidad_Empleado
INNER JOIN Especialidad ON Especialidad_Empleado.ID_Especialidad = Especialidad.ID_Especialidad
GROUP BY Especialidad.NombreEspecialidad;





/*Que especialidad tiene X empleado*/
SELECT Especialidad.NombreEspecialidad AS Especialidad FROM Especialidad_Empleado
INNER JOIN Empleado_Header ON Especialidad_Empleado.ID_Empleado = Empleado_Header.ID_Empleado
INNER JOIN Especialidad ON Especialidad_Empleado.ID_Especialidad = Especialidad.ID_Especialidad
WHERE Empleado_Header.ID_Empleado = 'SDMD01';





/*Que empleado tiene X especialidad*/
SELECT Especialidad_Empleado.ID_Empleado AS Empleados FROM Especialidad_Empleado
INNER JOIN Empleado_Header ON Especialidad_Empleado.ID_Empleado = Empleado_Header.ID_Empleado
INNER JOIN Especialidad ON Especialidad_Empleado.ID_Especialidad = Especialidad.ID_Especialidad
WHERE Especialidad_Empleado.ID_Especialidad = 2;






/*Cuantos empleados tiene cada area*/
SELECT COUNT(ID_Empleado) AS CantidadEmpleados, Area.NombreArea AS Area FROM Empleado_Areas
INNER JOIN Area ON Empleado_Areas.ID_Area = Area.ID_Area
GROUP BY Area.NombreArea;






/*Cuantas areas tiene cada empleado*/
SELECT COUNT(ID_Area) AS CantidadArea, Empleado_Header.ID_Empleado AS Empleado FROM Empleado_Areas
INNER JOIN Empleado_Header ON Empleado_Areas.ID_Empleado = Empleado_Header.ID_Empleado
GROUP BY Empleado_Header.ID_Empleado;





/*En cuales areas esta x empleado*/
SELECT Area.NombreArea AS Areas FROM Empleado_Areas
INNER JOIN Empleado_Header ON Empleado_Areas.ID_Empleado = Empleado_Header.ID_Empleado
INNER JOIN Area ON Empleado_Areas.ID_Area = Area.ID_Area
WHERE Empleado_Header.ID_Empleado = 'SDMD01';





/*Cuantos empleados estuvieron haciendo turno el 2020-01-10*/
SELECT COUNT(ID_Empleado) Empleados, ID_Turno AS Turno, Area.NombreArea AS Area FROM Calendario_Turnos
INNER JOIN Area ON Calendario_Turnos.ID_Area =  Area.ID_Area
WHERE FechaTurno = '2020-01-10'
GROUP BY Area.NombreArea, ID_Turno





/*Cuantos turnos tuvieron los empleados durante el mes 08, en que area estuvieron y con que turno*/
SELECT COUNT(Calendario_Turnos.ID_Empleado) AS TotalTurnos, Empleado_Areas.ID_Empleado AS Empleado, Area.NombreArea AS Area, Turno.ID_Turno AS Turno
FROM Calendario_Turnos 
INNER JOIN Empleado_Areas ON Calendario_Turnos.ID_Empleado = Empleado_Areas.ID_Empleado
INNER JOIN Area ON Empleado_Areas.ID_Area = Area.ID_Area
INNER JOIN Turno ON Calendario_Turnos.ID_Turno = Turno.ID_Turno
WHERE FechaTurno LIKE '2020-01%'
GROUP BY Empleado_Areas.ID_Empleado, Area.NombreArea, Turno.ID_Turno;




---TODO LO DE PACIENTES-----


/*Mostrando todas las personas que son pacientes*/
SELECT * FROM Expediente_Paciente
INNER JOIN Persona ON Expediente_Paciente.ID_Persona = Persona.ID_Persona;











/*Sintomas que tiene X Enfermedad*/
SELECT Sintomas.NombreSintoma AS Sintomas FROM Enfermedad_Sintomas
INNER JOIN Sintomas ON Enfermedad_Sintomas.ID_Sintoma = Sintomas.ID_Sintoma
WHERE Enfermedad_Sintomas.ID_Enfermedad = 6


/*Enfermedad que tiene X Sintoma*/
SELECT Enfermedad.NombreEnfermedad AS Enfermedad FROM Enfermedad_Sintomas
INNER JOIN Enfermedad ON Enfermedad_Sintomas.ID_Enfermedad = Enfermedad.ID_Enfermedad
WHERE Enfermedad_Sintomas.ID_Sintoma = 1