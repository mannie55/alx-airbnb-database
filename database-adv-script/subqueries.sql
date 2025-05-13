SELECT properties.name, reviews.rating FROM properties
LEFT JOIN reviews
ON properties.property_id = reviews.property_id
WHERE  (SELECT AVG(rating) FROM reviews) > 4.0;

SELECT users.first_name, users.last_name, COUNT(bookings.user_id) AS booking_count
FROM users
INNER JOIN bookings ON users.user_id = bookings.user_id
GROUP BY users.user_id;