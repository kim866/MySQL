-- Instructions - Part 1

-- 1a. Display the first and last names of all actors from the table actor.
Use sakila;
Select first_name As 'First Name', last_name As 'Last Name' From actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
Select Concat(first_name, ' ', last_name) As 'Actor Name' From actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
Select actor_id, first_name, last_name From actor Where first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:
Select Concat(first_name, ' ', last_name) As 'Actor Name' From actor Where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
Select first_name As 'First Name', last_name As 'Last Name' From actor where last_name like '%LI%' Order By last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
Select country_id, country From country Where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor ADD description blob;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
Select last_name As 'Last Name of Actors', count(*) As 'Count' From actor Group By last_name;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
Select last_name As 'Last Name of Actors', count(*) As 'Count' From actor Group By last_name Having count(last_name) >=2;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor SET first_name = "HARPO" WHERE actor_id = "172";

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name = "GROUCHO" WHERE actor_id = "172";

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
-- Right click the table, Left Click 'Copy Row tab seperated'
/* CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8 */

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
Select first_name, last_name, address From staff s join address a On (s.address_id = a.address_id);

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
Select first_name, last_name, SUM(amount) as 'total amount' From staff s join payment p On (p.staff_id = s.staff_id) Group By s.staff_id;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
Select title As 'Film Title', count(*) As 'Number of Actors' From film_actor fa Inner Join film f On fa.film_id = f.film_id Group By title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
Select title, count(*) As 'Copies of the Film' From film f Inner Join inventory i on f.film_id = i.film_id Where title = 'Hunchback Impossible';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
Select first_name, last_name, SUM(amount) as 'Total Amount Paid' From customer c join payment p On (c.customer_id = p.customer_id) Group By c.customer_id Order By last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
Select title From film f Inner Join language l On l.language_id = f.language_id Where f.title like 'K%' or f.title like 'Q%' and l.name = 'English';

Select
	title
From
	film
Where
	language_id IN 
    (
		Select
			language_id
		From
			language
		Where
			name = 'English' 
    )
    And
		title like 'K%'
	Or
		title like 'Q%';

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
Select first_name, last_name From actor a inner join film_actor fa On a.actor_id = fa.actor_id inner join film f On fa.film_id = f.film_id Where f.title = 'Alone Trip';

Select
	first_name As 'First Name', last_name As 'Last Name'
From
	actor
Where
	actor_id IN
    (
		Select
			actor_id
		From
			film_actor
		Where
			film_id IN
            (
				Select
					film_id
				From
					film
				Where
					title = 'Alone Trip'
            )
    );


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
Select 
	first_name, last_name, email
From
	customer c
    Inner Join address a
    On c.address_id = a.address_id
    Inner Join city ci
    On a.city_id = ci.city_id
    Inner Join country co
    On ci.country_id = co.country_id
Where
	co.country = 'Canada';
    
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
Select 
	title As 'Movie Title'
From 
	film f 
    Inner Join film_category fc
    On f.film_id = fc.film_id
    Inner Join category c
    On fc.category_id = c.category_id
where c.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
Select
	title, count(*) As 'Number of Rents'
From
	film f
    Inner Join inventory i
    On f.film_id = i.film_id
    Inner Join rental r
    On i.inventory_id = r.inventory_id
Group By
	title
Order By
	count(*)
DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.    
Select
	s.store_id, a.address, SUM(p.amount)
From
	store s
	Inner Join address a
    On s.address_id = a.address_id
    Inner Join customer c
    On s.store_id = c.store_id
    Inner Join payment p
    On c.customer_id = p.customer_id
Group By
	s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.
Select
	s.store_id, c.city, co.country
From
	store s
    Inner Join address a
    On s.address_id = a.address_id
    Inner join city c
    On a.city_id = c.city_id
    Inner join country co
    On c.country_id = co.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
Select
	c.name As 'Movie Genre', SUM(p.amount) As 'Gross Revenue'
From
	category c
    Inner Join film_category fc
    On c.category_id = fc.category_id
    Inner Join inventory i
    On fc.film_id = i.film_id
    Inner Join rental r
    On i.inventory_id = r.inventory_id
    Inner Join payment p
    On r.rental_id = p.rental_id
Group By
	c.name
Order By
	SUM(p.amount)
DESC Limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres_by_gross_revenue

AS

Select
	c.name As 'Movie Genre', SUM(p.amount) As 'Gross Revenue'
FROM
	sakila.category c
    Inner Join sakila.film_category fc
    On c.category_id = fc.category_id
    Inner Join sakila.inventory i
    On fc.film_id = i.film_id
    Inner Join sakila.rental r
    On i.inventory_id = r.inventory_id
    Inner Join sakila.payment p
    On r.rental_id = p.rentaltop_five_genres_by_gross_revenue_id
Group By
	c.name
Order By
	SUM(p.amount)
DESC Limit 5;

-- 8b. How would you display the view that you created in 8a?
Select * from top_five_genres_by_gross_revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
Drop View If Exists top_five_genres_by_gross_revenue;



