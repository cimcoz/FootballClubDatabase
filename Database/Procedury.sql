CREATE PROC RezerwacjeObiektu (@IdObiektu INT)
AS
SELECT O.nazwa, R.*
FROM [Rezerwacje obiektow] AS R JOIN [Obiekty sportowe] AS O
ON R.id_obiektu = O.id_obiektu
WHERE R.id_obiektu = @IdObiektu
GO

CREATE PROC BiletyKibica (@IdKibica INT)
AS
SELECT K.imie, K.nazwisko, S.*, B.cena, T.data, T.przeciwnik
FROM Bilety AS B JOIN Kibice AS K ON B.id_kibica = K.id_kibica
JOIN Stadion AS S ON S.id_miejsca = B.id_miejsca
JOIN Terminarz AS T ON T.id_meczu = B.id_meczu
WHERE B.id_kibica = @IdKibica
GO

CREATE PROC AktualizacjaKarnetow
AS
DECLARE @TranCounter INT
SET @TranCounter = @@TRANCOUNT
IF @TranCounter = 0
	BEGIN TRAN Tr1
ELSE
	SAVE TRAN Tr1
UPDATE Stadion
SET id_karnetu = NULL
WHERE id_karnetu IN (SELECT id_karnetu FROM Karnety
					WHERE do_kiedy < GETDATE() AND id_karnetu IS NOT NULL)
COMMIT
GO

CREATE PROC BiletyZeZnizka (@IdMeczu INT, @DataOd DATE, @DataDo DATE)
AS
SELECT K.imie, K.nazwisko, K.znizka, B.cena
FROM Bilety AS B JOIN Kibice AS K ON B.id_kibica = K.id_kibica
WHERE K.znizka > 0 AND B.id_meczu = @IdMeczu
AND K.data_urodzenia BETWEEN @DataOd AND @DataDo
ORDER BY K.znizka
GO

CREATE PROC NowiKibice (@IdMeczu INT)
AS
DECLARE @DataMeczu DATE
SET @DataMeczu = (SELECT data FROM Terminarz
				WHERE id_meczu = @IdMeczu)
SELECT *
FROM Kibice
WHERE id_kibica NOT IN (SELECT id_kibica
					FROM Bilety AS B JOIN Terminarz AS T
					ON B.id_meczu = T.id_meczu
					WHERE B.id_meczu != @IdMeczu
					AND T.data < @DataMeczu)
GO

CREATE PROC PokazRezerwacje (@Od DATE, @Do DATE)
AS
SELECT RO.id_rezerwacji, O.nazwa, R.nazwa, RO.od_kiedy, RO.do_kiedy
FROM [Rezerwacje obiektow] AS RO JOIN rezerwujacy AS R ON RO.id_rezerwujacego=R.id_rezerwujacego
JOIN [Obiekty sportowe] AS O ON RO.id_obiektu=O.id_obiektu
WHERE od_kiedy BETWEEN @Od AND @Do
GO

create procedure wypozycz_zawodnika(
@poczatek_wypozyczenia date,
@koniec_wypozyczenia date,
@miesieczne_wynagrodzenie_zawodnika int,
@kwota_pierwokupu_zaw int,
@klub_pierwotny varchar(30),
@nazwisko_zawodnika varchar(30),
@imie_zawodnika varchar(30),
@pozycja_na_boisku varchar(3),
@preferowana_noga_zawodnika varchar(5))
as
	declare @id_nowego_wypozyczenia int;
    
    insert into Wypozyczenia(poczatek,koniec,miesieczne_wynagrodzenie,cena_pierwokupu,z,do)
    values(@poczatek_wypozyczenia, @koniec_wypozyczenia, @miesieczne_wynagrodzenie_zawodnika,@kwota_pierwokupu_zaw, @klub_pierwotny, 'klub');
    
	set @id_nowego_wypozyczenia = SCOPE_IDENTITY();
    
    insert into Zawodnicy(nazwisko,imie,pozycja,preferowana_noga,id_kontraktu,id_wypozyczenia)
    values (@nazwisko_zawodnika,@imie_zawodnika,@pozycja_na_boisku,@preferowana_noga_zawodnika, null, @id_nowego_wypozyczenia)
	go



