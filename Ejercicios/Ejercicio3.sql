--Tercer Ejercicio
DECLARE @a_actualizar	INTEGER,
		@actualizados	INTEGER,
		@L�nea			VARCHAR(14)

SELECT @a_actualizar = COUNT (1)
FROM ImpuestoSolidario
WHERE L�nea <> '2021PXCFGT3050' --Dicho registro no figura en la lista de vehiculos 

PRINT 'Actualizando los registros...';

BEGIN TRANSACTION

DECLARE cur_precios CURSOR FOR   
SELECT L�nea 
FROM ImpuestoSolidario 

OPEN cur_precios 
  
FETCH NEXT FROM cur_precios INTO @L�nea

WHILE @@FETCH_STATUS = 0
BEGIN 

UPDATE Autos 
SET		precio		=	precio*(1+(0.01*CONVERT(INTEGER,SUBSTRING(@L�nea,13,14))))
WHERE	modeloCod	=	SUBSTRING(@L�nea,1,10)

SET @actualizados += @@ROWCOUNT

FETCH NEXT FROM cur_precios INTO @L�nea

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


