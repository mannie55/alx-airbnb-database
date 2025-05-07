# Entity-Relationship Diagram for Airbnb Clone

## Entities and Attributes

### 1. User
- id (PK)
- email
- password
- first_name
- last_name

### 2. Property
- id (PK)
- name
- description
- price_per_night
- owner_id (FK to User)

### 3. Booking
- id (PK)
- user_id (FK to User)
- property_id (FK to Property)
- start_date
- end_date

## Relationships

- A **User** can have many **Bookings**.
- A **Booking** belongs to one **User** and one **Property**.
- A **User** can own many **Properties**.
- A **Property** can have many **Bookings**.

## ER Diagram

<img src="./Airbnb.svg" alt="ER Diagram" width="100%">
