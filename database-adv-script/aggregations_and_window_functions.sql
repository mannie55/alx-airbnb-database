SELECT 
    users.first_name,
    COUNT(bookings.user_id) as bookings_count
FROM users
LEFT JOIN bookings ON users.user_id = bookings.user_id
GROUP BY users.first_name
-- ORDER BY bookings_count DESC;
