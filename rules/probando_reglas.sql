--Pruebas
SELECT sl_avail FROM public.shoelace_data WHERE sl_name = 'sl7'; -- resulta 7
UPDATE shoelace_data SET sl_avail = 6 WHERE sl_name = 'sl7'; --luego resulta 6