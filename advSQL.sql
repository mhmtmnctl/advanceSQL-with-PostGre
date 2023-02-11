
--açıklama
/*
	çok satırlı açıklama
*/

--*************DEĞİŞKEN TANIMLAMA******************

DO $$ --anonymous blok, dolar isaretini ozel karakterler öncesinde '' işaretlerini kullanmamak için koyduk
DECLARE
	counter integer := 1; -- :=1 demek ilk default değeri 1 olsun dedik ve counter diye bi değişken oluşturduk
	first_name varchar(50) := 'Ahmet';
	last_name varchar(50) := 'Gok';
	payment numeric(4,2) := 20.5; -- 20.50 olarak kaydedilir. virgülden sonraki kısım ondalık kısmını belirler
BEGIN
	RAISE NOTICE '% % % has been paid % USD',
		counter,
		first_name,
		last_name,
		payment;
END $$ ;
		
--Task 1
--değişkenler oluşturarak "Ahmet ve Mehmet beyler 120 tl'ye bilet aldılar " cümlesini ekrana yazdırın.
do $$ 
declare
	name1 varchar(50) := 'Ahmet';
	name2 varchar(50) := 'Mehmet';
	fiyat numeric (3) := 120;
begin
	raise notice '% ve % beyler % tl ye bilet aldılar',
	name1,
	name2,
	fiyat;
end $$;

--*******BEKLETME KOMUTU**********
do $$
declare 
	create_at time := now();
begin 
	raise notice '%' , create_at;
	perform pg_sleep(5); --5sn bekle
	raise notice '%', create_at;
end$$;

--**********TABLODAN DATA TİPİNİ KOPYALAMA*******

do $$
declare 
	film_title film.title%type; --film_title text yapsaydık, db de değişklik olsaydı yani  türü değişseydi burası patlardı. bu şekilde dinamik kullanmış olduk
	--featured_title film.title%type;
begin
	-- 1 id li filmin ismini getirelim.
	select title
	from film
	into film_title --yukarıda tanımladığımız değişkenin içine at demiş olduk
	where id=1;
	
	raise notice 'Film title with id 1 :%' ,film_title;
end $$;
	
--******************ROW TYPE*****************
--o rowdaki tüm datayı alır getirir
do $$
declare 
	selected_actor actor%rowtype; --bir nevi actor objesi oluşturmuş olduk. o rowudaki tüm bilgiler gibi tipi de o row.
begin
	--id si 1 olan actorü getir
	select *
	from actor
	into selected_actor
	where id=1;
	
	raise notice 'The actor name is : % %',
		selected_actor.first_name,
		selected_actor.last_name;
end $$ ;

--***************RECORD TYPE***************
-- o rowdaki istediğimiz dataları getirir
do $$
declare
	rec record;--data türü record yaptık.
begin 
	--filmi seçiyoruz
	select id,title,type
	into rec
	from film
	where id=2;
	
	raise notice '% % %', rec.id,rec.title,rec.type;
end $$

--***************İÇ İÇE BLOK****************

do $$
<<outer_block>>
declare --outer block
	counter integer :=0;
begin --outer blok
	counter := counter + 1;
	raise notice 'counter değerim : %',counter;
	
	declare -- inner block
		counter integer :=0; --bu iki counter birbirinden farklı
	begin --inner blok
		counter := counter + 10;
		raise notice 'iç bloktaki counter değerim :%',counter;
		raise notice 'dış bloktaki counter değerim :%',outer_block.counter;--yukarıda opsiyonel olarak outer blok yazdık. oradan çağırdık
	end; --inner blok sonu

raise notice 'dış bloktaki counter değerim : %', counter  ;


end $$ ; 

--************CONSTANT(SABİT) ***************

--selling_price := net_price*0.1; bu tarz koddan uzak durmak lazım. 0.1 constant oluyor.bunun yerine variable'a ata 
--+selling_price:= net_price + net_price*vat; gibi daha iyi. vat değeri bi değişken oluyor

do $$
declare
	vat constant numeric := 0.1; --bu değer artık sabit. pi sayısı gibi
	net_price numeric := 20.5;
begin 
	raise notice 'Satış fiyatı : %', net_price*(1+vat);
	--vat:=0.05; constant bir ifadeyi değiştirmeye çalışırsak hata alırız
end $$ ;

--constant bir ifadeye RT de değer verebilir miyim???
do $$
declare
	start_at constant time := now();
begin 
	raise notice 'bloğun çalışma zamanı : %', start_at;
end $$;

--//////////////// Control Structures ////////////////////

--***********************If Statement*************

if condition then
	statement;
end if;

--Task: 0 id'li filmi bulalım, yoksa ekrana uyarı yazısı verelim.
do $$ 
declare
	selected_film film%rowtype;
	input_film_id film.id%type :=0;
begin
	select * from film
	into selected_film
	where id = input_film_id;
	
	if not found then 
		raise notice 'Girdiğiniz id li film bulunamadı : %', input_film_id;
	end if;
end $$;

















	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

