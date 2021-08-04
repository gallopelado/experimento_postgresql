DO $$
	DECLARE
		-- Nro 6 son los modos
		v_nro_encontrados BIGINT := (SELECT COUNT(*) FROM public.examination_item WHERE codigo_grupo_examination = '6');
		v_cnt BIGINT;
	BEGIN
		IF v_nro_encontrados = 0 THEN
			RAISE INFO 'NO EXISTE NINGÚN REGISTRO DE ESE GRUPO';
			INSERT INTO public.examination_item(codigo_grupo_examination, codigo_item_examination, nombre_item_examination, unit_examination, typo_unit, creacion_fecha, creacion_hora, creacion_usuario)
			VALUES 
			('6', '6.1', 'Modo', 'x', 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.2', 'Modo_otros', 'x', 'text', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.3', 'Oxigenacion', 'x', 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.4', 'IE', 'x', 'float', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.5', 'TI', NULL, 'float', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.6', 'FIO2', '%', 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.7', 'PAFI', '%', 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.8', 'SAFI', '%', 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.9', 'VTE/VM', NULL, 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.10', 'Pplat', NULL, 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.11', 'Cp', NULL, 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.12', 'PEEP', NULL, 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.13', 'ACT', NULL, 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis'),
			('6', '6.14', 'FR- PSV', NULL, 'int', CURRENT_DATE, CURRENT_TIME(0), 'interhis');
			get diagnostics v_cnt = row_count;
			-- Se verifican si se ha realizado la inserción.
			IF FOUND THEN
				RAISE INFO 'SE HAN INSERTADO CORRECTAMENTE % NUEVO REGISTROS', v_cnt;
			END IF;
		ELSE
			RAISE INFO 'YA EXISTEN % REGISTROS DE ESE GRUPO, NO SE REALIZÓ NINGUNA ACCIÓN', v_nro_encontrados;
		END IF;
		
	END;
$$