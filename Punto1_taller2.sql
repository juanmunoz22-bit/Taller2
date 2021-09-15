--function
CREATE OR REPLACE FUNCTION persist_event_complete()
  RETURNS TRIGGER 
  AS $$
BEGIN
	if (TG_OP = 'UPDATE') THEN
	insert into "pet_audit" values(old.id_mascota, old.fotografia, old.edad, old.nombre, old.tamano, old.sexo, old.microchip, old.especie, old.peligroso, old.id_propietario,TG_OP, current_timestamp );
	return new;
	
	elsif (TG_OP = 'DELETE') then
	insert into "pet_audit" values(old.id_mascota, old.fotografia, old.edad, old.nombre, old.tamano, old.sexo, old.microchip, old.especie, old.peligroso, old.id_propietario,TG_OP, current_timestamp );
	return new;
	
	elsif (TG_OP = 'INSERT') then
	insert into "pet_audit" values(new.id_mascota, new.fotografia, new.edad, new.nombre, new.tamano, new.sexo, new.microchip, new.especie, new.peligroso, new.id_propietario,TG_OP, current_timestamp );
	return new;
	END IF;
	
END
$$
LANGUAGE PLPGSQL;
--trigger
create trigger pet_update before insert or update or delete on mascotas
for each row 
execute procedure persist_event_complete();
--insert test
insert into mascotas values (300, '2', '34', 'paco', '5', 'M', '1', 'puddle', 'no', 15 );
--check data base
select * from pet_audit;