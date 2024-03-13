-- Challenge
-- Write SQL queries to perform the following tasks using the Sakila database:

	-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
    
	select count(*) as Available_copies from sakila.inventory i 
    where i.film_id in (select f.film_id from sakila.film f where f.title = "Hunchback Impossible");
    
    
	-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

   select * from sakila.film
   where length > (select avg(length) from sakila.film)
   order by length desc;
    
	-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
    
    select concat(a.first_name, '  ', a.last_name) as actor_ress_name, a.actor_id as actor_id
    from sakila.actor a
    where a.actor_id in -- we look for the actor_id in actor table the matches the condition below
    (select fa.actor_id from sakila.film_actor fa
	where fa.film_id in -- we look for the film_id in film_actor table the matches the condition below
    (select f.film_id from sakila.film f where f.title = "Alone Trip")) -- here we retreive the film_id for the 'Alone Trip'
    order by actor_ress_name;
    
    
    -- BONUS -- 
    
--   4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
	
      select f.title as Title, f.description as Description from sakila.film f
      where f.film_id in
      (select fc.film_id from sakila.film_category fc 
      where fc.category_id in 
      (select ca.category_id from sakila.category ca where ca.name = "Family"))
      order by Title;
    
--   5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
    
    -- subqueries road -- 
    
      select concat(cu.first_name, ' ', cu.last_name) as Name, cu.email as email from sakila.customer cu
      where cu.address_id in
      (select ad.address_id from sakila.address ad
      where ad.city_id in
      (select ci.city_id from sakila.city ci 
      where ci.country_id in 
      (select co.country_id from sakila.country co 
      where co.country = "Canada")))
      order by Name;
      
      -- join + subquery road -- 
      
	select concat(cu.first_name, ' ', cu.last_name) as Name, cu.email as email 
      from sakila.customer cu
      left join sakila.address ad
      on cu.address_id = ad.address_id
      left join sakila.city ci
      on ad.city_id  = ci.city_id
      left join sakila.country co 
      on ci.country_id = co.country_id 
      where co.country like 'Canada' ;
      
--   6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

-- most prolific actor quest -- 

select f.title as Title from sakila.film f 
where f.film_id in (select fa.film_id from sakila.film_actor fa 
where fa.actor_id in (select fa.actor_id, count(1) from sakila.film_actor fa group by actor_id
order by count(*) desc limit 1);

-- select actor_id, count(1) 
-- from film_actor
-- group by actor_id
-- order by count(*) desc
-- limit 1; 

--    select * from sakila.film
--    where length > (select avg(length) from sakila.film)
--    order by length desc;


	