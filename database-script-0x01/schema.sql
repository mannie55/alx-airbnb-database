

CREATE TABLE users (
    user_id char(36) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') DEFAULT 'guest' NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_id ON users (user_id);



CREATE TABLE properties (
    property_id char(36) PRIMARY KEY,
    host_id char(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES users(user_id)
);


CREATE INDEX idx_property_id ON properties (property_id);




CREATE TABLE bookings (
    booking_id char(36) PRIMARY KEY,
    user_id char(36) NOT NULL,
    property_id char(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending' NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,


    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
);


CREATE INDEX idx_booking_id ON bookings (booking_id);
CREATE INDEX idx_booking_user_id ON bookings (user_id);
CREATE INDEX idx_booking_property_id ON bookings (property_id);



CREATE TABLE payments (
    payment_id char(36) PRIMARY KEY,
    booking_id char(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);


CREATE INDEX idx_payment_id ON payments (payment_id);
CREATE INDEX idx_payment_booking_id ON payments (booking_id);




CREATE TABLE reviews (
    review_id char(36) PRIMARY KEY,
    property_id char(36) NOT NULL,
    user_id char(36) NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (property_id) REFERENCES properties(property_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE INDEX idx_review_id ON reviews (review_id);
CREATE INDEX idx_review_property_id ON reviews (property_id);
CREATE INDEX idx_review_user_id ON reviews (user_id);




CREATE TABLE messages (
    message_id char(36) PRIMARY KEY,
    sender_id char(36) NOT NULL,
    receiver_id char(36) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (sender_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES users(user_id)
);

CREATE INDEX idx_message_id ON messages (message_id);
CREATE INDEX idx_message_sender_id ON messages (sender_id);
CREATE INDEX idx_message_receiver_id ON messages (receiver_id);