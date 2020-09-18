--Controles para hospitalario_solicitud_medicamentos_detail
CREATE OR REPLACE FUNCTION actualiza_estado_medicamento_detalle() RETURNS TRIGGER AS
$$
DECLARE
	v_estado estado_solicitud_medicamentos;
BEGIN
	CASE WHEN NEW.cantidad_dispensada = 0 THEN
			--Actualizar estado a Preparando
			v_estado := 'En Proceso';
		
		WHEN NEW.cantidad_dispensada > 0 AND NEW.cantidad_dispensada < OLD.numero_total THEN
			v_estado := 'Preparando';
			
		WHEN NEW.cantidad_dispensada = OLD.numero_total THEN
			v_estado := 'Completo';
			
		WHEN NEW.cantidad_dispensada > OLD.numero_total THEN
			RAISE EXCEPTION 'cantidad_dispensada must be minor to numero_total' USING ERRCODE='60100';
			
	END CASE;
	
	UPDATE public.hospitalario_solicitud_medicamentos_detail SET estado=v_estado,
	modificacion_fecha=CURRENT_DATE, modificacion_hora=CURRENT_TIME(0), modificacion_usuario=NEW.modificacion_usuario
	WHERE codigo_establecimiento=NEW.codigo_establecimiento AND codigo_asignacion=NEW.codigo_asignacion AND codigo_indicacion_medica=NEW.codigo_indicacion_medica
	AND solicitud_fecha=NEW.solicitud_fecha;
	RAISE NOTICE 'estado detail updated';
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

--Hacer disparador
CREATE TRIGGER actualiza_estado_medicamento_detalle_tr AFTER UPDATE OF cantidad_dispensada
	ON public.hospitalario_solicitud_medicamentos_detail FOR EACH ROW
	WHEN ((NEW.cantidad_dispensada = 0)OR(NEW.cantidad_dispensada IN (0, OLD.numero_total))OR(NEW.cantidad_dispensada = OLD.numero_total)OR(NEW.cantidad_dispensada > OLD.numero_total))
	EXECUTE PROCEDURE actualiza_estado_medicamento_detalle();
	
--Hacer pruebas
SELECT cantidad_dispensada, numero_total, estado, modificacion_fecha, modificacion_hora, modificacion_usuario
FROM public.hospitalario_solicitud_medicamentos_detail
WHERE codigo_establecimiento='0003000.00010101' AND codigo_asignacion='I000000102' AND codigo_indicacion_medica=2 AND solicitud_fecha='2020-08-25'; 
	
UPDATE public.hospitalario_solicitud_medicamentos_detail SET cantidad_dispensada=5
WHERE codigo_establecimiento='0003000.00010101' AND codigo_asignacion='I000000102' AND codigo_indicacion_medica=2 AND solicitud_fecha='2020-08-25';

--Restaurar
UPDATE public.hospitalario_solicitud_medicamentos_detail SET cantidad_dispensada=0, estado='En Proceso'
WHERE codigo_establecimiento='0003000.00010101' AND codigo_asignacion='I000000102' AND codigo_indicacion_medica=2 AND solicitud_fecha='2020-08-25';
	
	