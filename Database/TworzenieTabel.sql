CREATE DATABASE Klub;

USE Klub;

create table bilety (
    id_miejsca   INTEGER NOT NULL,
    id_kibica    INTEGER NOT NULL,
    id_meczu     INTEGER NOT NULL,
    cena         DECIMAL(12,2) NOT NULL
);


create unique index bilety__idxv1 ON bilety ( id_kibica );


alter table Bilety ADD constraint bilety_pk PRIMARY KEY CLUSTERED (id_kibica, id_meczu);

create table karnety (
    id_karnetu   INTEGER NOT NULL auto_increment PRIMARY KEY,
    id_kibica    INTEGER NOT NULL,
    cena         DECIMAL(12,2) NOT NULL,
    od_kiedy     DATE NOT NULL,
    do_kiedy     DATE NOT NULL
);

create unique index karnety__idx ON karnety(od_kiedy,do_kiedy);


create table kibice 
    (
    id_kibica   INTEGER NOT NULL auto_increment PRIMARY KEY,
    imie        nvarchar (64) NOT NULL , 
     nazwisko NVARCHAR (64) NOT NULL , 
     pesel NVARCHAR (10) NOT NULL , 
     miasto NVARCHAR (64) NOT NULL , 
     ulica NVARCHAR (64) NOT NULL , 
     email NVARCHAR (64) , 
     data_urodzenia DATE NOT NULL,
znizka float,
karta_kibica bit );

create unique INDEX 
    Kibice__IDX ON Kibice 
    ( 
     nazwisko , 
     imie 
    ) ;

create unique index kibice__idxv1 ON kibice ( data_urodzenia );

create table Obiekty_sportowe
    (
    id_obiektu   INTEGER NOT NULL auto_increment PRIMARY KEY,
    adres        nvarchar (128) NOT NULL , 
     nazwa NVARCHAR (64) NOT NULL ,uwagi nvarchar(256) 
     );


create table Rezerwacje_obiektow(
    id_rezerwacji      INTEGER NOT NULL auto_increment PRIMARY KEY,
    id_obiektu         INTEGER NOT NULL,
    id_rezerwujacego   INTEGER NOT NULL,
    od_kiedy           DATETIME NOT NULL,
    do_kiedy           DATETIME NOT NULL
);

create unique index Rezerwacje_obiektow__IDX ON Rezerwacje_obiektow(od_kiedy,do_kiedy) ;

create table rezerwujacy 
    (
    id_rezerwujacego   INTEGER NOT NULL auto_increment PRIMARY KEY,
    nazwa              nvarchar (64) NOT NULL 
    ); 

create table stadion (
    id_miejsca   INTEGER NOT NULL auto_increment PRIMARY KEY,
    sektor       tinyint NOT NULL,
    rzad         tinyint NOT NULL,
    miejsce      tinyint NOT NULL,
    id_karnetu   INTEGER
);


create table terminarz 
    (
    id_meczu     INTEGER NOT NULL auto_increment PRIMARY KEY,
    data         DATE NOT NULL,
    przeciwnik   nvarchar (64) NOT NULL , 
     rozgrywki NVARCHAR (64) NOT NULL , 
     stadion NVARCHAR (64) NOT NULL ) ;

alter table Bilety
    ADD CONSTRAINT bilety_kibice_fk FOREIGN KEY ( id_kibica )
        REFERENCES kibice ( id_kibica );

alter table Bilety
    ADD CONSTRAINT bilety_stadion_fk FOREIGN KEY ( id_miejsca )
        REFERENCES stadion ( id_miejsca );

alter table Bilety
    ADD CONSTRAINT bilety_terminarz_fk FOREIGN KEY ( id_meczu )
        REFERENCES terminarz ( id_meczu );

alter table Karnety
    ADD CONSTRAINT karnety_kibice_fk FOREIGN KEY ( id_kibica )
        REFERENCES kibice ( id_kibica );


alter table Stadion
    ADD CONSTRAINT table_5_karnety_fk FOREIGN KEY ( id_karnetu )
        REFERENCES karnety ( id_karnetu );


create table Dzial_pracowniczy
(
	id_dzialu smallint auto_increment primary key,
	nazwa varchar(30) NOT NULL unique,
    miesieczne_wynagrodzenie int NOT NULL
);
create table Pracownicy
(
	id_pracownika smallint auto_increment primary key,
	id_dzialu smallint,
    nazwisko varchar(30) NOT NULL,
    imie varchar(30),
    foreign key (id_dzialu) references Dzial_pracowniczy(id_dzialu)
);

create table Kontrakty
(
	id_kontraktu smallint auto_increment primary key,
    poczatek date not null,
    koniec date not null,
    miesieczne_wynagrodzenie int not null,
    klauzula_wykupu int null
);
create table Wypozyczenia
(
	id_wypozyczenia smallint auto_increment primary key,
	z varchar(30) NULL,
	do varchar(30) NOT NULL,
    poczatek date not null,
    koniec date not null,
	miesieczne_wynagrodzenie int not null,
    cena_pierwokupu bit null
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
	id_zawodnika smallint auto_increment primary key,
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
	id_kontuzji int auto_increment primary key,
	id_zawodnika smallint,
    nazwa_urazu varchar(40) NOT NULL,
    poczatek_przerwy date NOT NULL,
    koniec_przerwy date NOT NULL,
    foreign key (id_zawodnika) references Zawodnicy(id_zawodnika) 
);
create table Zawieszenia
(
	id_zawieszenia int auto_increment primary key,
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