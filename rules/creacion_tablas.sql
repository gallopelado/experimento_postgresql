CREATE TABLE shoe_data (	-- datos de zapatos
	shoename char(10) PRIMARY KEY,		-- clave primaria
	sh_avail integer,		-- numero de pares utilizables
	slcolor char(10),		-- color del cordon preferido
	slminlen float,			-- longitud minima de cordon
	slmaxlen float,			-- longitud maxima del cordon
	slunit char(8)			--
);

CREATE TABLE shoelace_data(				-- datos de cordones de zapatos
	sl_name char(10) PRIMARY KEY,		-- clave primaria
	sl_avail integer,					-- numero de pares utilizables
	sl_color char(10),					-- color del cordon
	sl_len float,						-- longitud del cordon
	sl_unit char(8)						-- unidad de longitud
);

CREATE TABLE unit(						-- unidades de longitud
	un_name char(8) PRIMARY KEY,		-- clave primaria
	un_fact float						-- Factor de transformacion a cm
);

ALTER TABLE public.shoelace_data ADD CONSTRAINT fk_unidad_medida FOREIGN KEY(sl_unit) REFERENCES public.unit(un_name);

INSERT INTO unit VALUES ('cm', 1.0), ('m', 100.0),('inch', 2.54);	-- unidades de medida
INSERT INTO shoe_data 
VALUES ('sh1', 2, 'black', 70.0, 90.0, 'cm'), ('sh2', 0, 'black', 30.0, 40.0, 'inch'), ('sh3', 4, 'brown', 50.0, 65.0, 'cm'),('sh4', 3, 'brown', 40.0, 50.0, 'inch');

INSERT INTO shoelace_data VALUES ('sl1', 5, 'black', 80.0, 'cm'), ('sl2', 6, 'black', 100.0, 'cm'), ('sl3', 0, 'black', 35.0 , 'inch'),
('sl4', 8, 'black', 40.0 , 'inch'), ('sl5', 4, 'brown', 1.0 , 'm'), ('sl6', 0, 'brown', 0.9 , 'm'), ('sl7', 7, 'brown', 60 , 'cm'), ('sl8', 1, 'brown', 40 , 'inch');

