-- creating database for movies
CREATE DATABASE MOVIES_DB;
-- USING DATABSE
USE MOVIES_DB;


-- DIRECTORS: Basic info about directors
CREATE TABLE directors(
    director_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    nationality VARCHAR(50),
    birth_year YEAR
);

-- ACTORS: Basic info about actors
CREATE TABLE actors(
    actor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    gender_type ENUM('Male', 'Female', 'Other'),
    YOB YEAR -- YEAR OF BIRTH 'YYYY'
);

-- MOVIES: Stores movie info including director
CREATE TABLE movies(
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title_name VARCHAR(150) NOT NULL,
    release_year YEAR,
    genre_type VARCHAR(50),
    duration_minutes INT CHECK (duration_minutes > 0),
    director_id INT,
    FOREIGN KEY (director_id) REFERENCES directors(director_id) ON DELETE SET NULL
);

-- MOVIE_ACTORS: Many-to-many relation between movies and actors
CREATE TABLE movie_actors(
    movie_id INT,
    actor_id INT,
    role_name VARCHAR(100),
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (actor_id) REFERENCES actors(actor_id) ON DELETE CASCADE
);

-- Indexes for efficient filtering
CREATE INDEX idx_genre_year ON movies(genre_type, release_year);
CREATE INDEX idx_actor_name ON actors(full_name);

-- Sample directors
INSERT INTO directors (full_name, nationality, YOB)
VALUES 
('Christopher Nolan', 'British-American', 1970),
('S. S. Rajamouli', 'Indian', 1973);

-- Sample actors data
INSERT INTO actors (full_name, gender, YOB)
VALUES 
('Leonardo DiCaprio', 'Male', 1974),
('Ram Charan', 'Male', 1985),
('Alia Bhatt', 'Female', 1993);

-- Sample movies data 
INSERT INTO movies (title_name, release_year, genre_type, duration_minutes, director_id)
VALUES 
('Inception', 2010, 'Sci-Fi', 148, 1),
('RRR', 2022, 'Action', 182, 2);

-- Sample movie-actor relationships data
INSERT INTO movie_actors (movie_id, actor_id, role_name)
VALUES 
(1, 1, 'Dom Cobb'),
(2, 2, 'Alluri Sitarama Raju'),
(2, 3, 'Sita');


-- INSIGHTFULL SELECT QUERY 1 TO " List all movies with their director's name "
SELECT 
    m.title,
    m.release_year,
    m.genre,
    d.full_name AS director
FROM movies AS m
LEFT JOIN directors AS d ON m.director_id = d.director_id;

-- INSIGHTFULL SELECT QUERY 2 TO Count how many movies each actor has appeared in"
SELECT 
    a.full_name,
    COUNT(ma.movie_id) AS movie_count
FROM actors AS a
JOIN movie_actors AS ma ON a.actor_id = ma.actor_id
GROUP BY a.actor_id
ORDER BY movie_count DESC;
