--Creating rules
CREATE RULE actualiza_estado_paquete AS ON UPDATE TO hospitalario_solicitud_medicamentos
	WHERE NEW.cantidad_dispensada_paquete = OLD.numero_total_paquete
	DO UPDATE hospitalario_solicitud_medicamentos 
	SET estado='Completo'; 
	--WHERE 
	--codigo_establecimiento=OLD.codigo_establecimiento AND codigo_solicitud_medicamentos=OLD.codigo_solicitud_medicamentos
	--AND solicitud_fecha=OLD.solicitud_fecha;
	
-- Esto retorna recursion infinita...