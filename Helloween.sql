-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS halloween_party;
USE halloween_party;

-- Criação da tabela de fantasias
CREATE TABLE IF NOT EXISTS costumes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(100) NOT NULL,
    size ENUM('S', 'M', 'L', 'XL') NOT NULL,
    available BOOLEAN DEFAULT TRUE,
    UNIQUE (description, size)
);

-- Criação da tabela de eventos
CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    location VARCHAR(100) NOT NULL,
    description TEXT,
    UNIQUE (event_name, event_date)
);

-- Criação da tabela de convidados
CREATE TABLE IF NOT EXISTS guests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    RSVP BOOLEAN DEFAULT FALSE,
    costume_id INT,
    FOREIGN KEY (costume_id) REFERENCES costumes(id)
);

-- Inserção de dados na tabela de fantasias
INSERT INTO costumes (description, size, available) VALUES
('Vampiro', 'M', TRUE),
('Múmia', 'L', TRUE),
('Zumbi', 'M', TRUE),
('Fantasma', 'S', FALSE)
ON DUPLICATE KEY UPDATE
    available = VALUES(available);

-- Inserção de dados na tabela de eventos
INSERT INTO events (event_name, event_date, location, description) VALUES
('Festa de Halloween 2024', '2024-10-31', 'Clube dos Espantos', 'Uma noite aterrorizante com muitas surpresas.'),
('Desfile de Fantasias', '2024-10-30', 'Praça das Bruxas', 'Mostre sua fantasia e ganhe prêmios assustadores!')
ON DUPLICATE KEY UPDATE
    location = VALUES(location),
    description = VALUES(description);

-- Inserção de dados na tabela de convidados
INSERT INTO guests (name, email, RSVP, costume_id) VALUES
('João Silva', 'joao.silva@email.com', TRUE, 1),
('Maria Oliveira', 'maria.oliveira@email.com', FALSE, 2),
('Pedro Santos', 'pedro.santos@email.com', TRUE, 3)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    RSVP = VALUES(RSVP),
    costume_id = VALUES(costume_id);

-- Criação de Procedures e Functions

DELIMITER //

-- Procedure para adicionar uma nova fantasia
CREATE PROCEDURE add_costume (
    IN p_description VARCHAR(100),
    IN p_size ENUM('S', 'M', 'L', 'XL'),
    IN p_available BOOLEAN
)
BEGIN
    INSERT INTO costumes (description, size, available)
    VALUES (p_description, p_size, p_available)
    ON DUPLICATE KEY UPDATE
        available = VALUES(available);
END //

-- Procedure para adicionar um novo evento
CREATE PROCEDURE add_event (
    IN p_event_name VARCHAR(100),
    IN p_event_date DATE,
    IN p_location VARCHAR(100),
    IN p_description TEXT
)
BEGIN
    INSERT INTO events (event_name, event_date, location, description)
    VALUES (p_event_name, p_event_date, p_location, p_description)
    ON DUPLICATE KEY UPDATE
        location = VALUES(location),
        description = VALUES(description);
END //

-- Procedure para adicionar um novo convidado
CREATE PROCEDURE add_guest (
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_RSVP BOOLEAN,
    IN p_costume_id INT
)
BEGIN
    INSERT INTO guests (name, email, RSVP, costume_id)
    VALUES (p_name, p_email, p_RSVP, p_costume_id)
    ON DUPLICATE KEY UPDATE
        name = VALUES(name),
        RSVP = VALUES(RSVP),
        costume_id = VALUES(costume_id);
END //

-- Função para verificar se uma fantasia está disponível
CREATE FUNCTION check_costume_availability (
    p_costume_id INT
) RETURNS BOOLEAN
BEGIN
    DECLARE is_available BOOLEAN;

    SELECT available
    INTO is_available
    FROM costumes
    WHERE id = p_costume_id;

    RETURN is_available;
END //

-- Função para obter o número de convidados confirmados para um evento
CREATE FUNCTION count_rsvp_for_event (
    p_event_id INT
) RETURNS INT
BEGIN
    DECLARE rsvp_count INT;

    SELECT COUNT(*)
    INTO rsvp_count
    FROM guests
    WHERE RSVP = TRUE AND costume_id IN (SELECT id FROM events WHERE id = p_event_id);

    RETURN rsvp_count;
END //

DELIMITER ;
