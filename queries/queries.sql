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

--Una version mas completa
-- It's combining with hospitalario_indicacion_medica
select
	hsmd.codigo_asignacion,
	hsmd.codigo_establecimiento, e.nombre_establecimiento,
	CONCAT(pa.primer_nombre, ' ', pa.primer_apellido, ' ', pa.primer_apellido, ' ', pa.segundo_apellido)paciente, pa.codigo_paciente cedula
	, case pa.tipo_documento when '1' then 'C. de identidad' when '2' then 'Pasaporte/Extranjero' when '4' then 'No Tiene' end tipodocumento,
	CURRENT_DATE, CURRENT_TIME(0),
	hsmd.solicitud_fecha::VARCHAR ,
	hsmd.codigo_solicitud_medicamentos,
	CONCAT(us.nombres, ' ',us.apellidos) medico, prof.numero_registro, 
	(select array_to_json(array_agg(row_to_json(dt))) from (
		select
			hsmdx.codigo_indicacion_medica ,
			hsmdx.codigo_medicamento,
			CONCAT(hsmdx.nombre_medicamento, '/', me.presentacion, '/', me.forma_farmaceutica)medicamento_descripcion,
			hsmdx.cantidad_dispensada,
			hsmdx.numero_total,
			(hsmdx.numero_total - hsmdx.cantidad_dispensada)cantidad_pendiente,
			hsmdx.estado,
			CONCAT(himx.nombre_medicamento, '/', vm.vme_des, '/', himx.dosis, ' cada ', himx.hora_uso, ' (horas) por ', himx.dias_uso, ' dias')indicaciones
		from
			public.hospitalario_solicitud_medicamentos_detail hsmdx
		left join public.hospitalario_asignacion ha on
			ha.codigo_establecimiento = hsmdx.codigo_establecimiento
			and ha.codigo_asignacion = hsmdx.codigo_asignacion
		left join public.paciente pa on
			pa.codigo_paciente = ha.codigo_paciente
		left join public.hospitalario_indicacion_medica himx on
			himx.codigo_asignacion = hsmdx.codigo_asignacion and himx.codigo_establecimiento = hsmdx.codigo_establecimiento and himx.codigo_indicacion_medica = hsmdx.codigo_indicacion_medica
		left join public.via_medicine vm on vm.vme_id = himx.via_forma::INTEGER 
		left join public.medicamento me on me.codigo_establecimiento = himx.codigo_establecimiento and me.codigo_medicamento = himx.codigo_medicamento and me.codigo_sucursal = '0'
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
left join public.hospitalario_indicacion_medica him on
	him.codigo_asignacion = hsmd.codigo_asignacion and him.codigo_establecimiento = hsmd.codigo_establecimiento and him.codigo_indicacion_medica = hsmd.codigo_indicacion_medica
left join public.usuario us on
	us.codigo_usuario = him.creacion_usuario 
left join public.profesional prof on
	prof.codigo_medico = him.creacion_usuario 
where
	hsmd.codigo_solicitud_medicamentos ='SM00000001'
group by hsmd.codigo_establecimiento, e.nombre_establecimiento, hsmd.codigo_asignacion, paciente, cedula, solicitud_fecha, codigo_solicitud_medicamentos, medico, numero_registro
