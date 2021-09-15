create or replace function unique_chip_sterilization()
returns trigger
as
$$
declare
	chip boolean;
	sterilized boolean;
begin
	select case when (m.microchip = '1') then TRUE else FALSE end
	into chip
	from mascotas m join propietario_visita_veterinaria pvv ON pvv.id_mascota = m.id_mascota
	where pvv.id_mascota = new.id_mascota;
	
	IF chip then
		raise exception 'Esta visita no es valida';
	else
		return new;
	end if;
end
$$
LANGUAGE plpgsql;

create trigger visita_nueva before insert on public.propietario_visita_veterinaria
for each row
execute procedure unique_chip_sterilization();

insert into propietario_visita_veterinaria values(1234434, 1, 1, 'esterilizacion', '12/09/2021', 2);
