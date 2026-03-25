/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */





WITH ranked_rentals AS (
    SELECT
        r.customer_id,
        i.film_id,
        ROW_NUMBER() OVER (
            PARTITION BY r.customer_id
            ORDER BY r.rental_date DESC, r.rental_id DESC
        ) AS rn
    FROM rental r
    JOIN inventory i
      ON r.inventory_id = i.inventory_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
JOIN ranked_rentals rr
  ON c.customer_id = rr.customer_id
WHERE rr.rn <= 5
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(*) = 5
   AND SUM(
       CASE WHEN EXISTS (
           SELECT 1
           FROM film_category fc
           JOIN category cat
             ON fc.category_id = cat.category_id
           WHERE fc.film_id = rr.film_id
             AND cat.name = 'Action'
       ) THEN 1 ELSE 0 END
   ) >= 4
ORDER BY c.customer_id;
