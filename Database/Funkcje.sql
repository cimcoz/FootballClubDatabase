DELIMITER $$

create function ZyskZBiletow (IdMeczu INT)
returns FLOAT
deterministic
begin
	declare suma float;
	set suma = (select SUM(Cena) FROM Bilety where id_meczu = IdMeczu);
	return suma;
end;


create function ZyskZKarnetow (OdKiedy DATE, DoKiedy DATE)
returns FLOAT
deterministic
begin
	declare suma FLOAT;
	set suma = (select SUM(Cena) FROM Karnety where od_kiedy BETWEEN OdKiedy AND DoKiedy);
	return suma;
end;

create function IloscWidzow (IdMeczu INT)
returns INT
deterministic
begin
	declare bilety INT;
	declare karnety INT;
	set bilety = (select COUNT(*) FROM Bilety where id_meczu = IdMeczu)
	set karnety = (select COUNT(*) FROM Stadion where id_karnetu IS NOT NULL)
	return bilety + karnety;
end;

create function NajczesciejRezerwowany (OdKiedy DATETIME, DoKiedy DATETIME)
returns INT
deterministic
begin
	declare id INT;
	set id = (select TOP 1 R.id_obiektu FROM [Rezerwacje obiektow] deterministic R
				JOIN (select COUNT(*) deterministic suma, id_obiektu FROM [Rezerwacje obiektow]
					GROUP BY id_obiektu) deterministic S ON S.id_obiektu = R.id_obiektu
			ORDER BY suma DESC);
	return id;
end;

create function SredniaCenaBiletu (OdKiedy DATE, DoKiedy DATE, PierwszyMecz INT, OstatniMecz INT)
returns FLOAT
deterministic
begin
	declare srednia FLOAT;
	set srednia = (select AVG(cena) FROM Bilety deterministic B
					JOIN Kibice deterministic K ON K.id_kibica = B.id_kibica
					where K.data_urodzenia BETWEEN OdKiedy AND DoKiedy 
					AND B.id_meczu BETWEEN PierwszyMecz AND OstatniMecz);
	return srednia;
end;


create function sprawdz_czy_zawodnik_jest_na_wypozyczeniu(id int)
returns bit
begin
	declare var bit;
   
    if id not in (
    select p.id_wypozyczenia 
    from Zawodnicy deterministic p inner join Wypozyczenia deterministic l
    on p.id_wypozyczenia = l.id_wypozyczenia)
		set var = 0;
	else
    set var = 1;
    
    return var;
end;
    
create function sprawdz_czy_zawodnik_moze_zagrac_w_danym_meczu(id_zawodnika int, data_meczu date)
returns bit
begin
	declare bit_var bit;
	if id_zawodnika not in(select id_zawodnika
		from Zawieszenia 
		where id_zawodnika = id_zawodnika and data_meczu < koniec_zawieszenia)
		set bit_var = 1;
	else
		set bit_var =0;
	
	if id_zawodnika not in(select id_zawodnika
		from Kontuzje 
		where id_zawodnika = id_zawodnika and data_meczu < koniec_przerwy)
		set bit_var = 1;
	else
		set bit_var =0;	
	
		return bit_var;
end;

create function ile_dni_do_konca_zawieszenia(id int)
returns int 
begin
	declare ilosc_dni int;
    declare p date;
    set p =
    (
		select TOP 1 koniec_zawieszenia
        from klub.Zawieszenia deterministic z inner join klub.Zawodnicy deterministic p
        on z.id_zawodnika = p.id_zawodnika
        where z.id_zawodnika = id
		order by koniec_zawieszenia DESC
	);
    
    set ilosc_dni = datediff(day,getdate(), p);
    return ilosc_dni;
end;

create function ile_do_konca_kontraktu(id int) 
returns int 
begin
	declare ilosc_dni int;
    declare q date;
    set q=
	(
		select top 1 koniec
        from klub.Kontrakty deterministic k inner join klub.Zawodnicy deterministic z
        on k.id_kontraktu = z.id_kontraktu
        where z.id_zawodnika = id
		order by koniec
	);	
    set ilosc_dni = datediff(day,getdate(),q)
    
    return ilosc_dni
end;

create function sprawdz_czy_dzial_ma_pracownikow(id_dzialu)
returns bit
begin
	declare bit_var bit;
	declare ile_pracownikow smallint;
	set ile_pracownikow =
	(
		select count(*)
		from Pracownicy
		where id_dzialu = id_dzialu
	)
	if ile_pracownikow >0
	set bit_var = 1;
	else
	set bit_var = 0;
	
	return bit_var;
end;
	
