--Tercer Ejercicio
DECLARE @a_actualizar	INTEGER,
		@actualizados	INTEGER,
		@Línea			VARCHAR(14)

SELECT @a_actualizar = COUNT (1)
FROM ImpuestoSolidario
WHERE Línea <> '2021PXCFGT3050' --Dicho registro no figura en la lista de vehiculos 

PRINT 'Actualizando los registros...';

BEGIN TRANSACTION

DECLARE cur_precios CURSOR FOR   
SELECT Línea 
FROM ImpuestoSolidario 

OPEN cur_precios 
  
FETCH NEXT FROM cur_precios INTO @Línea

WHILE @@FETCH_STATUS = 0
BEGIN 

UPDATE Autos 
SET		precio		=	precio*(1+(0.01*CONVERT(INTEGER,SUBSTRING(@Línea,13,14))))
WHERE	modeloCod	=	SUBSTRING(@Línea,1,10)

SET @actualizados += @@ROWCOUNT

FETCH NEXT FROM cur_precios INTO @Línea

END
CLOSE cur_precios;  
DEALLOCATE cur_precios;

IF @actualizados <> @a_actualizar
BEGIN
	PRINT 'Error al actualizar';
	ROLLBACK TRANSACTION 
END
ELSE
BEGIN
	PRINT 'Se actualizaron registros';
	COMMIT TRANSACTION
END


