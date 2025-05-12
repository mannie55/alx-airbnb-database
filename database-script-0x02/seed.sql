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
SET @property2_id = UUID();
SET @property3_id = UUID();

INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
VALUES
(@property1_id, @host_id, 'Cozy Cottage', 'A small cottage near the lake.', 'Lakeview, CA', 120.00),
(@property2_id, @host_id, 'Modern Apartment', 'A spacious apartment in the city center.', 'Downtown, NY', 150.00),
(@property3_id, @host_id, 'Beachfront Villa', 'A luxurious villa with a private beach.', 'Sunny Beach, FL', 200.00);

SET @booking_id = UUID();
SET @booking_id2 = UUID();
SET @booking_id3 = UUID();

INSERT INTO bookings (booking_id, user_id, property_id, start_date, end_date, total_price, status)
VALUES
(@booking_id, @guest_id, @property1_id, '2025-06-01', '2025-06-05', 480.00, 'confirmed'),
(@booking_id2, @guest_id, @property2_id, '2025-07-10', '2025-07-15', 750.00, 'pending'),
(@booking_id3, @guest_id, @property3_id, '2025-08-01', '2025-08-05', 1000.00, 'cancelled');

SET @payment_id = UUID();
SET @payment_id2 = UUID();
SET @payment_id3 = UUID();

INSERT INTO payments (payment_id, booking_id, amount, payment_method)
VALUES
(@payment_id, @booking_id, 480.00, 'credit_card'),
(@payment_id2, @booking_id2, 750.00, 'paypal'),
(@payment_id3, @booking_id3, 1000.00, 'stripe');

SET @review_id = UUID();
SET @review_id2 = UUID();
SET @review_id3 = UUID();

INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
VALUES
(@review_id, @property1_id, @guest_id, 5, 'Wonderful stay! Clean and peaceful.'),
(@review_id2, @property2_id, @guest_id, 4, 'Good location, but the room was a bit small.'),
(@review_id3, @property3_id, @guest_id, 3, 'The view was amazing, but the service was slow.');

SET @message_id = UUID();
SET @message_id2 = UUID();
SET @message_id3 = UUID();

INSERT INTO messages (message_id, sender_id, receiver_id, content)
VALUES
(@message_id, @guest_id, @host_id, 'Thank you for the great stay!'),
(@message_id2, @host_id, @guest_id, 'You are welcome! We are glad you enjoyed your stay.'),
(@message_id3, @guest_id, @host_id, 'I have a few questions about the property.');


