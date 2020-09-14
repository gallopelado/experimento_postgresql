--Uso de reglas en dml
CREATE TABLE shoelace_log (
	sl_name char(10),	--shoelace changed
	sl_avail integer,	--new available value
	log_who name,		--who did it
	log_when timestamp	--when
);

CREATE RULE log_shoelace AS ON UPDATE TO shoelace_data
	WHERE NEW.sl_avail != OLD.sl_avail
	DO INSERT INTO shoelace_log VALUES (
		NEW.sl_name,
		NEW.sl_avail,
		getpgusername(),
		'now'
	);
