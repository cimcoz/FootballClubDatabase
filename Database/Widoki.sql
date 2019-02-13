CREATE VIEW AktualneRezerwacje
AS
SELECT RO.*, R.nazwa AS rezerwujacy, O.nazwa AS obiekt, O.adres
FROM [Rezerwacje obiektow] AS RO
JOIN Rezerwujacy AS R ON RO.id_rezerwujacego = R.id_rezerwujacego
JOIN [Obiekty sportowe] AS O ON O.id_obiektu = RO.id_obiektu
WHERE RO.od_kiedy > GETDATE()

CREATE VIEW AktualneKarnety
AS  
SELECT K.* FROM Karnety AS K JOIN Stadion AS S ON K.id_karnetu = S.id_karnetu

CREATE VIEW NajblizszeMecze
AS  
SELECT TOP 3 T.*, sprzedane_bilety FROM Terminarz AS T
JOIN (SELECT COUNT(*) AS sprzedane_bilety, id_meczu FROM Bilety
	GROUP BY id_meczu) AS B
ON T.id_meczu = B.id_meczu
WHERE data > GETDATE()
ORDER BY data ASC

CREATE VIEW SprzedaneBilety
AS
SELECT B.* FROM Bilety AS B JOIN (SELECT TOP 1 id_meczu FROM NajblizszeMecze) AS N
ON B.id_meczu = N.id_meczu

CREATE VIEW IloscRezerwacji
AS
SELECT R.*, I.Ilosc FROM Rezerwujacy AS R JOIN 
	(SELECT COUNT(*) AS Ilosc, RE.id_rezerwujacego
	FROM Rezerwujacy AS RE JOIN [Rezerwacje obiektow] AS RO
	ON RE.id_rezerwujacego = RO.id_rezerwujacego
	GROUP BY RE.id_rezerwujacego) AS I
ON R.id_rezerwujacego = I.id_rezerwujacego

create view kontuzjowani_zawodnicy as
select nazwisko, imie, nazwa_urazu, pozycja,  poczatek_przerwy, koniec_przerwy
from Zawodnicy as z 
right join Kontuzje  as k
on z.id_zawodnika = k.id_zawodnika;

create view zawieszeni_zawodnicy as
select nazwisko, imie, poczatek_zawieszenia, koniec_zawieszenia, kara_finansowa
from Zawieszenia 
left join Zawodnicy
on Zawieszenia.id_zawodnika = Zawodnicy.id_zawodnika;



create view zawodnicy_wypozyczeni as
select nazwisko, imie, pozycja, z, do, poczatek, koniec
from Wypozyczenia as w 
left join Zawodnicy as z
on w.id_wypozyczenia = z.id_wypozyczenia;

create view bonusy_pilkarzy as 
select nazwisko, imie, nazwa_bonusu, kwota, wyplacone
from Bonusy as b
left join  Zawodnicy as z
on z.id_kontraktu = b.id_kontraktu;


create view kadra_aktualnie_dostepnych_zawodnikow  as
select imie, nazwisko
from Zawodnicy
where id_zawodnika not in 
(
	select k.id_zawodnika
    from Kontuzje as k
    inner join Zawieszenia as z
    on k.id_zawodnika = z.id_zawodnika
    where koniec_przerwy >= GETDATE() and koniec_zawieszenia >= GETDATE()
)

