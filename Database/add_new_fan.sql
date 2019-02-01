use klub;

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