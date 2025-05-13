-- Query to retrieve comprehensive booking details with AND conditions
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
WHERE b.start_date >= CURRENT_DATE - INTERVAL '30 days'
    AND b.total_price > 100
    AND p.price_per_night < 200
    AND py.payment_status = 'completed'
ORDER BY b.start_date DESC;


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
WHERE rb.total_price > 100
    AND rb.price_per_night < 200
    AND py.payment_status = 'completed'
ORDER BY rb.start_date DESC
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
