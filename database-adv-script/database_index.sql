-- Create indexes for frequently used columns

-- Indexes for Users table
CREATE INDEX idx_users_user_id ON users(user_id);
CREATE INDEX idx_users_first_name ON users(first_name);

-- Indexes for Bookings table
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_booking_id ON bookings(booking_id);

-- Indexes for Properties table
CREATE INDEX idx_properties_property_id ON properties(property_id);
CREATE INDEX idx_properties_name ON properties(name);

-- Indexes for Reviews table
CREATE INDEX idx_reviews_property_id ON reviews(property_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);

-- Performance measurement queries
-- Before running these, make sure to run EXPLAIN ANALYZE on your queries
-- Example for the property ranking query:
EXPLAIN ANALYZE
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

-- Example for the user bookings count query:
EXPLAIN ANALYZE
SELECT 
    users.first_name,
    COUNT(bookings.user_id) as bookings_count
FROM users
LEFT JOIN bookings ON users.user_id = bookings.user_id
GROUP BY users.first_name; 