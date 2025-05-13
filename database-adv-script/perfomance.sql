-- Query to retrieve comprehensive booking details
SELECT 
    b.booking_id,
    -- User details
    u.first_name as user_first_name,
    u.last_name as user_last_name,
    u.email as user_email,
    -- Property details
    p.name as property_name,
    p.description as property_description,
    p.price_per_night,
    -- Booking details
    b.start_date,
    b.end_date,
    b.total_price,
    -- Payment details
    py.payment_date,
    py.payment_method,
    py.amount as payment_amount
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN payments py ON b.booking_id = py.booking_id
ORDER BY b.start_date DESC;

-- Optimized Query 1: Using EXISTS and Partial Indexes
-- First, create partial indexes for better performance
CREATE INDEX IF NOT EXISTS idx_bookings_recent ON bookings(start_date) 
WHERE start_date >= CURRENT_DATE - INTERVAL '30 days';

CREATE INDEX IF NOT EXISTS idx_bookings_user_property ON bookings(user_id, property_id);

-- Then use the optimized query
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.first_name as user_first_name,
    u.last_name as user_last_name,
    u.email as user_email,
    p.name as property_name,
    p.description as property_description,
    p.price_per_night,
    b.start_date,
    b.end_date,
    b.total_price,
    py.payment_date,
    py.payment_method,
    py.amount as payment_amount
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN LATERAL (
    SELECT payment_date, payment_method, amount
    FROM payments
    WHERE booking_id = b.booking_id
    ORDER BY payment_date DESC
    LIMIT 1
) py ON true
WHERE b.start_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY b.start_date DESC
LIMIT 100;

-- Optimized Query 2: Using Materialized View for Frequently Accessed Data
-- First, create a materialized view for recent bookings
CREATE MATERIALIZED VIEW IF NOT EXISTS recent_bookings_view AS
SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.first_name,
    u.last_name,
    u.email,
    p.name as property_name,
    p.description as property_description,
    p.price_per_night
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
WHERE b.start_date >= CURRENT_DATE - INTERVAL '30 days'
WITH DATA;

-- Create index on the materialized view
CREATE INDEX IF NOT EXISTS idx_recent_bookings_date 
ON recent_bookings_view(start_date DESC);

-- Then use the materialized view
EXPLAIN ANALYZE
SELECT 
    rb.booking_id,
    rb.first_name as user_first_name,
    rb.last_name as user_last_name,
    rb.email as user_email,
    rb.property_name,
    rb.property_description,
    rb.price_per_night,
    rb.start_date,
    rb.end_date,
    rb.total_price,
    py.payment_date,
    py.payment_method,
    py.amount as payment_amount
FROM recent_bookings_view rb
LEFT JOIN LATERAL (
    SELECT payment_date, payment_method, amount
    FROM payments
    WHERE booking_id = rb.booking_id
    ORDER BY payment_date DESC
    LIMIT 1
) py ON true
ORDER BY rb.start_date DESC
LIMIT 100;

-- Optimized Query 3: Using Partitioning for Large Tables
-- First, create a partitioned table for bookings
CREATE TABLE IF NOT EXISTS bookings_partitioned (
    booking_id INT,
    user_id INT,
    property_id INT,
    start_date DATE,
    end_date DATE,
    total_price DECIMAL(10,2)
) PARTITION BY RANGE (start_date);

-- Create partitions for different date ranges
CREATE TABLE bookings_current PARTITION OF bookings_partitioned
    FOR VALUES FROM (CURRENT_DATE - INTERVAL '30 days') TO (CURRENT_DATE + INTERVAL '30 days');

CREATE TABLE bookings_historical PARTITION OF bookings_partitioned
    FOR VALUES FROM (MINVALUE) TO (CURRENT_DATE - INTERVAL '30 days');

-- Then use the partitioned table
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    u.first_name as user_first_name,
    u.last_name as user_last_name,
    u.email as user_email,
    p.name as property_name,
    p.description as property_description,
    p.price_per_night,
    b.start_date,
    b.end_date,
    b.total_price,
    py.payment_date,
    py.payment_method,
    py.amount as payment_amount
FROM bookings_partitioned b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.property_id
LEFT JOIN LATERAL (
    SELECT payment_date, payment_method, amount
    FROM payments
    WHERE booking_id = b.booking_id
    ORDER BY payment_date DESC
    LIMIT 1
) py ON true
WHERE b.start_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY b.start_date DESC
LIMIT 100;

/*
Performance Optimization Notes:

1. Index Optimizations:
   - Partial index on recent bookings
   - Composite index on user_id and property_id
   - Index on materialized view
   - Partitioned table for better data management

2. Query Optimizations:
   - LATERAL join for latest payment
   - Materialized view for frequently accessed data
   - Partitioning for large tables
   - Date range filtering
   - Result limiting

3. Expected Improvements:
   - Faster data access with partial indexes
   - Reduced I/O with materialized view
   - Better scalability with partitioning
   - Optimized join operations
   - Reduced memory usage

4. Maintenance Considerations:
   - Regular refresh of materialized view
   - Index maintenance
   - Partition management
   - Statistics updates
*/
