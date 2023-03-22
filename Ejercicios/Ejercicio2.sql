--Segundo ejercicio--
IF OBJECT_ID('dbo.get_prestamos_vigentes') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.get_prestamos_vigentes
	IF OBJECT_ID('dbo.get_prestamos_vigentes') IS NOT NULL
		PRINT '<<<Fallo la creacion del procedure>>>'
	ELSE
		PRINT '<<<Se borro el procedure>>>'
END
GO
CREATE PROCEDURE get_prestamos_vigentes
	@fecha		DATETIME
AS 
BEGIN
--Autor: Roa Paulo

SELECT	P.nroPrestamo,	P.nroCliente, M.nombre as MARCA, A.descripcion, P.VIN , 
		P.capital+(P.capital*(1+(0.01*P.tasa))/DATEDIFF(DAY,P.fechaAlta,P.fechaVencimiento)*DATEDIFF(DAY,P.fechaAlta,GETDATE())*(1+(0.01*PG.Valor))) as Valor_Cancelacion

FROM Prestamos P	
INNER JOIN Autos A
	ON A.modeloCod = P.modeloCod
INNER JOIN Marcas M
	ON M.id = A.marcaCod
INNER JOIN ParametrosGenerales PG
	ON PG.Nombre='IVA'
WHERE	P.fechaVencimiento	>=	@fecha AND
		P.fechaCancelacion is NULL
ORDER BY P.nroprestamo

END
go
IF OBJECT_ID('dbo.get_prestamos_vigentes') IS NOT NULL
		PRINT '<<<Se creo el procedure dbo.get_prestamos_vigentes>>>'
	ELSE
		PRINT '<<<Fallo la creacion del procedure dbo.get_prestamos_vigentes>>>'
go

--Prueba
EXECUTE get_prestamos_vigentes @fecha='20200101';
go

select DATEDIFF(DAY,'20210301', '20210901')
select DATEDIFF(DAY,'20210301', GETDATE())