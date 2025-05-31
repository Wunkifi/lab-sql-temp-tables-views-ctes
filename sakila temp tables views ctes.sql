CREATE VIEW rental_information_per_customer AS 
	SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS name, c.email, r.rental_count
	FROM customer AS c
	JOIN (SELECT customer_id, COUNT(*) AS rental_count 
		FROM rental
		GROUP BY customer_id) AS r
	ON c.customer_id = r.customer_id;


CREATE TEMPORARY TABLE total_paid_per_customer
SELECT p.customer_id, ROUND(AVG(amount)*c.rental_count,2) AS total_paid
FROM payment AS p
JOIN (SELECT customer_id, rental_count FROM rental_information_per_customer) AS c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id;

WITH cte AS (SELECT p.customer_id, c.name, c.email, c.rental_count, p.total_paid
FROM total_paid_per_customer AS p
JOIN (SELECT * FROM rental_information_per_customer) AS c
ON p.customer_id = c.customer_id)

SELECT *, total_paid/rental_count AS average_payment_per_rental
FROM cte;