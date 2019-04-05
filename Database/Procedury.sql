delimiter $$

create procedure AktualizacjaKarnetow()
begin
start transaction;
update Stadion
set id_karnetu = NULL
where id_karnetu in (select id_karnetu from Karnety
					where do_kiedy < curdate() and id_karnetu IS NOT NULL);
commit;
end$$


drop procedure if exists wypozycz_zawodnika;
create procedure wypozycz_zawodnika(
in poczatek_wypozyczenia date,
in koniec_wypozyczenia date,
in miesieczne_wynagrodze_zawodnika int,
in kwota_pierwokupu_zaw int,
in klub_pierwotny varchar(30),
in nazwisko_zawodnika varchar(30),
in imie_zawodnika varchar(30),
in pozycja_na_boisku varchar(3),
in preferowana_noga_zawodnika varchar(5))
begin
	declare id_nowego_wypozyczenia int;
    
    insert into Wypozyczenia(poczatek,koniec,miesieczne_wynagrodzenie,kwota_pierwokupu,z,do)
    values(poczatek_wypozyczenia, koniec_wypozyczenia, miesieczne_wynagrodzenie_zawodnika,kwota_pierwokupu_zaw, klub_pierwotny, 'klub');
    set id_nowego_wypozyczenia = last_insert_id();
    
    insert into Zawodnicy(nazwisko,imie,pozycja,preferowana_noga,id_kontraktu,id_wypozyczenia)
    values (nazwisko_zawodnika,imie_zawodnika,pozycja_na_boisku,preferowana_noga_zawodnika, null, id_nowego_wypozyczenia);
end$$


drop procedure if exists podpisz_kontrakt_z_nowym_zawodnikiem;
create procedure podpisz_kontrakt_z_nowym_zawodnikiem(
in poczatek_kontraktu date,
in koniec_kontraktu date,
in miesieczne_wynagrodzenie_w_kontrakcie int,
in klauzula_wykupu_zawodnika int,
in nazwisko_zawodnika varchar(30),
in imie_zawodnika varchar(30),
in pozycja_na_boisku varchar(3),
in preferowana_noga_zawodnika varchar(5))
begin
	declare id_wprowadzonego_kontraktu int;
	insert into Kontrakty(poczatek,koniec,miesieczne_wynagrodzenia,klauzula_wykupu)
    values (poczatek_kontraktu, koniec_kontraktu, miesieczne_wynagrodzenie_w_kontrakcie,klauzula_wykupu_zawodnika);
    set id_wprowadzonego_kontraktu = last_insert_id();
    
	insert into Zawodnicy(nazwisko,imie,pozycja,preferowana_noga,id_kontraktu,id_wypozyczenia)
    values (nazwisko_zawodnika, imie_zawodnika, pozycja_na_boisku,preferowana_noga_zawodnika, id_wprowadzonego_kontraktu, null);
end$$


drop procedure if exists niewyplacone_bonusy_zawodnika;
create procedure niewyplacone_bonusy_zawodnika (in id_zawodnika int unsigned)
begin 
	select nazwisko, imie
    from klub.Zawodnicy as z
    inner join klub.Kontrakty as k
    on k.id_kontraktu = z.id_kontraktu
    inner join klub.Bonusy as b
    on b.id_kontraktu = b.id_kontraktu
	where z.id_zawodnika = id_zawodnika and b.wyplacone = 'nie';

end$$

drop  procedure if exists statystyki_zawodnika;
create procedure statystyki_zawodnika 
(in id_zawodnika int unsigned,
 out bramki int unsigned, 
 out asysty int unsigned,
 out wystepy int unsigned)
begin
	select z.bramki into bramki
    from klub.Zawodnicy as z
    where z.id_zawodnika = id_zawodnika;
    
    select z.asysty into asysty
	from klub.Zawodnicy as z
    where z.id_zawodnika = id_zawodnika;
    
    select z.wystepy into wystepy
	from klub.Zawodnicy as z
    where z.id_zawodnika = id_zawodnika;
    
end$$

    
drop procedure if exists historia_kontuzji_zawodnika;
create procedure historia_kontuzji_zawodnika (in id_zawodnika int unsigned)
begin 
	select nazwisko, imie, nazwa_urazu, poczatek_przerwy, koniec_przerwy
    from klub.Kontuzje as k inner join klub.Zawodnicy as z
    on k.id_zawodnika = z.id_zawodnika 
    where k.id_zawodnika = id_zawodnika;
    order by k.
end$$



drop procedure if exists konczace_sie_kontrakty_za_n_dni;
create procedure konczace_sie_kontrakty(in dni int unsigned)
begin 
	select nazwisko, imie, koniec as kontrakt_wygasa
    from klub.Kontrakty as k
    inner join klub.Zawodnicy as z
    on k.id_zawodnika = z.id_zawodnika
    where koniec >=   current_date() + interval okres day;
end$$







create procedure zaloz_karte_kibica (in nazwisko varchar(30), in imie varchar(30), in pesel varchar(30), in miasto varchar(30), 
	in ulica varchar(30), in email varchar(30),in urodziny varchar(30),in dlugosc_karnetu int)
begin
	declare id_nowego_kibica int;
	declare nastepne_id int;
	set nastepne_id = (select max(id_kibica) from kibice);
	if  nastepne_id is null then
		set nastepne_id = 1;
	else
		set nastepne_id = nastepne_id + 1;
	end if;
	insert into kibice(id_kibica,imie,nazwisko,pesel,miasto,ulica,email,data_urodzenia,karta_kibica)
    values (nastepne_id,imie, nazwisko, pesel, miasto, ulica, email, urodziny, 1);
	set id_nowego_kibica =  last_insert_id();
	
		set nastepne_id = (select max(id_karnetu) from karnety);
		if nastepne_id is null then
			set nastepne_id = 1;
		else
			set @nastepne_id = @nastepne_id + 1;
		 end if;
	insert into karnety (id_karnetu,id_kibica, cena, od_kiedy, do_kiedy)
		values (nastepne_id,id_nowego_kibica, 120, getdate(), date_add(curdate(), interval dlugosc_karnetu day));
end$$

create procedure edytuj_informacje_kibica (in nowe_nazwisko varchar(30), in nowe_imie varchar(30), in p_pesel varchar(30),
		in nowe_miasto varchar(30), in nowa_ulica varchar(30), in nowy_email varchar(30),in nowe_urodziny varchar(30))
begin
	update kibice
	set nazwisko = nowe_nazwisko, imie = nowe_imie, miasto = nowe_miasto, ulica = @nowa_ulica, email = nowy_email, data_urodzenia = nowa_data_urodzenia
	where pesel = p_pesel;
end$$


create procedure przedluz_karnet(in pesel varchar(30), in email varchar(30), in ile_dni int)
begin
	declare id_kibica int;
	set id_kibica = (select id_kibica from kibice where pesel = pesel);
	
	update karnety 
	set do_kiedy = date_add(do_kiedy, interval ile_dni day)
	where id_kibica = id_kibica;
end$$