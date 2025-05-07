-- ==== Generate UUIDs for users ====
SET @guest_id = UUID();
SET @host_id = UUID();
SET @admin_id = UUID();


INSERT INTO users (user_id, first_name, last_name, email, password, password_hash, phone_number, role)
VALUES
(@guest_id, 'John', 'Doe', 'john@example.com', 'pass123', 'hash123', '1234567890', 'guest'),
(@host_id, 'Alice', 'Smith', 'alice@example.com', 'pass456', 'hash456', '0987654321', 'host'),
(@admin_id, 'Bob', 'Admin', 'admin@example.com', 'adminpass', 'adminhash', '1112223333', 'admin');


SET @property1_id = UUID();


INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
VALUES
(@property1_id, @host_id, 'Cozy Cottage', 'A small cottage near the lake.', 'Lakeview, CA', 120.00);

-
SET @booking_id = UUID();


INSERT INTO bookings (booking_id, user_id, property_id, start_date, end_date, total_price, status)
VALUES
(@booking_id, @guest_id, @property1_id, '2025-06-01', '2025-06-05', 480.00, 'confirmed');


SET @payment_id = UUID();


INSERT INTO payments (payment_id, booking_id, amount, payment_method)
VALUES
(@payment_id, @booking_id, 480.00, 'credit_card');


SET @review_id = UUID();


INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
VALUES
(@review_id, @property1_id, @guest_id, 5, 'Wonderful stay! Clean and peaceful.');


SET @message_id = UUID();


INSERT INTO messages (message_id, sender_id, receiver_id, content)
VALUES
(@message_id, @guest_id, @host_id, 'Thank you for the great stay!');
