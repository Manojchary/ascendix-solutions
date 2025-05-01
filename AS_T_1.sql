

-- creating data base for library users database
CREATE DATABASE LIBRARY_USERS;
-- using database 
USE LIBRARY_USERS;

-- USERS: Stores details of people registered in the system (members or staff) 
CREATE TABLE users_table(
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email_id VARCHAR(100) UNIQUE NOT NULL,
    phone_no VARCHAR(15),
    role ENUM('member', 'staff') DEFAULT 'member',
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BOOKS: Information about books available in the library 
CREATE TABLE books_table(
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title_name VARCHAR(255) NOT NULL,
    author_name VARCHAR(100),
    genre_type VARCHAR(50),
    isbn_no VARCHAR(20) UNIQUE,
    total_no_copies INT NOT NULL CHECK (total_copies >= 0),
    available_copies INT NOT NULL CHECK (available_copies >= 0),
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TRANSACTIONS: Records when a user borrows or returns a book
-- date should be in the form of 'YYYY-MM-DD'
CREATE TABLE transactions_table(
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    date_of_issue DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('borrowed', 'returned', 'late') DEFAULT 'borrowed',
    -- Foreign key constraints for referential integrity
    FOREIGN KEY (user_id) REFERENCES users_table(user_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES bookstable(book_id) ON DELETE CASCADE
);

-- INDEXES for performance on frequent search/filter operations effectively 
CREATE INDEX idx_user_email ON users_table(email_id);
CREATE INDEX idx_book_title ON books_table(title_name);
CREATE INDEX idx_transaction_user_book ON transactions_table(user_id, book_id);



-- Insert sample users of library --
INSERT INTO users_table(full_name, email_id, phone_no, role)
VALUES 
('Aarav Kumar', 'aarav.kumar@example.com', '9876543210', 'member'),
('Priya Sharma', 'priya.sharma@example.com', '9876512345', 'staff');

-- Insert sample books
INSERT INTO books_table(title_name, author_name, genre_type, isbn_no, total_no_copies, available_copies)
VALUES
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', '9780061120084', 5, 5),
('1984', 'George Orwell', 'Dystopian', '9780451524935', 3, 3);

-- Insert a sample transaction --
INSERT INTO transactions_table(user_id, book_id, date_of_issue, due_date, status)
VALUES
(1, 2, '2025-04-20', '2025-05-04', 'borrowed');

-- Retrieving all borrowed books that are currently overdue and not yet returned.
SELECT 
    u.full_name,
    b.title_name, --
    t.issue_date,
    t.date_of_issue
FROM 
    transactions AS t
JOIN users AS u ON t.user_id = u.user_id-- inner joining at user_id
JOIN books AS b ON t.book_id = b.book_id -- inner joining at book_id
WHERE 
    t.return_date IS NULL -- making condition that , return_date is null
    AND t.due_date < CURDATE() -- and due_date is less than persert data
    AND t.status = 'borrowed'; -- and conforming that the user is borrowed form the store
