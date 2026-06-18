-- =========================================
-- DATABASE
-- =========================================
CREATE DATABASE football_ticket_booking;

DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================
-- 1. USERS TABLE
-- =========================================
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    role VARCHAR(50),
    phone_number VARCHAR(15),

    CHECK (role IN ('Football Fan', 'Ticket Manager'))
);

-- =========================================
-- 2. MATCHES TABLE
-- =========================================
CREATE TABLE Matches (
    match_id SERIAL PRIMARY KEY,
    fixture VARCHAR(50),
    tournament_category VARCHAR(50),
    base_ticket_price NUMERIC(10,2),
    match_status VARCHAR(20),

    CHECK (base_ticket_price >= 0),

    CHECK (match_status IN ('Available','Selling Fast','Sold Out','Postponed'))
);

-- =========================================
-- 3. BOOKINGS TABLE
-- =========================================
CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT,
    match_id INT,
    seat_number VARCHAR(50),
    payment_status VARCHAR(50),
    total_cost NUMERIC(10,2),

    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),

    CHECK (total_cost >= 0),

    CHECK (payment_status IN ('Pending','Confirmed','Cancelled','Refunded') OR payment_status IS NULL)
);

-- =========================================
-- DATA INSERT (USERS)
-- =========================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================
-- DATA INSERT (MATCHES)
-- =========================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================
-- DATA INSERT (BOOKINGS)
-- =========================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- =========================================
-- QUERY 1
-- =========================================
SELECT match_id,fixture,CAST(base_ticket_price AS INT) AS base_ticket_price FROM Matches
WHERE tournament_category = 'Champions League'
AND match_status = 'Available';

-- =========================================
-- QUERY 2
-- =========================================
SELECT user_id,full_name,email FROM Users
WHERE full_name ILIKE 'Tanvir%'
OR full_name ILIKE '%Haque%';

-- =========================================
-- QUERY 3
-- =========================================
SELECT booking_id,user_id,match_id,COALESCE(payment_status, 'Action Required') AS systematic_statusFROM Bookings
WHERE payment_status IS NULL;

-- =========================================
-- QUERY 4
-- =========================================
SELECT b.booking_id,u.full_name,m.fixture,CAST(b.total_cost AS INT) AS total_cost FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Matches m ON b.match_id = m.match_id
ORDER BY b.booking_id;

-- =========================================
-- QUERY 5
-- =========================================
SELECT u.user_id,u.full_name,b.booking_id FROM Users u
LEFT JOIN Bookings b ON u.user_id = b.user_id
ORDER BY u.user_id, b.booking_id;

-- =========================================
-- QUERY 6
-- =========================================
SELECT booking_id,match_id,CAST(total_cost AS INT) AS total_costFROM Bookings
WHERE total_cost >
(
    SELECT AVG(total_cost)
    FROM Bookings
);

-- =========================================
-- QUERY 7
-- =========================================
SELECT match_id,fixture,CAST(base_ticket_price AS INT) AS base_ticket_price FROM Matches
ORDER BY base_ticket_price DESC
LIMIT 2 OFFSET 1;