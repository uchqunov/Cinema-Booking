create table cinema.users(
	user_id int primary key,
	name varchar(255) not null,
	email varchar(255) unique not null,
	password varchar(100) not null,
	phone varchar(50),
	created_at timestamp default current_timestamp
);

alter table cinema.users
add column "role" user_roles_enum 

drop table cinema.users;
create type user_roles_enum as enum('customer', 'admin');


create table cinema.movies(
	movie_id int primary key,
	title varchar(255) not null,
	description varchar(255),
	genre varchar(50) not null,
	duration_minutes int not null,
	release_date timestamp not null,
	rating int check(rating >= 0 and rating <= 10),
	poster_url text,
	created_at timestamp default current_timestamp
);


create table cinema.cinemas(
	cinema_id int primary key,
	name varchar(255) not null,
	location varchar(255) not null,
	created_at timestamp default current_timestamp
);


create table cinema.screens(
	screen_id int primary key,
	cinema_id int references cinema.cinemas(cinema_id),
	name varchar(255) not null,
	capacity int not null
);


create table cinema.seats(
	seat_id int primary key,
	screen_id int references cinema.screens(screen_id),
	seat_number char(3) not null
);

create type seat_type_enum as enum('VIP', 'regular');

alter table cinema.seats
add column seat_type seat_type_enum;


create table cinema.showtimes(
	showtime_id int primary key,
	screen_id int references cinema.screens(screen_id),
	movie_id int references cinema.movies(movie_id),
	start_time timestamp not null,
	end_time timestamp not null,
	price int not null
);

alter table cinema.showtimes
alter column price type numeric(10,2);


create table cinema.bookings(
	booking_id int primary key,
	user_id int references cinema.users(user_id),
	showtime_id int references cinema.showtimes(showtime_id),
	booking_date timestamp default current_timestamp,
	total_price int not null
);

alter table cinema.bookings
alter column total_price type numeric(10,2);

create type boooking_status_enum as enum('pending', 'confirmed', 'canceled');

alter table cinema.bookings
add column status boooking_status_enum;


create table cinema.booking_details(
	booking_detail_id int primary key,
	booking_id int references cinema.bookings(booking_id),
	seat_id int references cinema.seats(seat_id),
	price int not null
);


create table cinema.payments(
	payment_id int primary key,
	booking_id int references cinema.bookings(booking_id),
	payment_date timestamp default current_timestamp,
	amount int not null,
	payment_method varchar(100) not null
);

alter table cinema.payments
alter column amount type numeric(10,2);

create type payment_status_enum as enum('pending', 'completed', 'failed');

alter table cinema.payments
add column status payment_status_enum;


-- inserts

INSERT INTO cinema.users (user_id, name, email, password, role, phone, created_at) VALUES
(1, 'Alice Smith', 'alice@gmail.com', 'hashed_password1', 'customer', '1234567890', '2024-01-01 10:00:00'),
(2, 'Bob Johnson', 'bob@gmail.com', 'hashed_password2', 'admin', '0987654321', '2024-01-02 11:00:00'),
(3, 'Charlie Brown', 'charlie@hotmail.com', 'hashed_password3', 'customer', '1122334455', '2024-01-03 12:00:00');

INSERT INTO cinema.movies (movie_id, title, description, genre, duration_minutes, release_date, rating, poster_url, created_at) VALUES
(1, 'Inception', 'A mind-bending thriller.', 'Sci-Fi', 148, '2010-07-16', 8.8, 'inception_poster.jpg', '2024-01-01 10:00:00'),
(2, 'The Matrix', 'A computer hacker learns about the true nature of reality.', 'Action', 136, '1999-03-31', 8.7, 'matrix_poster.jpg', '2024-01-02 11:00:00'),
(3, 'Titanic', 'A romantic drama on the ill-fated ship.', 'Drama', 195, '1997-12-19', 7.9, 'titanic_poster.jpg', '2024-01-03 12:00:00');

INSERT INTO cinema.cinemas (cinema_id, name, location, created_at) VALUES
(1, 'Downtown Cinema', '123 Main Street, City Center', '2024-01-01 10:00:00'),
(2, 'Uptown Theater', '456 Uptown Avenue, Suburbs', '2024-01-02 11:00:00'),
(3, 'Parkside Cineplex', '789 Park Lane, Riverside', '2024-01-03 12:00:00');

