--Reglas para hospitalario_formulario_solicitud_medicamentos
--Mientras se actualiza el estado del package, se actualiza la tabla padre
CREATE RULE estado_hospitalario_formulario_solicitud_medicamentos AS ON UPDATE TO public.hospitalario_formulario_solicitud_medicamentos
	WHERE OLD.estado = ''
	DO UPDATE public.hospitalario_formulario_solicitud_medicamentos SET 
