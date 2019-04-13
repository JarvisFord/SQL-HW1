use sakila;

select * from actor;
select * from country;
select * from staff;
select * from address;
select * from payment;
select * from film;
select * from film_actor;
select * from inventory;
select * from customer;
select * from language;
select * from city;
select * from film_category;
select * from category;
select * from rental;
select * from store;

/* 1A */
select first_name , last_name from actor;

/* 1B */
select CONCAT(UPPER(first_name), ' ', UPPER(lasT_name)) as 'Actor Name' from actor;

/* 2A */
select actor_id, first_name, last_name from actor where first_name = 'Joe';

/* 2B */
select * from actor where last_name like '%GEN%';

/*2C*/
select * from actor where last_name like '%LI%' order by last_name, first_name;

/* 2D */
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

/* 3A */
Alter table actor ADD middle_name varchar(25) after first_name;

/*3B*/
alter table actor modify middle_name blob;
alter table actor drop column middle_name;

/* 4 */
select last_name, count(actor_id) as 'number_actors' from actor group by last_name;
select last_name, count(actor_id) as 'number_actors' from actor group by last_name
having number_actors  >=2;
update actor 
set first_name = 'Harpo' where (first_name = 'Groucho') and (last_name = 'Williams');
select actor_id from actor
where (first_name = 'HARPO' ) and (last_name = 'WILLIAMS');

update actor
set first_name = (
    CASE 
        WHEN first_name = 'HARPO' THEN 'GROUCHO'
        ELSE 'MUCHO GROUCHO'
    END)
where actor_id = 172;

/* 5
Show Create Table (?)*/

/*6a*/
select staff.first_name, staff.last_name, address.address 
from staff
inner join address
on staff.address_id = address.address_id;

/* 6B */
select staff.staff_id, staff.first_name, staff.last_name, sum(payment.amount) as 'total_sale_amount'
from staff
inner join payment
on staff.staff_id = payment.staff_id
where payment.payment_date like '2005-08%'
group by staff.staff_id;

/* 6C */
select film.film_id, film.title, count(film_actor.actor_id) as 'number_of_actors'
from film 
inner join film_actor
on film.film_id = film_actor.film_id
group by film.film_id
order by number_of_actors desc;

/* 6d */
select count(inventory.inventory_id) as 'number_of_copies' 
from inventory
inner join film
on inventory.film_id = film.film_id
where film.title = upper('Hunchback Impossible');

/*6e*/
select customer.first_name, customer.last_name, sum(payment.amount) as 'total_paid'
from customer
inner join payment
on customer.customer_id = payment.customer_id
group by customer.customer_id
order by customer.last_name;

/* 7a */ 
select title from film
where language_id = (select language_id from language where name = 'English')
and (title like 'K%' or title like 'Q%');

/* 7b */
select first_name, last_name from actor
where actor_id in (
select actor_id from film_actor where film_id = (select film_id from film where title = upper('Alone Trip')));

/* 7c */
select first_name, last_name, email from customer
join address
on address.address_id = customer.address_id
join city
on city.city_id = address.city_id
join country
on city.country_id = country.country_id
where country.country = 'Canada';

/* 7D */
select * from film
where film_id in (select film_id from film_category where category_id in (select category_id from category where name = 'Family'));

/*7E */
select film.title, count(film.title) as 'frequency'
from film
inner join inventory
on film.film_id = inventory.film_id 
inner join rental
on inventory.inventory_id = rental.inventory_id
group by film.film_id
order by frequency desc;

/* 7F */
select store.store_id, sum(payment.amount) as 'bs_dollars'
from store
inner join staff
on store.store_id = staff.store_id 
inner join payment
on staff.staff_id = payment.staff_id 
group by store.store_id;

/* 7G */
select store.store_id, city.city, country.country
from store
inner join address
on store.address_id = address.address_id
inner join city
on address.city_id = city.city_id
inner join country
on city.country_id = country.country_id;

/* 7H */ 
select category.name, sum(payment.amount) as 'revenue'
from payment 
inner join rental
on payment.rental_id = rental.rental_id 
inner join inventory
on rental.inventory_id = inventory.inventory_id 
inner join film_category
on inventory.film_id = film_category.film_id
inner join category
on film_category.category_id = category.category_id
group by category.category_id
order by revenue desc
limit 5;

/* 8a */
create view top_five_genres as
		select category.name, sum(payment.amount) as 'revenue'
		from payment 
		inner join rental
		on payment.rental_id = rental.rental_id 
		inner join inventory
		on rental.inventory_id = inventory.inventory_id 
		inner join film_category
		on inventory.film_id = film_category.film_id
		inner join category
		on film_category.category_id = category.category_id
		group by category.category_id
		order by revenue desc
		limit 5;
/* 8b */
select * from top_five_genres;

/* 8c */
drop view top_five_genres
