DELIMITER $$



create trigger before_kupno_biletu before insert  on Bilety
for each row
begin
if exists (select I.id_miejsca from Inserted as I
		join Bilety as B on B.id_miejsca = I.id_miejsca
		where B.id_meczu = I.id_meczu) then
rollback;
SIGNAL SQLSTATE '45000';
SET MESSAGE_TEXT = 'ERROR';
else if exists (select id_kibica from Inserted as I
		join Stadion as S on S.id_miejsca = I.id_miejsca
		where id_karnetu IS NOT NULL) then 
rollback
SIGNAL SQLSTATE '45000';
SET MESSAGE_TEXT = 'Nie mozna wpisac id kontraktu oraz wypozyczenia do jednego zawodnika';
else
insert into Bilety select * from Inserted;
end if;
end$$



create trigger after_dodanie_rezerwacji after insert  on [Rezerwacje obiektow]
for each row
begin
declare IdObiektu INT
declare OdKiedy DATETIME
declare DoKiedy DATETIME
declare IdRezerwacji INT
set IdObiektu = (select id_obiektu from Inserted)
set OdKiedy = (select od_kiedy from Inserted)
set DoKiedy = (select do_kiedy from Inserted)
set IdRezerwacji = (select id_rezerwacji from Inserted)
if exists (select id_obiektu from [Rezerwacje obiektow]
		where id_obiektu = IdObiektu AND id_rezerwacji != IdRezerwacji
		AND (DoKiedy BETWEEN od_kiedy AND do_kiedy
		OR OdKiedy BETWEEN od_kiedy AND do_kiedy))
then
	rollback
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'ERROR';
end if;
if (OdKiedy < CURDATE() OR OdKiedy > DoKiedy)
then
	rollback
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'ERROR';
end if;
end$$



create trigger after_dodanie_karnetu after update on Stadion
for each row
begin
declare IdKarnetu INT;
set IdKarnetu = (select id_karnetu from Inserted);
if (IdKarnetu IS NOT NULL) then
declare IdMiejsca INT;
declare OdKiedy DATE;
declare DoKiedy DATE;
set IdMiejsca = (select id_miejsca from Inserted);
set DoKiedy = (select do_kiedy from Karnety as K join
				Inserted as I on I.id_karnetu = K.id_karnetu);
set OdKiedy = (select od_kiedy from Karnety as K join
				Inserted as I on I.id_karnetu = K.id_karnetu);
if exists (select id_miejsca from Bilety as B join 
			Terminarz as T on B.id_meczu = T.id_meczu
			where id_miejsca = IdMiejsca
			AND data BETWEEN OdKiedy AND DoKiedy) then
rollback;
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'ERROR';
end if;
end if;
end$$



create trigger after_Wypozyczenia_insert after insert on Wypozyczenia
for each row
begin
	if z is  null or do is null then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nie podano klubu z/do ktorego zawodnik jest wypozyczony! ';
	end if;
end;

create trigger before_Bonusy_update before update on Bonusy
for each row
begin
	if new.wyplacone <> 'tak' and new.wyplacone <> 'nie' then
		if new.wyplacone ='Tak' then
			set new.wyplacone = 'tak';
		elseif new.wyplacone ='Nie' then
			set new.wyplacone='nie';
		else
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'pole wyplacone musi zawierac wartosc "tak" lub "nie"';
		end if;
	end if;
    
    if new.id_kontraktu not in(
	select id_kontraktu
    from Kontrakty) then 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'dany kontrakt nie istnieje!';
	end if;
end$$

create trigger after_Zawodnicy_insert after insert on Zawodnicy
for each row
begin
	if new.id_kontraktu is not null and new.id_wypozyczenia is not null
    then
		rollback;
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Nie mozna wpisac id kontraktu oraz wypozyczenia do jednego zawodnika';
	end if;
end$$

create trigger after_Zawodnicy_delete after delete on Zawodnicy
for each row
begin 
	if old.id_kontraktu is not null
    then 
		delete from Kontrakty 
        where id_kontraktu = old.id_kontraktu;
    else
		delete from Wypozyczenia
        where id_wypozyczenia = old.id_wypozyczenia;
	end if;
end$$

create trigger before_Zawodnicy_delete before delete on Zawodnicy
FOR EACH ROW 
begin
	delete from Kontuzje  
    where old.id_zawodnika = id_zawodnika;
    
    delete from Zawieszenia 
    where old.id_zawodnika = z.id_zawodnika;
    
end$$

DELIMITER ;
