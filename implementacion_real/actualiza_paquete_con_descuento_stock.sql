--Creacion de la funcion
CREATE OR REPLACE FUNCTION actualiza_paquete() RETURNS TRIGGER AS $$
DECLARE
	actual_date DATE := CURRENT_DATE;
	actual_time TIME := CURRENT_TIME(0);
BEGIN
	IF NEW.cantidad_dispensada_paquete = OLD.numero_total_paquete THEN
		--Actualiza estado
		UPDATE public.hospitalario_solicitud_medicamentos SET estado='Completo',
		modificacion_fecha=actual_date, modificacion_hora=actual_time, modificacion_usuario=NEW.modificacion_usuario
		WHERE codigo_establecimiento=NEW.codigo_establecimiento AND codigo_solicitud_medicamentos=NEW.codigo_solicitud_medicamentos
		AND solicitud_fecha=NEW.solicitud_fecha AND orden=NEW.orden;
		
		--Descuenta en stock 
		UPDATE public.medicamento 
		SET stock_actual=((SELECT stock_actual FROM public.medicamento WHERE codigo_medicamento=NEW.codigo_medicamento) - NEW.cantidad_dispensada_paquete)
		, modificacion_fecha=actual_date, modificacion_hora=actual_time, modificacion_usuario=NEW.modificacion_usuario
		WHERE codigo_medicamento=NEW.codigo_medicamento;
		
		RAISE NOTICE 'estado is Completo';
	ELSIF NEW.cantidad_dispensada_paquete > OLD.numero_total_paquete THEN
		RAISE EXCEPTION 'cantidad_dispensada_paquete must be minor to numero_total_paquete' USING ERRCODE='60100';
	END IF;
	RETURN NEW;
END
$$ language plpgsql;

--Creacion de trigger para caso
--Para evitar la recursividad se utiliza 
CREATE TRIGGER actualiza_paquete_tr AFTER UPDATE OF cantidad_dispensada_paquete
	ON public.hospitalario_solicitud_medicamentos FOR EACH ROW
	WHEN (NEW.cantidad_dispensada_paquete = OLD.numero_total_paquete OR NEW.cantidad_dispensada_paquete > OLD.numero_total_paquete)
	EXECUTE PROCEDURE actualiza_paquete();
	
--Prueba
UPDATE public.hospitalario_solicitud_medicamentos SET cantidad_dispensada_paquete=10 
WHERE codigo_establecimiento='0003000.00010101' AND codigo_solicitud_medicamentos='SM00000001'
AND solicitud_fecha='2020-08-25' AND orden=2;

SELECT cantidad_dispensada_paquete, numero_total_paquete, estado, modificacion_fecha, modificacion_hora, modificacion_usuario 
FROM public.hospitalario_solicitud_medicamentos WHERE codigo_establecimiento='0003000.00010101' AND codigo_solicitud_medicamentos='SM00000001'
AND solicitud_fecha='2020-08-25' AND orden=2;

--Get drug stock
SELECT stock_actual FROM public.medicamento WHERE codigo_medicamento='5437';
--Restore stock
UPDATE public.medicamento SET stock_actual=30 WHERE codigo_medicamento='5437';

--Restaurar
UPDATE public.hospitalario_solicitud_medicamentos SET cantidad_dispensada_paquete=0, estado='En Proceso' 
WHERE codigo_establecimiento='0003000.00010101' AND codigo_solicitud_medicamentos='SM00000001'
AND solicitud_fecha='2020-08-25' AND orden=2;
