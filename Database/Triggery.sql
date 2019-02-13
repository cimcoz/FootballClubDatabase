GO
CREATE TRIGGER KartaKibica
ON Kibice
AFTER UPDATE
AS
IF UPDATE(karta_kibica)
BEGIN
UPDATE Kibice
SET znizka = 0.2
WHERE id_kibica IN (SELECT K.id_kibica FROM Kibice AS K
					JOIN Inserted AS I
					ON K.id_kibica = I.id_kibica)
END
GO

GO
CREATE TRIGGER KupnoBiletu
ON Bilety
INSTEAD OF INSERT
AS
IF EXISTS (SELECT I.id_miejsca FROM Inserted AS I
		JOIN Bilety AS B ON B.id_miejsca = I.id_miejsca
		WHERE B.id_meczu = I.id_meczu)
BEGIN
ROLLBACK
RAISERROR('Na jednym lub więcej miejsc jest już kupiony bilet!',16,1)
END
ELSE
BEGIN
IF EXISTS (SELECT id_kibica FROM Inserted AS I
		JOIN Stadion AS S ON S.id_miejsca = I.id_miejsca
		WHERE id_karnetu IS NOT NULL)
BEGIN
ROLLBACK
RAISERROR('Na jednym lub więcej miejsc jest przypisany karnet!',16,2)
END
ELSE
BEGIN
INSERT INTO Bilety SELECT * FROM Inserted
END
END
GO

GO
CREATE TRIGGER DodanieRezerwacji
ON [Rezerwacje obiektow]
AFTER INSERT
AS
DECLARE @IdObiektu INT
DECLARE @OdKiedy DATETIME
DECLARE @DoKiedy DATETIME
DECLARE @IdRezerwacji INT
--zakladamy ze dodajemy tylko pojedyncze rezerwacje
SET @IdObiektu = (SELECT id_obiektu FROM Inserted)
SET @OdKiedy = (SELECT od_kiedy FROM Inserted)
SET @DoKiedy = (SELECT do_kiedy FROM Inserted)
SET @IdRezerwacji = (SELECT id_rezerwacji FROM Inserted)
IF EXISTS (SELECT id_obiektu FROM [Rezerwacje obiektow]
		WHERE id_obiektu = @IdObiektu AND id_rezerwacji != @IdRezerwacji
		AND (@DoKiedy BETWEEN od_kiedy AND do_kiedy
		OR @OdKiedy BETWEEN od_kiedy AND do_kiedy))
BEGIN
	ROLLBACK
	RAISERROR('Dany obiekt jest juz zarezerwowany w podanym terminie!', 16, 1)
END
IF @OdKiedy < GETDATE() OR @OdKiedy > @DoKiedy
BEGIN
	ROLLBACK
	RAISERROR('Ta data jest bledna lub nieaktualna!', 16, 2)
END
GO

GO
CREATE TRIGGER DodanieKarnetu
ON Stadion
AFTER UPDATE
AS
DECLARE @IdKarnetu INT
SET @IdKarnetu = (SELECT id_karnetu FROM Inserted)
IF UPDATE(id_karnetu) AND @IdKarnetu IS NOT NULL
BEGIN
DECLARE @IdMiejsca INT
DECLARE @OdKiedy DATE
DECLARE @DoKiedy DATE
SET @IdMiejsca = (SELECT id_miejsca FROM Inserted)
SET @DoKiedy = (SELECT do_kiedy FROM Karnety AS K JOIN
				Inserted AS I ON I.id_karnetu = K.id_karnetu)
SET @OdKiedy = (SELECT od_kiedy FROM Karnety AS K JOIN
				Inserted AS I ON I.id_karnetu = K.id_karnetu)
IF EXISTS (SELECT id_miejsca FROM Bilety AS B JOIN 
			Terminarz AS T ON B.id_meczu = T.id_meczu
			WHERE id_miejsca = @IdMiejsca
			AND data BETWEEN @OdKiedy AND @DoKiedy)
BEGIN
ROLLBACK
RAISERROR('Do tego miejsca, w podanym okresie czasu jest juz przypisany bilet!', 16, 1)
END
END
GO

GO
CREATE TRIGGER DodanieMeczow
ON Terminarz
INSTEAD OF INSERT
AS
INSERT INTO Terminarz SELECT * FROM Inserted AS I
WHERE NOT EXISTS (SELECT data FROM Terminarz AS T WHERE T.data = I.data )
GO


go
create trigger after_Wypozyczenia_insert 
on Wypozyczenia
after insert
as
	if exists(select * from inserted where z is null or do is null)
	begin
		rollback
		raiserror('Nie podano klubu z/do ktorego zawodnik jest wypozyczony! ',16,1);
	end;
go


go
create trigger before_Bonusy_update on Bonusy after update
as
declare @wyplacone varchar(3);
declare @nowe_id int;
set @wyplacone=(select wyplacone
	from inserted)
if @wyplacone <> 'tak' and @wyplacone <> 'nie' begin
	if @wyplacone ='Tak' 
		set @wyplacone = 'tak';
	else 
		begin
		if @wyplacone ='Nie' 
			set @wyplacone='nie';
		else
		begin
			rollback
			raiserror('pole wyplacone musi zawierac wartosc "tak" lub "nie"',16,1)
		end ;
	end ;
end;
set @nowe_id =(select id_kontraktu
				from inserted)
if @nowe_id not in(
	select id_kontraktu
    from Kontrakty) begin 
		rollback;
		raiserror('dany kontrakt nie istnieje!',16,1);
	end;
go

go
create trigger after_Zawodnicy_insert on Zawodnicy after insert 
as
	if exists (select * from inserted where id_wypozyczenia is not null and id_kontraktu is not null)
    begin
		rollback;
		raiserror('Nie mozna wpisac id kontraktu oraz wypozyczenia do jednego zawodnika',16,1);
	end ;
go

go
create trigger after_Zawodnicy_delete on Zawodnicy after delete 
as 
declare @stare_id_kontraktu int;
declare @stare_id_wypozyczenia int;
set @stare_id_kontraktu = (select id_wypozyczenia
							from deleted);
set @stare_id_kontraktu = (select id_kontraktu
							from deleted);
	if @stare_id_kontraktu is not null
    begin 
		delete from Kontrakty 
        where id_kontraktu = @stare_id_kontraktu;
		end;	
    else
	begin
		delete from Wypozyczenia
        where id_wypozyczenia = @stare_id_wypozyczenia;
	end;
go


go 
create trigger after_Kontrakty_insert  on Kontrakty after insert
	as
	declare @start_date date;
	declare @end_date date;
	set @start_date =(select poczatek
					from inserted);
	set @start_date =(select koniec	
					from inserted);				
	if @start_date < getdate() or @end_date < @start_date 
		begin
		rollback;
		raiserror('Data  kontraktu jest nieprawidlowa!',16,1)
		end;
go

go
create trigger after_Wypozyczenia_update on Wypozyczenia after update
	as
	declare @start_date date;
	declare @end_date date;
	set @start_date =(select poczatek
					from inserted);
	set @start_date =(select koniec	
					from inserted);				
	if @start_date < getdate() or @end_date < @start_date 
		begin
		rollback;
		raiserror('Data  wypozyczenia jest nieprawidlowa!',16,1)
		end;
go	