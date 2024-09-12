-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS library;
USE library;

-- Criação da tabela de autores
CREATE TABLE IF NOT EXISTS authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50)
);

-- Criação da tabela de categorias
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Criação da tabela de livros
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author_id INT,
    category_id INT,
    publication_date DATE,
    isbn VARCHAR(13) UNIQUE,
    available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (author_id) REFERENCES authors(id),
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Criação da tabela de empréstimos
CREATE TABLE IF NOT EXISTS loans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    borrower_name VARCHAR(100) NOT NULL,
    loan_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- Inserção de dados na tabela de autores
INSERT INTO authors (name, birth_date, nationality) VALUES
('J.K. Rowling', '1965-07-31', 'British'),
('George Orwell', '1903-06-25', 'British'),
('J.R.R. Tolkien', '1892-01-03', 'British'),
('Harper Lee', '1926-04-28', 'American')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    birth_date = VALUES(birth_date),
    nationality = VALUES(nationality);

-- Inserção de dados na tabela de categorias
INSERT INTO categories (name) VALUES
('Fantasy'),
('Science Fiction'),
('Mystery'),
('Non-Fiction')
ON DUPLICATE KEY UPDATE
    name = VALUES(name);

-- Inserção de dados na tabela de livros
INSERT INTO books (title, author_id, category_id, publication_date, isbn, available) VALUES
('Harry Potter and the Philosopher\'s Stone', 1, 1, '1997-06-26', '9780747532699', TRUE),
('1984', 2, 2, '1949-06-08', '9780451524935', TRUE),
('The Hobbit', 3, 1, '1937-09-21', '9780345339683', TRUE),
('To Kill a Mockingbird', 4, 3, '1960-07-11', '9780061120084', TRUE)
ON DUPLICATE KEY UPDATE
    title = VALUES(title),
    author_id = VALUES(author_id),
    category_id = VALUES(category_id),
    publication_date = VALUES(publication_date),
    isbn = VALUES(isbn),
    available = VALUES(available);

-- Inserção de dados na tabela de empréstimos
INSERT INTO loans (book_id, borrower_name, loan_date, return_date) VALUES
(1, 'Alice Smith', '2024-09-01', NULL),
(2, 'Bob Johnson', '2024-09-10', '2024-09-25'),
(3, 'Charlie Brown', '2024-09-15', NULL)
ON DUPLICATE KEY UPDATE
    book_id = VALUES(book_id),
    borrower_name = VALUES(borrower_name),
    loan_date = VALUES(loan_date),
    return_date = VALUES(return_date);
