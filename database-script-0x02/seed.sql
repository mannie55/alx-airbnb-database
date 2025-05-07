--populate databse with test data



-- 1. Insert test data into the users table
INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  (UUID(), 'John', 'Doe', 'john@example.com', 'hashed_pw_1', '1234567890', 'guest'),
  (UUID(), 'Alice', 'Smith', 'alice@example.com', 'hashed_pw_2', '0987654321', 'host'),
  (UUID(), 'Admin', 'User', 'admin@example.com', 'hashed_pw_3', NULL, 'admin');

-- 2. properties table


INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES
  (UUID(), '<HOST_UUID_1>', 'Cozy Loft', 'Nice and cozy apartment in downtown.', 'Lagos', 75.00),
  (UUID(), '<HOST_UUID_1>', 'Beach House', 'Relaxing house near the ocean.', 'Accra', 120.00);

-- 3. bookings table


INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
  (UUID(), '<PROPERTY_UUID_1>', '<GUEST_UUID_1>', '2025-06-01', '2025-06-05', 300.00, 'confirmed');
