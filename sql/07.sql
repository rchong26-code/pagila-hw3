/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */





SELECT DISTINCT a.first_name || ' ' || a.last_name AS "Actor Name"
FROM actor a
WHERE a.actor_id IN (
    SELECT fa_outer.actor_id
    FROM film_actor fa_outer
    WHERE fa_outer.film_id IN (
        SELECT fa_inner.film_id
        FROM film_actor fa_inner
        WHERE fa_inner.actor_id IN (
            SELECT fa1.actor_id
            FROM film_actor fa1
            WHERE fa1.film_id IN (
                SELECT fa0.film_id
                FROM film_actor fa0
                JOIN actor rb ON fa0.actor_id = rb.actor_id
                WHERE rb.first_name = 'RUSSELL'
                  AND rb.last_name = 'BACALL'
            )
        )
    )
)
AND a.actor_id NOT IN (
    SELECT actor_id
    FROM actor
    WHERE first_name = 'RUSSELL' AND last_name = 'BACALL'
)
AND a.actor_id NOT IN (
    SELECT fa1.actor_id
    FROM film_actor fa1
    WHERE fa1.film_id IN (
        SELECT fa0.film_id
        FROM film_actor fa0
        JOIN actor rb ON fa0.actor_id = rb.actor_id
        WHERE rb.first_name = 'RUSSELL'
          AND rb.last_name = 'BACALL'
    )
)
ORDER BY "Actor Name";
