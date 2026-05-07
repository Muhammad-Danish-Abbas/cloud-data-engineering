
-- CREATE DATABASE

CREATE DATABASE CarPlatform;
GO

USE CarPlatform;
GO

-- USERS TABLE

CREATE TABLE users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    created_at DATETIME DEFAULT GETDATE()
);
GO


-- CARS TABLE

CREATE TABLE cars (
    car_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    title VARCHAR(150),
    brand VARCHAR(50),
    model VARCHAR(50),
    year INT,
    price DECIMAL(10,2),
    mileage INT,
    fuel_type VARCHAR(10) CHECK (fuel_type IN ('Petrol','Diesel','Hybrid','Electric')),
    transmission VARCHAR(10) CHECK (transmission IN ('Manual','Automatic')),
    description VARCHAR(MAX),
    status VARCHAR(15) DEFAULT 'Available'
           CHECK (status IN ('Available','Sold Out')),
    posted_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
GO

-- =========================
-- CAR IMAGES
-- =========================
CREATE TABLE car_images (
    image_id INT PRIMARY KEY IDENTITY(1,1),
    car_id INT,
    image_url VARCHAR(255),
    uploaded_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE
);
GO

-- =========================
-- FAVORITES
-- =========================
CREATE TABLE favorites (
    fav_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    car_id INT,
    added_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (car_id) REFERENCES cars(car_id)
);
GO

-- =========================
-- REVIEWS (RATING SYSTEM)
-- =========================
CREATE TABLE reviews (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    seller_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (seller_id) REFERENCES users(user_id)
);
GO

-- =========================
-- MESSAGES (CHAT SYSTEM)
-- =========================
CREATE TABLE messages (
    message_id INT PRIMARY KEY IDENTITY(1,1),
    sender_id INT,
    receiver_id INT,
    message_text VARCHAR(500),
    sent_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (sender_id) REFERENCES users(user_id),
    FOREIGN KEY (receiver_id) REFERENCES users(user_id)
);
GO

-- =========================
-- INSERT USERS
-- =========================
INSERT INTO users (name, email, phone, city) VALUES
('Ali Khan', 'ali@email.com', '03001234567', 'Karachi'),
('Sara Ahmed', 'sara@email.com', '03111234567', 'Lahore'),
('Bilal Raza', 'bilal@email.com', '03211234567', 'Islamabad'),
('Hina Malik', 'hina@email.com', '03311234567', 'Karachi'),
('Usman Tariq', 'usman@email.com', '03411234567', 'Peshawar');
GO

-- =========================
-- INSERT CARS
-- =========================
INSERT INTO cars (user_id, title, brand, model, year, price, mileage, fuel_type, transmission, description, status) VALUES
(1, 'Toyota Corolla 2020', 'Toyota', 'Corolla', 2020, 3200000, 45000, 'Petrol', 'Automatic', 'Good condition', 'Available'),
(2, 'Honda Civic 2021', 'Honda', 'Civic', 2021, 5800000, 30000, 'Petrol', 'Automatic', 'Like new', 'Available'),
(3, 'KIA Sportage 2022', 'KIA', 'Sportage', 2022, 9500000, 15000, 'Petrol', 'Automatic', 'Full option', 'Available'),
(4, 'Suzuki Mehran 2016', 'Suzuki', 'Mehran', 2016, 950000, 80000, 'Petrol', 'Manual', 'Budget car', 'Available'),
(5, 'Toyota Hilux 2020', 'Toyota', 'Hilux', 2020, 7800000, 35000, 'Diesel', 'Automatic', '4x4', 'Available');
GO

-- =========================
-- INSERT FAVORITES
-- =========================
INSERT INTO favorites (user_id, car_id) VALUES
(1,2),(1,3),(2,1),(3,2),(4,1);
GO

-- =========================
-- INSERT REVIEWS
-- =========================
INSERT INTO reviews (user_id, seller_id, rating, comment) VALUES
(2,1,5,'Excellent seller'),
(3,1,4,'Good deal'),
(4,2,5,'Highly recommended'),
(5,3,3,'Average experience');
GO

-- =========================
-- INSERT MESSAGES
-- =========================
INSERT INTO messages (sender_id, receiver_id, message_text) VALUES
(1,2,'Is car available?'),
(2,1,'Yes available'),
(3,1,'Final price?'),
(1,3,'Please call me');
GO

-- =========================
-- VIEW (FOR DISPLAY)
-- =========================
CREATE VIEW car_details_view AS
SELECT 
    c.title,
    c.brand,
    c.price,
    u.name AS owner,
    u.city
FROM cars c
JOIN users u ON c.user_id = u.user_id;
GO

-- =========================
-- STORED PROCEDURE (SEARCH)
-- =========================
CREATE PROCEDURE search_cars
    @city VARCHAR(50),
    @min_price DECIMAL,
    @max_price DECIMAL
AS
BEGIN
    SELECT c.title, c.price, u.city, u.name
    FROM cars c
    JOIN users u ON c.user_id = u.user_id
    WHERE u.city = @city
    AND c.price BETWEEN @min_price AND @max_price
    AND c.status = 'Available';
END;
GO

-- =========================
-- TRIGGER
-- =========================
CREATE TRIGGER trg_car_update
ON cars
AFTER UPDATE
AS
BEGIN
    PRINT 'Car updated successfully';
END;
GO


-- QUERIES


-- Top Rated Sellers
SELECT seller_id, AVG(rating) AS avg_rating
FROM reviews
GROUP BY seller_id
ORDER BY avg_rating DESC;

-- Most Favorited Cars
SELECT c.title, COUNT(f.fav_id) AS likes
FROM cars c
LEFT JOIN favorites f ON c.car_id = f.car_id
GROUP BY c.title
ORDER BY likes DESC;

-- Chat Count
SELECT sender_id, receiver_id, COUNT(*) AS total_messages
FROM messages
GROUP BY sender_id, receiver_id;

-- Available Cars Under Price
SELECT c.title, c.price, u.name
FROM cars c
JOIN users u ON c.user_id = u.user_id
WHERE c.price < 5000000 AND c.status = 'Available';
GO
-- Top 3 Most Expensive Car
SELECT TOP 3 *
FROM cars
ORDER BY price DESC;

-- Show Users Who Never Posted Any Car
SELECT *
FROM users
WHERE user_id NOT IN (
    SELECT DISTINCT user_id FROM cars
);
--Most Chatty Users 
SELECT 
    sender_id,
    COUNT(*) AS total_messages
FROM messages
GROUP BY sender_id
ORDER BY total_messages DESC;

