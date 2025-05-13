select properties.name, reviews.rating from properties
left join reviews
on properties.property_id = reviews.property_id
where  (select avg(rating) from reviews) > 4.0;

select users.first_name, users.last_name, count(bookings.user_id) as booking_count
from users
inner join bookings on users.user_id = bookings.user_id
group by users.user_id;