use klub;

create proc zaloz_karte_kibica (@nazwisko, @imie, @pesel, @miasto, @ulica, @email,@urodziny)
as
	declare @id_nowego_kibica int;
	insert intkibice(imie,nazwisko,pesel,miasto,ulica,email,data_urodzenia,karta_kibica)
    values (@imie, @nazwisko, @pesel, @miasto, @ulica, @email, @urodziny, 1);
	set @id_nowego_kibica = SCOPE_IDENTITY();
	
	insert into karnety (id_kibica, cena, od_kiedy, do_kiedy)
		values (@id_nowego_kibica, 120, getdate(), dateadd(day, 180, getdate()));
go;