create procedure podpisz_kontrakt_z_nowym_zawodnikiem(
@poczatek_kontraktu date,
@koniec_kontraktu date,
@miesieczne_wynagrodzenie_w_kontrakcie int,
@klauzula_wykupu_zawodnika int,
@nazwisko_zawodnika varchar(30),
@imie_zawodnika varchar(30),
@pozycja_na_boisku varchar(3),
@preferowana_noga_zawodnika varchar(5))
as
	declare @id_wprowadzonego_kontraktu int;
	insert into Kontrakty(poczatek,koniec,miesieczne_wynagrodzenie,klauzula_wykupu)
    values (@poczatek_kontraktu, @koniec_kontraktu, @miesieczne_wynagrodzenie_w_kontrakcie,@klauzula_wykupu_zawodnika);
    set @id_wprowadzonego_kontraktu = SCOPE_IDENTITY();
    
	insert into Zawodnicy(nazwisko,imie,pozycja,preferowana_noga,id_kontraktu,id_wypozyczenia)
    values (@nazwisko_zawodnika, @imie_zawodnika, @pozycja_na_boisku,@preferowana_noga_zawodnika, @id_wprowadzonego_kontraktu, null);
go


create procedure niewyplacone_bonusy_zawodnika (@id_zawodnika smallint)
as 
	select nazwisko, imie
    from  Zawodnicy as z
    inner join  Kontrakty as k
    on k.id_kontraktu = z.id_kontraktu
    inner join  Bonusy as b
    on b.id_kontraktu = b.id_kontraktu
	where z.id_zawodnika = id_zawodnika and b.wyplacone = 'nie';

go

create procedure statystyki_zawodnika 
(@id_zawodnika smallint,
  @bramki smallint output, 
  @asysty smallint output,
 @wystepy smallint output)
as
	set @bramki =(select z.bramki 
    from  Zawodnicy as z
    where z.id_zawodnika = id_zawodnika)
    
    set @asysty=(select z.asysty 
	from  Zawodnicy as z
    where z.id_zawodnika = id_zawodnika)
    
    set @wystepy=(select z.rozegrane_mecze
	from  Zawodnicy as z
    where z.id_zawodnika = id_zawodnika)
    
go
    
create procedure historia_kontuzji_zawodnika (@id_zawodnika smallint)
as 
	select nazwisko, imie, nazwa_urazu, poczatek_przerwy, koniec_przerwy
    from  Kontuzje as k inner join  Zawodnicy as z
    on k.id_zawodnika = z.id_zawodnika 
    where k.id_zawodnika = @id_zawodnika
    order by k.poczatek_przerwy;
go



create procedure konczace_sie_kontrakty(@dni smallint)
as 
	select nazwisko, imie, koniec as kontrakt_wygasa
    from  Kontrakty as k
    inner join  Zawodnicy as z
    on k.id_kontraktu = z.id_kontraktu
    where koniec <= dateadd(day, @dni, getdate());
go

create procedure czyszczenie_historii_zawodnika (@id_zawodnika smallint)
	as
	delete from Kontuzje 
	where id_zawodnika = @id_zawodnika;
		
	delete from Zawieszenia
	where id_zawodnika=@id_zawodnika;
go


create proc zaloz_karte_kibica (@nazwisko varchar(30), @imie varchar(30), @pesel varchar(30), @miasto varchar(30), 
	@ulica varchar(30), @email varchar(30),@urodziny varchar(30),@dlugosc_karnetu int)
as
	declare @id_nowego_kibica int;
	declare @nastepne_id int;
	set @nastepne_id = (select max(id_kibica) from kibice);
	if @nastepne_id is null
		set @nastepne_id = 1;
	else
		set @nastepne_id = @nastepne_id + 1;
		
	insert into kibice(id_kibica,imie,nazwisko,pesel,miasto,ulica,email,data_urodzenia,karta_kibica)
    values (@nastepne_id,@imie, @nazwisko, @pesel, @miasto, @ulica, @email, @urodziny, 1);
	set @id_nowego_kibica = SCOPE_IDENTITY();
	
		set @nastepne_id = (select max(id_karnetu) from karnety);
		if @nastepne_id is null
			set @nastepne_id = 1;
		else
			set @nastepne_id = @nastepne_id + 1;
	insert into karnety (id_karnetu,id_kibica, cena, od_kiedy, do_kiedy)
		values (@nastepne_id,@id_nowego_kibica, 120, getdate(), dateadd(day, @dlugosc_karnetu, getdate()));
go;


create proc edytuj_informacje_kibica (@nazwisko varchar(30), @imie varchar(30), @pesel varchar(30),
		@miasto varchar(30), @ulica varchar(30), @email varchar(30),@urodziny varchar(30))
as
	update kibice
	set nazwisko = @nazwisko, imie = @imie, miasto = @miasto, ulica = @ulica, email = @email, data_urodzenia = @data_urodzenia
	where pesel = @pesel;
go;


create proc przedluz_karnet(@pesel varchar(30), @email varchar(30), @ile_dni int)
as
	declare @id_kibica int;
	set @id_kibica = (select id_kibica from kibice where pesel = @pesel);
	
	update karnety 
	set do_kiedy = dateadd(day, @ile_dni, do_kiedy)
	where id_kibica = @id_kibica;
go;