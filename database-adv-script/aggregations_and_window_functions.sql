SELECT 
    users.first_name,
    COUNT(bookings.user_id) as bookings_count
FROM users
LEFT JOIN bookings ON users.user_id = bookings.user_id
GROUP BY users.first_name;
-- ORDER BY bookings_count DESC;

select * from properties;

-- Compare ROW_NUMBER and RANK for property bookings
SELECT 
    p.property_id,
    p.name as property_name,
    COUNT(b.booking_id) as total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) as row_num,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) as rank_num
FROM properties p
LEFT JOIN bookings b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name
ORDER BY total_bookings DESC;