INSERT INTO cinema.screens (screen_id, cinema_id, name, capacity) VALUES
(1, 1, 'Screen 1', 100),
(2, 1, 'Screen 2', 120),
(3, 2, 'Screen A', 150);

INSERT INTO cinema.seats (seat_id, screen_id, seat_number, seat_type) VALUES
(1, 1, 'A1', 'VIP'),
(2, 1, 'A2', 'regular'),
(3, 2, 'B1', 'regular');

INSERT INTO cinema.showtimes (showtime_id, screen_id, movie_id, start_time, end_time, price) VALUES
(1, 1, 1, '2024-01-10 14:00:00', '2024-01-10 16:30:00', 10.00),
(2, 2, 2, '2024-01-11 18:00:00', '2024-01-11 20:30:00', 12.50),
(3, 3, 3, '2024-01-12 20:00:00', '2024-01-12 23:15:00', 15.00);

INSERT INTO cinema.bookings (booking_id, user_id, showtime_id, booking_date, total_price, status) VALUES
(1, 1, 1, '2024-01-05 10:00:00', 10.00, 'confirmed'),
(2, 2, 2, '2024-01-06 11:30:00', 25.00, 'pending'),
(3, 3, 3, '2024-01-07 15:45:00', 15.00, 'canceled');

INSERT INTO cinema.booking_details (booking_detail_id, booking_id, seat_id, price) VALUES
(1, 1, 1, 10.00),
(2, 2, 2, 12.50),
(3, 3, 3, 15.00);

INSERT INTO cinema.payments (payment_id, booking_id, payment_date, amount, payment_method, status) VALUES
(1, 1, '2024-01-05 10:15:00', 10.00, 'Credit Card', 'completed'),
(2, 2, '2024-01-06 11:45:00', 25.00, 'PayPal', 'completed'),
(3, 3, '2024-01-07 16:00:00', 15.00, 'Cash', 'failed');

-- task 1

-- 1
select * from cinema.users
where (user_id > 100 and ("role" = 'admin' or "role" = 'admin'));

-- 2
select * from cinema.movies
where ((rating between 7 and 9) and duration_minutes >= 90);

-- 3
select * from cinema.bookings
where((total_price >= 50) and status <> 'canceled');

-- 4
select * from cinema.payments
where (amount >= 100 or payment_method = 'Credit Card');

-- task 2

-- 1
select * from cinema.users
where email like '%gmail.com';

-- 2
select * from cinema.movies 
where (rating >= 8);

-- 3
select * from cinema.bookings
where (user_id = 3);

-- 4
select * from cinema.showtimes
where ((movie_id = 3) and (extract(hour from start_time)) > 18)

-- task 3

-- 1
select distinct genre from cinema.movies;

-- 2
select distinct "location" from cinema.cinemas;

-- 3
select distinct status from cinema.bookings;

-- 4
select distinct start_time from cinema.showtimes;

-- task 4

-- 1
select * from cinema.users
order by created_at desc;

-- 2
select * from cinema.movies
order by release_date asc;

-- 3
select * from cinema.bookings
order by total_price desc;

-- 4
select * from cinema.payments
order by payment_date desc;

-- task 5

-- 1
select * from cinema.users
where "name" like 'A%';

-- 2
select * from cinema.movies
where title like '%Love%';

-- 3
select * from cinema.bookings
where extract(year from booking_date) = 2024;

-- 4
select * from cinema.cinemas
where "name" like '%Theater';

-- task 6

-- 1
select user_id as "User ID", "name" as "Full Name", email as "Email Address"
from cinema.users;

-- 2
select title as "Movie Title", release_date as "Release Date", rating as "Viewer Rating"
from cinema.movies;

-- 3
select booking_date as "Booking Date", status as "Booking Status", total_price as "Amount Paid"
from cinema.bookings;

-- 4
select start_time as "Show Start Time", price as "Ticket price", screen_id as "Screen ID"
from cinema.showtimes;