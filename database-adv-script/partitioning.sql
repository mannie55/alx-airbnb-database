-- Create partitioned bookings table
CREATE TABLE IF NOT EXISTS bookings_partitioned (
    booking_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    property_id INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending',
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES properties(property_id)
) PARTITION BY RANGE (start_date);

-- Create partitions for different time periods
-- Historical partition (before 2023)
CREATE TABLE bookings_before_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('0001-01-01')
    TO ('2023-01-01');

-- 2023 partition
CREATE TABLE bookings_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01')
    TO ('2024-01-01');

-- 2024 partition
CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01')
    TO ('2025-01-01');

-- 2025 partition
CREATE TABLE bookings_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01')
    TO ('2026-01-01');

-- Future partition (2026 and beyond)
CREATE TABLE bookings_after_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2026-01-01')
    TO ('9999-12-31');

-- Create indexes on the partitioned table
CREATE INDEX idx_bookings_partitioned_user_id ON bookings_partitioned(user_id);
CREATE INDEX idx_bookings_partitioned_property_id ON bookings_partitioned(property_id);
CREATE INDEX idx_bookings_partitioned_status ON bookings_partitioned(status);
CREATE INDEX idx_bookings_partitioned_dates ON bookings_partitioned(start_date, end_date);

-- Performance Test Queries

-- Test 1: Recent Bookings (Current Year)
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.total_price,
    p.name as property_name,
    u.first_name
FROM bookings_partitioned b
INNER JOIN properties p ON b.property_id = p.property_id
INNER JOIN users u ON b.user_id = u.user_id
WHERE b.start_date >= CURRENT_DATE - INTERVAL '30 days'
    AND b.status = 'completed'
ORDER BY b.start_date DESC;

-- Test 2: Historical Bookings (Previous Year)
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.total_price,
    p.name as property_name,
    u.first_name
FROM bookings_partitioned b
INNER JOIN properties p ON b.property_id = p.property_id
INNER JOIN users u ON b.user_id = u.user_id
WHERE b.start_date >= CURRENT_DATE - INTERVAL '1 year'
    AND b.start_date < CURRENT_DATE - INTERVAL '30 days'
    AND b.status = 'completed'
ORDER BY b.start_date DESC;

-- Test 3: Future Bookings
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.total_price,
    p.name as property_name,
    u.first_name
FROM bookings_partitioned b
INNER JOIN properties p ON b.property_id = p.property_id
INNER JOIN users u ON b.user_id = u.user_id
WHERE b.start_date > CURRENT_DATE
    AND b.status = 'pending'
ORDER BY b.start_date ASC;

-- Test 4: Cross-Partition Query (Last 2 Years)
EXPLAIN ANALYZE
SELECT 
    b.booking_id,
    b.start_date,
    b.total_price,
    p.name as property_name,
    u.first_name
FROM bookings_partitioned b
INNER JOIN properties p ON b.property_id = p.property_id
INNER JOIN users u ON b.user_id = u.user_id
WHERE b.start_date >= CURRENT_DATE - INTERVAL '2 years'
    AND b.status = 'completed'
ORDER BY b.start_date DESC;

-- Test 5: Aggregation Query
EXPLAIN ANALYZE
SELECT 
    DATE_TRUNC('month', b.start_date) as month,
    COUNT(*) as total_bookings,
    SUM(b.total_price) as total_revenue,
    AVG(b.total_price) as average_price
FROM bookings_partitioned b
WHERE b.start_date >= CURRENT_DATE - INTERVAL '1 year'
    AND b.status = 'completed'
GROUP BY DATE_TRUNC('month', b.start_date)
ORDER BY month DESC;

-- Maintenance function to create new partitions
CREATE OR REPLACE FUNCTION create_booking_partition()
RETURNS void AS $$
DECLARE
    next_year DATE;
    partition_name TEXT;
    start_date DATE;
    end_date DATE;
BEGIN
    next_year := DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '1 year';
    partition_name := 'bookings_' || to_char(next_year, 'YYYY');
    start_date := next_year;
    end_date := next_year + INTERVAL '1 year';
    
    -- Create next year's partition if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 
        FROM pg_class c 
        JOIN pg_namespace n ON n.oid = c.relnamespace 
        WHERE c.relname = partition_name
    ) THEN
        EXECUTE format(
            'CREATE TABLE %I PARTITION OF bookings_partitioned
             FOR VALUES FROM (%L) TO (%L)',
            partition_name,
            start_date,
            end_date
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Performance Analysis Notes:
/*
1. Query Performance Metrics to Monitor:
   - Execution time
   - Number of rows scanned
   - Number of partitions accessed
   - Index usage
   - Memory usage

2. Expected Performance Patterns:
   - Recent bookings queries should be fastest (single partition)
   - Historical queries might be slower (larger data volume)
   - Cross-partition queries need optimization
   - Aggregation queries benefit from partition pruning

3. Optimization Tips:
   - Monitor partition sizes
   - Regular VACUUM ANALYZE
   - Update statistics after data changes
   - Consider partition maintenance
*/
