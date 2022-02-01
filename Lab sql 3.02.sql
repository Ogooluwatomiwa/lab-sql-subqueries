USE SAKILA;

SELECT film_id, COUNT(inventory_id) 
from sakila.inventory
where film_id in (SELECT film_id as film FROM
(SELECT film_id, title  
from sakila.film
where title = 'hunchback impossible')sub1);


SELECT * from sakila.film
WHERE length > (SELECT AVG(length) as average from sakila.film);

SELECT first_name,last_name
FROM Sakila.actor
WHERE actor_id in (SELECT actor_id FROM(SELECT title, actor_id 
from sakila.film
JOIN sakila.film_actor
USING (film_id)
WHERE title = 'Alone Trip')sub1);


SELECT title FROM sakila.film
WHERE film_id IN (SELECT film_id FROM(SELECT name, film_id
FROM sakila.category
JOIN sakila.film_category
USING (category_id)
WHERE name = 'Family')sub1);


SELECT first_name, last_name, email FROM sakila.customer
WHERE address_id in (SELECT address_id FROM(SELECT country, address_id
FROM sakila.country
JOIN sakila.city USING (country_id)
JOIN sakila.address USING (city_id)
WHERE country = 'canada')sub1);

 select first_name, last_name, actor_id, count(film_id) as film_numbers
from sakila.actor 
join sakila.film_actor USING(actor_id)
join sakila.film using (film_id)
Group by actor_id
order by film_numbers desc limit 1;

SELECT title FROM sakila.film
WHERE film_id in (SELECT film_id FROM sakila.film_actor
where actor_id = (select actor_id from (SELECT actor_id, COUNT(film_id) AS numbers
FROM sakila.actor
JOIN sakila.film_actor USING (actor_id)
GROUP BY actor_id 
ORDER BY numbers DESC LIMIT 1)sub1));

SELECT title FROM sakila.film
WHERE film_id in (Select film_id FROM sakila.inventory
join sakila.rental using(inventory_id)
WHERE customer_id = (SELECT customer_id FROM (SELECT customer_id,SUM(amount) as profit 
from sakila.payment 
Group by customer_id
ORDER by profit desc limit 1)sub1));

SELECT CONCAT(first_name,' ',last_name), SUM(amount) from sakila.customer 
join sakila.payment using(customer_id)
group by customer_id
Having SUM(amount) > (select AVG(total) from (select customer_id, SUM(amount) as total
from sakila.payment
GROUP BY customer_id )sub1)
ORDER BY SUM(amount) desc;
