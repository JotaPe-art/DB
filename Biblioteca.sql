-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS library;
USE library;

-- Criação da tabela de autores
CREATE TABLE IF NOT EXISTS authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    UNIQUE (name)
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

-- Criação de Procedures e Functions

DELIMITER //

-- Procedure para adicionar um novo autor
CREATE PROCEDURE AddAuthor (
    IN p_name VARCHAR(100),
    IN p_birth_date DATE,
    IN p_nationality VARCHAR(50)
)
BEGIN
    INSERT INTO authors (name, birth_date, nationality)
    VALUES (p_name, p_birth_date, p_nationality)
    ON DUPLICATE KEY UPDATE
        birth_date = VALUES(birth_date),
        nationality = VALUES(nationality);
END //

-- Procedure para adicionar um novo livro
CREATE PROCEDURE AddBook (
    IN p_title VARCHAR(150),
    IN p_author_id INT,
    IN p_category_id INT,
    IN p_publication_date DATE,
    IN p_isbn VARCHAR(13),
    IN p_available BOOLEAN
)
BEGIN
    INSERT INTO books (title, author_id, category_id, publication_date, isbn, available)
    VALUES (p_title, p_author_id, p_category_id, p_publication_date, p_isbn, p_available)
    ON DUPLICATE KEY UPDATE
        title = VALUES(title),
        author_id = VALUES(author_id),
        category_id = VALUES(category_id),
        publication_date = VALUES(publication_date),
        available = VALUES(available);
END //

-- Procedure para registrar um empréstimo
CREATE PROCEDURE RegisterLoan (
    IN p_book_id INT,
    IN p_borrower_name VARCHAR(100),
    IN p_loan_date DATE
)
BEGIN
    INSERT INTO loans (book_id, borrower_name, loan_date, return_date)
    VALUES (p_book_id, p_borrower_name, p_loan_date, NULL);
    
    -- Atualiza a disponibilidade do livro
    UPDATE books
    SET available = FALSE
    WHERE id = p_book_id;
END //

-- Procedure para registrar a devolução de um livro
CREATE PROCEDURE RegisterReturn (
    IN p_loan_id INT,
    IN p_return_date DATE
)
BEGIN
    -- Atualiza a data de devolução e a disponibilidade do livro
    UPDATE loans
    SET return_date = p_return_date
    WHERE id = p_loan_id;

    -- Atualiza a disponibilidade do livro
    UPDATE books
    SET available = TRUE
    WHERE id = (SELECT book_id FROM loans WHERE id = p_loan_id);
END //

-- Função para obter o número de livros disponíveis em uma categoria
CREATE FUNCTION GetAvailableBooksCountByCategory (
    p_category_id INT
) RETURNS INT
BEGIN
    DECLARE available_books_count INT;
    
    SELECT COUNT(*)
    INTO available_books_count
    FROM books
    WHERE category_id = p_category_id AND available = TRUE;
    
    RETURN available_books_count;
END //

-- Função para obter informações do autor pelo nome
CREATE FUNCTION GetAuthorByName (
    p_name VARCHAR(100)
) RETURNS TABLE (
    id INT,
    birth_date DATE,
    nationality VARCHAR(50)
)
BEGIN
    RETURN (
        SELECT id, birth_date, nationality
        FROM authors
        WHERE name = p_name
    );
END //

-- Função para verificar a disponibilidade de um livro
CREATE FUNCTION IsBookAvailable (
    p_book_id INT
) RETURNS BOOLEAN
BEGIN
    DECLARE book_available BOOLEAN;

    SELECT available
    INTO book_available
    FROM books
    WHERE id = p_book_id;

    RETURN book_available;
END //

DELIMITER ;
