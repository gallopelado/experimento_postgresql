/**
* Buscar todos los pacientes que tengan detalles de medicamentos, retorna campos simples y un tipo JSON	
*/

select
	hsmd.codigo_asignacion,
	hsmd.codigo_establecimiento, e.nombre_establecimiento,
	CONCAT(pa.primer_nombre, ' ', pa.primer_apellido, ' ', pa.primer_apellido, ' ', pa.segundo_apellido)paciente,
	hsmd.solicitud_fecha::VARCHAR ,
	hsmd.codigo_solicitud_medicamentos,
	(select array_to_json(array_agg(row_to_json(dt))) from (
		select
			hsmdx.codigo_indicacion_medica ,
			hsmdx.codigo_medicamento,
			nombre_medicamento ,
			hsmdx.cantidad_dispensada ,
			hsmdx.numero_total ,
			hsmdx.estado
		from
			public.hospitalario_solicitud_medicamentos_detail hsmdx
		left join public.hospitalario_asignacion ha on
			ha.codigo_establecimiento = hsmdx.codigo_establecimiento
			and ha.codigo_asignacion = hsmdx.codigo_asignacion
		left join public.paciente pa on
			pa.codigo_paciente = ha.codigo_paciente
		where
			hsmdx.codigo_solicitud_medicamentos =hsmd.codigo_solicitud_medicamentos and hsmdx.codigo_asignacion = hsmd.codigo_asignacion)dt
	)medis
from
	public.hospitalario_solicitud_medicamentos_detail hsmd
left join public.hospitalario_asignacion ha on
	ha.codigo_establecimiento = hsmd.codigo_establecimiento
	and ha.codigo_asignacion = hsmd.codigo_asignacion
left join public.paciente pa on
	pa.codigo_paciente = ha.codigo_paciente
left join public.establecimiento e on 
	e.codigo_establecimiento = hsmd.codigo_establecimiento 
where
	hsmd.codigo_solicitud_medicamentos ='SM00000001'
group by hsmd.codigo_establecimiento, e.nombre_establecimiento, hsmd.codigo_asignacion, paciente, solicitud_fecha, codigo_solicitud_medicamentos
