# Database Normalization Report – Airbnb Clone

## Objective

To ensure the Airbnb database schema adheres to the principles of database normalization, eliminating redundancy, improving data integrity, and organizing data efficiently up to **Third Normal Form (3NF)**.

---

## Step-by-Step Normalization

### 1. First Normal Form (1NF)

**Rule:** Each table must have atomic values (no repeating groups or arrays), and each record should be unique.

**Actions Taken:**
- Each entity (User, Property, Booking, etc.) has its own table with a primary key.
- All fields contain atomic values (e.g., `phone_number`, `email`, `price_per_night`, etc.).
- No multi-valued or composite fields exist.

✅ **1NF Achieved**

---

### 2. Second Normal Form (2NF)

**Rule:** Must be in 1NF, and all non-key attributes must be fully dependent on the primary key.

**Actions Taken:**
- Composite primary keys (e.g., `Review.review_id`, `Message.message_id`) have all attributes fully dependent on the full primary key.
- No partial dependencies. For example, in the `Booking` table, attributes like `start_date`, `total_price`, and `status` depend fully on `booking_id`.

✅ **2NF Achieved**

---

### 3. Third Normal Form (3NF)

**Rule:** Must be in 2NF and have no transitive dependencies (i.e., non-key attributes should not depend on other non-key attributes).

**Actions Taken:**
- Separated `Payment` into its own table to avoid storing payment details directly in `Booking`.
- The `Property` table stores only attributes related to the property (no derived or user-specific data).
- Refactored `Message` table to avoid a self-join field like `sender & receiver_id`. Replaced it with:
  - `sender_id` (FK to User)
  - `receiver_id` (FK to User)

This eliminates any potential transitive dependencies.

✅ **3NF Achieved**

---

## Summary

All tables in the Airbnb database schema have been reviewed and adjusted where necessary to comply with the rules of 1NF, 2NF, and 3NF. Redundancies and dependencies have been eliminated to ensure data consistency, integrity, and scalability.

---

## Tables Covered

- `User`
- `Property`
- `Booking`
- `Review`
- `Payment`
- `Message`
