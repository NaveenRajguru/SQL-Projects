-- 1. Who is the senior most employee based on job title
select*
from employee
order by levels desc
limit 1
	

-- 2. Which countries have the most Invoices?
select billing_country,count(billing_country)
from invoice
group by billing_country
order by count(billing_country) desc


-- 3. What are top 3 values of total invoice?
select total
from invoice
order by total desc
limit 3


-- 4. Which city has the best customers? We would like to throw a promotional Music 
-- Festival in the city we made the most money. Write a query that returns one city that 
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice 
-- totals

select billing_city, sum(total) as total_invoice
from invoice
group by billing_city
order by sum(total) desc
limit 1


-- 5. Who is the best customer? The customer who has spent the most money will be 
-- declared the best customer. Write a query that returns the person who has spent the 
-- most money

select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total)as total
from customer
inner join invoice
on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by sum(total) desc
limit 1


-- 6. Write query to return the email, first name, last name, & Genre of all Rock Music 
-- listeners. Return your list ordered alphabetically by email starting with A

-- METHOD 1	

select distinct first_name,last_name,email
from customer
join invoice
on customer.customer_id=invoice.customer_id
join invoice_line
on invoice.invoice_id=invoice_line.invoice_id
join track
on invoice_line.track_id=track.track_id
join genre
on track.genre_id=genre.genre_id
where genre.name='Rock'
order by email asc

-- METHOD 2
	
select distinct first_name,last_name,email
from customer
join invoice
on customer.customer_id=invoice.customer_id
join invoice_line
on invoice.invoice_id=invoice_line.invoice_id
where track_id in(
	select track_id 
	from track
	join genre
	on track.genre_id=genre.genre_id
	where genre.name='Rock'
	)
order by email asc


-- 7. Let's invite the artists who have written the most rock music in our dataset. Write a 
-- query that returns the Artist name and total track count of the top 10 rock band


select artist.artist_id,artist.name,count(artist.artist_id) as Number_of_Songs
from track
join album
on album.album_id=track.album_id
join artist 
on artist.artist_id=album.artist_id
join genre
on genre.genre_id=track.genre_id
where genre.name='Rock'
group by artist.artist_id
order by Number_of_Songs desc
limit 10


-- 8. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the 
-- longest songs listed first

	
select name,milliseconds
from track
where milliseconds >(select avg(milliseconds) from track)
order by milliseconds  desc


-- 9. Find how much amount spent by each customer on artists? Write a query to return
-- customer name, artist name and total spent

with BSA AS(
	select artist.artist_id as artist_id,artist.name as artist_name,
	sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track
	on track.track_id=invoice_line.track_id
	join album
	on album.album_id=track.album_id
	join artist
	on artist.artist_id=album.artist_id
	group by artist.artist_id
	order by total_sales desc
	limit 5
	)

select customer.customer_id,customer.first_name,customer.last_name,BSA.artist_name,
sum(invoice_line.unit_price*invoice_line.quantity) as amount_spent
from invoice
join customer
on customer.customer_id=invoice.customer_id
join invoice_line
on invoice_line.invoice_id=invoice.invoice_id
join track
on track.track_id=invoice_line.track_id
join album
on album.album_id=track.album_id
join BSA 
ON BSA.artist_id=album.album_id
group by 1,2,3,4
order by 5 desc


-- 10. We want to find out the most popular music Genre for each country. We determine the 
-- most popular genre as the genre with the highest amount of purchases. Write a query 
-- that returns each country along with the top Genre. For countries where the maximum 
-- number of purchases is shared return all Genres


with popular_genre as(
	select count(invoice_line.track_id) as purchase ,customer.country,genre.name, genre.genre_id,
    ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
	from invoice_line
	join invoice
	on invoice.invoice_id=invoice_line.invoice_id
	join customer
	on customer.customer_id=invoice.customer_id
	join track
	on track.track_id=invoice_line.track_id
	join genre
	on genre.genre_id=track.genre_id
	group by 2,3,4
	order by 2 asc, 1 desc	
)
select * from popular_genre where RowNo <=1


-- 11. Write a query that determines the customer that has spent the most on music for each 
-- country. Write a query that returns the country along with the top customer and how
-- much they spent. For countries where the top amount spent is shared, provide all 
-- customers who spent this amount


WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1
