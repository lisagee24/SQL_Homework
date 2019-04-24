USE sakila;
# 1a. Display the first and last names of all actors from the table `actor`.

select first_name, last_name from actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT UPPER('first_name', 'last_name');



select concat(first_name, " ", last_name) AS "Actor Name" 
from actor;
  

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?alter
SELECT actor_id, first_name, last_name
FROM actor WHERE first_name = 'Joe';

# 2b. Find all actors whose last name contain the letters `GEN`:
select * 
from actor
where last_name like '%GEN%';

# 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT * 
from actor
where last_name like "%LI%"
order by (last_name) ASC, (first_name) ASC;
    


# 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country
from country
where country IN ('Afghanistan', 'Bangladesh', 'China');
 
# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD COLUMN description BLOB;

select * from actor;
# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

UPDATE actor SET description = ''
WHERE actor_id = 1;

select * from actor;

ALTER TABLE actor
DROP COLUMN description;

select * from actor;

# 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, count(last_name) 
from actor
group by (last_name);


# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT *
from actor
order by last_name;

select last_name, count(last_name) AS num_with_last_name
from actor
group by last_name
having num_with_last_name >= 2;



#group by last_name;
#count(last_name) >=2);
# count(last_name) 


#where (count(last_name) >=2)

# 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor 
SET 
    first_name = REPLACE(first_name,
        "GROUCHO",
        "HARPO")
WHERE
    (last_name = 'WILLIAMS') AND (first_name = 'GROUCHO');

select * from actor
where last_name = 'WILLIAMS';


# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor 
SET 
    first_name = REPLACE(first_name,
        "HARPO",
        "GROUCHO")
WHERE
    (last_name = 'WILLIAMS') AND (first_name = 'HARPO');






select first_name, last_name
from actor
where last_name = 'WILLIAMS';

#5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

#Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)

show create table address;


select * from address;

 #6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
select staff.first_name, staff.last_name, address.address
from staff
inner join address on staff.address_id = address.address_id;

# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

select staff.staff_id, staff.first_name, staff.last_name, sum(payment.amount) AS total_amount_Aug_2005 
from payment
inner join staff on payment.staff_id = staff.staff_id
where (year(payment_date) = 2005) AND (month(payment_date) = 08)
group by payment.staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
select film.film_id, film.title, count(film_actor.actor_id)
from film
inner join film_actor on film.film_id = film_actor.film_id
group by film.film_id;


# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select film.film_id, film.title, count(inventory.inventory_id) AS num_copies_inventory_system 
from film 
inner join inventory on film.film_id = inventory.film_id
	  join rental on inventory.inventory_id = rental.inventory_id
where (film.title = "Hunchback Impossible");

#SELECT t1.col, t3.col FROM table1 join table2 ON table1.primarykey = table2.foreignkey
#                                  join table3 ON table2.primarykey = table3.foreignkey


# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
select customer.customer_id, customer.first_name, customer.last_name, sum(payment.amount) AS total_paid
from customer
inner join payment on customer.customer_id = payment.customer_id
group by customer.last_name, customer.customer_id;

 # ![Total amount paid](Images/total_payment.png)

 #7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title
from film
inner join language on film.language_id = language.language_id
where (film.language_id = 1) AND (film.title like 'K%') OR (film.title like 'Q%')
group by film.title;

# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select actor.first_name, actor.last_name AS 'Actors In The Film'
from film
inner join film_actor on film.film_id = film_actor.film_id
inner join actor on film_actor.actor_id = actor.actor_id
where film.title = "Alone Trip"
group by actor.last_name;

select film_id from film where title = "Alone Trip";
select film_actor.actor_id, actor.first_name, actor.last_name from film_actor
inner join actor on film_actor.actor_id = actor.actor_id
where film_actor.film_id = 17
group by actor.last_name;

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select customer.first_name, customer.last_name, customer.email, customer_list.country 
from customer_list
inner join customer on customer_list.ID = customer.customer_id 
where customer_list.country = 'Canada';

select * from customer_list
where country = 'Canada';
 
# 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
select category.name, film.title
from category
inner join film_category on category.category_id = film_category.category_id
inner join film on film_category.film_id = film.film_id
where category.name = 'Family';

# 7e. Display the most frequently rented movies in descending order.

select title, count(title) as Title_count
from film
inner join inventory on (film.film_id = inventory.film_id) 
inner join rental on (inventory.inventory_id = rental.inventory_id)
group by title
order by Title_count desc;

# 7f. Write a query to display how much business, in dollars, each store brought in.
select store, total_sales from sales_by_store;


# 7g. Write a query to display for each store its store ID, city, and country.

select store.store_id, city.city, country.country 
from store
inner join address on store.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id;


# 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select * from sales_by_film_category
order by total_sales desc
limit 5;

# 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW top_5_genres_by_gross_revenue AS
select * from sales_by_film_category
order by total_sales desc
limit 5;



# 8b. How would you display the view that you created in 8a?

SELECT * FROM top_5_genres_by_gross_revenue;

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

DROP VIEW top_5_genres_by_gross_revenue;


