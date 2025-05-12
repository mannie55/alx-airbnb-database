
-- 1. Get all bookings with user details
SELECT * FROM bookings
INNER JOIN users
ON bookings.user_id = users.user_id;

-- 2. Get all properties with their reviews
SELECT * FROM properties
LEFT JOIN reviews
ON properties.property_id = reviews.property_id;

SELECT * FROM users
LEFT OUTER JOIN bookings
ON users.user_id = bookings.user_id;
