WITH mi_ctp AS (
	SELECT 
		codigo_establecimiento, codigo_asignacion, estado, tiempo_llamado, tiempo_atendido
		, LENGTH(codigo_consultorio)codigo_consultorio, LENGTH(TRIM(codigo_consultorio))codigo_consultorio_limpio
	FROM public.pantalla_paciente
), otro_ctp AS (
select 
	CASE WHEN codigo_consultorio <> codigo_consultorio_limpio THEN
	 'encontrado'
	 END enc
	FROM mi_ctp
)

WITH mi_ctp AS (
	SELECT 
		codigo_consultorio, codigo_consultorio ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' AS isnumeric 
	FROM public.pantalla_paciente
) 
SELECT * FROM mi_ctp WHERE isnumeric IS FALSE


-----
SELECT 
	'hola2', 'hola2' ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' AS isnumeric
	, '123', '123' ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' AS isnumeric2
	, '-123', '-123' ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' AS isnumeric3
	, 'hola2', 'hola2' ~ '[0-9]' AS ab
	, '123', '123' ~ '[0-9]' AS abc
	, '-123', '-123' ~ '[0-9]' AS acd
