CREATE FUNCTION ZyskZBiletow (@IdMeczu INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @suma FLOAT
	SET @suma = (SELECT SUM(Cena) FROM Bilety WHERE id_meczu = @IdMeczu)
	RETURN @suma
END

CREATE FUNCTION MeczeWRoku (@Rok SMALLINT)
RETURNS @Tab TABLE (id_meczu INT, przeciwnik NVARCHAR(63), data DATE)
AS
BEGIN
INSERT INTO @Tab SELECT id_meczu, przeciwnik, data FROM terminarz
WHERE YEAR(data) = @Rok
RETURN
END

CREATE FUNCTION ZyskZKarnetow (@OdKiedy DATE, @DoKiedy DATE)
RETURNS FLOAT
AS
BEGIN
	DECLARE @suma FLOAT
	SET @suma = (SELECT SUM(Cena) FROM Karnety WHERE od_kiedy BETWEEN @OdKiedy AND @DoKiedy)
	RETURN @suma
END

CREATE FUNCTION IloscWidzow (@IdMeczu INT)
RETURNS INT
AS
BEGIN
	DECLARE @bilety INT
	DECLARE @karnety INT
	SET @bilety = (SELECT COUNT(*) FROM Bilety WHERE id_meczu = @IdMeczu)
	SET @karnety = (SELECT COUNT(*) FROM Stadion WHERE id_karnetu IS NOT NULL)
	RETURN @bilety + @karnety
END

CREATE FUNCTION NajczesciejRezerwowany (@OdKiedy DATETIME, @DoKiedy DATETIME)
RETURNS INT
AS
BEGIN
	DECLARE @id INT
	SET @id = (SELECT TOP 1 R.id_obiektu FROM [Rezerwacje obiektow] AS R
				JOIN (SELECT COUNT(*) AS suma, id_obiektu FROM [Rezerwacje obiektow]
					GROUP BY id_obiektu) AS S ON S.id_obiektu = R.id_obiektu
			ORDER BY suma DESC)
	RETURN @id
END

CREATE FUNCTION SredniaCenaBiletu (@OdKiedy DATE, @DoKiedy DATE, @PierwszyMecz INT, @OstatniMecz INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @srednia FLOAT
	SET @srednia = (SELECT AVG(cena) FROM Bilety AS B
					JOIN Kibice AS K ON K.id_kibica = B.id_kibica
					WHERE K.data_urodzenia BETWEEN @OdKiedy AND @DoKiedy 
					AND B.id_meczu BETWEEN @PierwszyMecz AND @OstatniMecz)
	RETURN @srednia
END


create function sprawdz_czy_zawodnik_jest_na_wypozyczeniu(@id int)
returns bit
begin
	declare @var bit;
   
    if @id not in (
    select p.id_wypozyczenia 
    from Zawodnicy as p inner join Wypozyczenia as l
    on p.id_wypozyczenia = l.id_wypozyczenia)
		set @var = 0;
	else
    set @var = 1;
    
    return @var;
end;
    
create function sprawdz_czy_zawodnik_moze_zagrac_w_danym_meczu(@id_zawodnika int, @data_meczu date)
returns bit
begin
	declare @bit_var bit;
	if @id_zawodnika not in(select id_zawodnika
		from Zawieszenia 
		where id_zawodnika = @id_zawodnika and @data_meczu < koniec_zawieszenia)
		set @bit_var = 1;
	else
		set @bit_var =0;
	
	if @id_zawodnika not in(select id_zawodnika
		from Kontuzje 
		where id_zawodnika = @id_zawodnika and @data_meczu < koniec_przerwy)
		set @bit_var = 1;
	else
		set @bit_var =0;	
	
		return @bit_var;
end;

create function ile_dni_do_konca_zawieszenia(@id int)
returns int 
begin
	declare @ilosc_dni int;
    declare @p date;
    set @p =
    (
		select TOP 1 koniec_zawieszenia
        from klub.Zawieszenia as z inner join klub.Zawodnicy as p
        on z.id_zawodnika = p.id_zawodnika
        where z.id_zawodnika = @id
		order by koniec_zawieszenia DESC
	);
    
    set @ilosc_dni = datediff(day,getdate(), @p);
    return @ilosc_dni;
end;

create function ile_do_konca_kontraktu(@id int) 
returns int 
begin
	declare @ilosc_dni int;
    declare @q date;
    set @q=
	(
		select top 1 koniec
        from klub.Kontrakty as k inner join klub.Zawodnicy as z
        on k.id_kontraktu = z.id_kontraktu
        where z.id_zawodnika = @id
		order by koniec
	);	
    set @ilosc_dni = datediff(day,getdate(),@q)
    
    return @ilosc_dni
end;

create function sprawdz_czy_dzial_ma_pracownikow(@id_dzialu)
returns bit
begin
	declare @bit_var bit;
	declare @ile_pracownikow smallint;
	set @ile_pracownikow =
	(
		select count(*)
		from Pracownicy
		where id_dzialu = @id_dzialu
	)
	if @ile_pracownikow >0
	set @bit_var = 1;
	else
	set @bit_var = 0;
	
	return @bit_var;
end;
	
