--Primer ejercicio--
IF OBJECT_ID('dbo.listado_autos') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.listado_autos
	IF OBJECT_ID('dbo.listado_autos') IS NOT NULL
		PRINT '<<<Fallo la creacion del procedure>>>'
	ELSE
		PRINT '<<<Se borro el procedure>>>'
END
GO
CREATE PROCEDURE listado_autos	
	@fecha		DATETIME, 
	@cod_marca	INTEGER NULL
AS 
BEGIN
--Autor :Roa Paulo
CREATE TABLE #TablaTemporal (	Compania	int, 
								NombreAuto	varchar(30),
								ModeloCod varchar(10),
								Descripcion varchar(100),
								PrecioFinal money)

INSERT INTO #TablaTemporal 
SELECT	C.Id as Compania ,	M.nombre as Nombre_Auto,
		A.MODELOCOD,		A.descripcion,	
		A.precio as Precio_Final

FROM Marcas M
	INNER JOIN Autos	A
		on A.marcaCod = M.id 
	INNER JOIN CampaniasAutos CA
		on CA.modeloCod = A.modeloCod
	INNER JOIN Campanias C
		on C.Id = CA.campaniaId
WHERE	(@cod_marca is NULL OR (M.id = @cod_marca) ) AND
		SUBSTRING(CA.modeloCod,1,4)	>=	@fecha	
ORDER BY C.Id,M.nombre,A.modeloCod,A.descripcion

UPDATE #TablaTemporal 
SET PrecioFinal = (PrecioFinal/(1+C.porcDescuento))
FROM #TablaTemporal	INNER JOIN Campanias C
	on C.Id = Compania and 
		CHARINDEX(SUBSTRING(ModeloCod,1,4),C.Nombre) > 0  AND
		CHARINDEX(NombreAuto,C.Nombre) > 0 AND
		CHARINDEX(Descripcion,C.Nombre)>0 
		
WHERE C.id = Compania

SELECT * FROM #TablaTemporal
ORDER BY Compania,NombreAuto,ModeloCod,Descripcion

END
go
IF OBJECT_ID('dbo.listado_autos') IS NOT NULL
		PRINT '<<<Se creo el procedure dbo.listado_autos>>>'
	ELSE
		PRINT '<<<Fallo la creacion del procedure dbo.listado_autos>>>'
go

--Pruebas
EXECUTE listado_autos @fecha='20210101', @cod_marca = NULL;
go
--Prueba 2
EXECUTE listado_autos @fecha='20210101', @cod_marca = 1;
go

