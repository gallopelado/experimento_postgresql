-- Packages SUM
SELECT 
	CASE WHEN (SUM(cantidad_dispensada_paquete) = SUM(numero_total_paquete)) THEN true
	WHEN  (SUM(cantidad_dispensada_paquete) < SUM(numero_total_paquete)) THEN false
	END resultado
FROM
	public.hospitalario_solicitud_medicamentos;

-- Details SUM
SELECT
	CASE WHEN (SUM(cantidad_dispensada) = SUM(numero_total)) THEN true
	WHEN (SUM(cantidad_dispensada) < SUM(numero_total)) THEN false
	END
FROM
	public.hospitalario_solicitud_medicamentos_detail;
	
--More details
-- FROM PACKAGE
SELECT
	SUM(cantidad_dispensada_paquete)sum_cantidad_dispensada_paquete, SUM(numero_total_paquete)sum_numero_total_paquete
FROM
	public.hospitalario_solicitud_medicamentos;

-- FROM DETAIL
SELECT
	SUM(cantidad_dispensada)sum_cantidad_dispensada, SUM(numero_total)sum_numero_total
FROM
	public.hospitalario_solicitud_medicamentos_detail;
	
-- Awesome cases
SELECT 
	CASE WHEN 
		(CASE WHEN (SUM(cantidad_dispensada_paquete) = SUM(numero_total_paquete)) THEN true
		WHEN  (SUM(cantidad_dispensada_paquete) < SUM(numero_total_paquete)) THEN false END) AND (
			SELECT
			CASE WHEN (SUM(hsmd.cantidad_dispensada) = SUM(hsmd.numero_total)) THEN true
			WHEN (SUM(hsmd.cantidad_dispensada) < SUM(hsmd.numero_total)) THEN false END
			FROM public.hospitalario_solicitud_medicamentos_detail hsmd WHERE hsmd.codigo_solicitud_medicamentos = 'SM00000001'
		) THEN true ELSE false END resultado
FROM
	public.hospitalario_solicitud_medicamentos WHERE codigo_solicitud_medicamentos = 'SM00000001';
--Revisar	
SELECT 
	CASE WHEN 
		(CASE WHEN (SUM(hsm.cantidad_dispensada_paquete) = SUM(hsm.numero_total_paquete)) THEN true
		WHEN  (SUM(hsm.cantidad_dispensada_paquete) < SUM(hsm.numero_total_paquete)) THEN false END) AND (
			CASE WHEN (SUM(hsmd.cantidad_dispensada) = SUM(hsmd.numero_total)) THEN true
			WHEN (SUM(hsmd.cantidad_dispensada) < SUM(hsmd.numero_total)) THEN false END
		) THEN true ELSE false END resultado
FROM
	public.hospitalario_solicitud_medicamentos  hsm, public.hospitalario_solicitud_medicamentos_detail hsmd
WHERE hsm.codigo_solicitud_medicamentos = 'SM00000001' AND hsmd.codigo_solicitud_medicamentos = 'SM00000001';
	
SELECT * FROM hospitalario_solicitud_medicamentos;
	