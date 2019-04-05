
create view AktualneKarnety as  
select K.* from Karnety as K join Stadion as S on K.id_karnetu = S.id_karnetu;


create view IloscRezerwacji as
select R.*, I.Ilosc from Rezerwujacy as R join 
	(select COUNT(*) as Ilosc, RE.id_rezerwujacego
	from Rezerwujacy as RE join [Rezerwacje obiektow] as RO
	on RE.id_rezerwujacego = RO.id_rezerwujacego
	group by RE.id_rezerwujacego) as I
on R.id_rezerwujacego = I.id_rezerwujacego;

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

