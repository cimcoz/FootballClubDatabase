CREATE DATABASE Klub

USE Klub

CREATE TABLE bilety (
    id_miejsca   INTEGER NOT NULL,
    id_kibica    INTEGER NOT NULL,
    id_meczu     INTEGER NOT NULL,
    cena         money NOT NULL
)

CREATE NONCLUSTERED INDEX 
    Bilety__IDX ON Bilety 
    ( 
     id_meczu 
    ) 

CREATE nonclustered index bilety__idxv1 ON bilety ( id_kibica )


ALTER TABLE Bilety ADD constraint bilety_pk PRIMARY KEY CLUSTERED (id_kibica, id_meczu)

CREATE TABLE karnety (
    id_karnetu   INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
    id_kibica    INTEGER NOT NULL,
    cena         money NOT NULL,
    od_kiedy     DATE NOT NULL,
    do_kiedy     DATE NOT NULL
)

CREATE nonclustered index karnety__idx ON karnety(od_kiedy,do_kiedy)


CREATE TABLE kibice 
    (
    id_kibica   INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
    imie        nvarchar (64) NOT NULL , 
     nazwisko NVARCHAR (64) NOT NULL , 
     pesel NVARCHAR (10) NOT NULL , 
     miasto NVARCHAR (64) NOT NULL , 
     ulica NVARCHAR (64) NOT NULL , 
     email NVARCHAR (64) , 
     data_urodzenia DATE NOT NULL,
znizka float,
karta_kibica bit )

CREATE NONCLUSTERED INDEX 
    Kibice__IDX ON Kibice 
    ( 
     nazwisko , 
     imie 
    ) 

CREATE nonclustered index kibice__idxv1 ON kibice ( data_urodzenia )

CREATE TABLE "Obiekty sportowe" 
    (
    id_obiektu   INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
    adres        nvarchar (128) NOT NULL , 
     nazwa NVARCHAR (64) NOT NULL ,uwagi nvarchar(256) )


CREATE TABLE "Rezerwacje obiektow" (
    id_rezerwacji      INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
    id_obiektu         INTEGER NOT NULL,
    id_rezerwujacego   INTEGER NOT NULL,
    od_kiedy           DATETIME NOT NULL,
    do_kiedy           DATETIME NOT NULL
)

CREATE nonclustered index "Rezerwacje obiektow__IDX" ON "Rezerwacje obiektow"(od_kiedy,do_kiedy) 

CREATE TABLE rezerwujacy 
    (
    id_rezerwujacego   INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
    nazwa              nvarchar (64) NOT NULL ) 

CREATE TABLE stadion (
    id_miejsca   INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
    sektor       tinyint NOT NULL,
    rzad         tinyint NOT NULL,
    miejsce      tinyint NOT NULL,
    id_karnetu   INTEGER
)


CREATE TABLE terminarz 
    (
    id_meczu     INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
    data         DATE NOT NULL,
    przeciwnik   nvarchar (64) NOT NULL , 
     rozgrywki NVARCHAR (64) NOT NULL , 
     stadion NVARCHAR (64) NOT NULL ) 

ALTER TABLE Bilety
    ADD CONSTRAINT bilety_kibice_fk FOREIGN KEY ( id_kibica )
        REFERENCES kibice ( id_kibica )

ALTER TABLE Bilety
    ADD CONSTRAINT bilety_stadion_fk FOREIGN KEY ( id_miejsca )
        REFERENCES stadion ( id_miejsca )

ALTER TABLE Bilety
    ADD CONSTRAINT bilety_terminarz_fk FOREIGN KEY ( id_meczu )
        REFERENCES terminarz ( id_meczu )

ALTER TABLE Karnety
    ADD CONSTRAINT karnety_kibice_fk FOREIGN KEY ( id_kibica )
        REFERENCES kibice ( id_kibica )

ALTER TABLE "Rezerwacje obiektow" ADD CONSTRAINT "Rezerwacje obiektow_Obiekty sportowe_FK" FOREIGN KEY ( id_obiektu )
    REFERENCES "Obiekty sportowe" (id_obiektu) 

ALTER TABLE "Rezerwacje obiektow"
    ADD CONSTRAINT "Rezerwacje obiektow_Rezerwujacy_FK" FOREIGN KEY ( id_rezerwujacego )
        REFERENCES rezerwujacy ( id_rezerwujacego )

ALTER TABLE Stadion
    ADD CONSTRAINT table_5_karnety_fk FOREIGN KEY ( id_karnetu )
        REFERENCES karnety ( id_karnetu )


create table Dzial_pracowniczy
(
	id_dzialu smallint identity(1,1) primary key,
	nazwa varchar(30) NOT NULL unique,
    miesieczne_wynagrodzenie int NOT NULL
);
create table Pracownicy
(
	id_pracownika smallint identity(1,1) primary key,
	id_dzialu smallint,
    nazwisko varchar(30) NOT NULL,
    imie varchar(30),
    foreign key (id_dzialu) references Dzial_pracowniczy(id_dzialu)
);

create table Kontrakty
(
	id_kontraktu smallint identity(1,1) primary key,
    poczatek date not null,
    koniec date not null,
    miesieczne_wynagrodzenie int not null,
    klauzula_wykupu int null
);
create table Wypozyczenia
(
	id_wypozyczenia smallint identity(1,1) primary key,
	z varchar(30) NULL,
	do varchar(30) NOT NULL,
    poczatek date not null,
    koniec date not null,
	miesieczne_wynagrodzenie int not null,
    cena_pierwokupu bit null,
);
create table Bonusy
(
	id_kontraktu smallint,
    nazwa_bonusu varchar(50) NOT NULL,
    kwota int NOT NULL,
	wyplacone varchar(3) NOT NULL,
    foreign key (id_kontraktu) references Kontrakty(id_kontraktu)
);
create table Zawodnicy
(
	id_zawodnika smallint identity(1,1) primary key,
    nazwisko varchar(30) NOT NULL,
    imie varchar(20),
    pozycja varchar(3) NOT NULL,
    preferowana_noga varchar(1) NOT NULL,
    id_kontraktu smallint NULL unique,
    id_wypozyczenia smallint NULL unique,
	bramki int not null default 0,
	asysty int not null default 0,
	rozegrane_mecze int not null default 0,
    foreign key (id_kontraktu)  references Kontrakty(id_kontraktu) ,
    foreign key (id_wypozyczenia) references Wypozyczenia(id_wypozyczenia) 
);
create table Kontuzje
(
	id_kontuzji int identity(1,1) primary key,
	id_zawodnika smallint,
    nazwa_urazu varchar(40) NOT NULL,
    poczatek_przerwy date NOT NULL,
    koniec_przerwy date NOT NULL,
    foreign key (id_zawodnika) references Zawodnicy(id_zawodnika) 
);
create table Zawieszenia
(
	id_zawieszenia int identity(1,1) primary key,
	id_zawodnika smallint unique,
    poczatek_zawieszenia date not null,
    koniec_zawieszenia date not null,
    kara_finansowa int,
    foreign key (id_zawodnika) references Zawodnicy(id_zawodnika) 
);
    

create unique index id_zawodnika on Zawodnicy(id_zawodnika);

create unique index nazwisko_imie_zawodnika on Zawodnicy(nazwisko,imie);


create unique index id_kontr on Kontrakty(id_kontraktu);


create unique index zawieszenia_id on Zawieszenia(id_zawieszenia, id_zawodnika);


create unique index wypozyczenia_id_czas on Wypozyczenia(id_wypozyczenia, koniec);


create unique index kontuzje_id_koniec on Kontuzje(id_zawodnika, koniec_przerwy);