-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS halloween_party;
USE halloween_party;

-- Criação da tabela de fantasias
CREATE TABLE IF NOT EXISTS costumes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(100) NOT NULL,
    size ENUM('S', 'M', 'L', 'XL') NOT NULL,
    available BOOLEAN DEFAULT TRUE
);

-- Criação da tabela de eventos
CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_date DATE NOT NULL,
    location VARCHAR(100) NOT NULL,
    description TEXT
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
    description = VALUES(description),
    size = VALUES(size),
    available = VALUES(available);

-- Inserção de dados na tabela de eventos
INSERT INTO events (event_name, event_date, location, description) VALUES
('Festa de Halloween 2024', '2024-10-31', 'Clube dos Espantos', 'Uma noite aterrorizante com muitas surpresas.'),
('Desfile de Fantasias', '2024-10-30', 'Praça das Bruxas', 'Mostre sua fantasia e ganhe prêmios assustadores!')
ON DUPLICATE KEY UPDATE
    event_name = VALUES(event_name),
    event_date = VALUES(event_date),
    location = VALUES(location),
    description = VALUES(description);

-- Inserção de dados na tabela de convidados
INSERT INTO guests (name, email, RSVP, costume_id) VALUES
('João Silva', 'joao.silva@email.com', TRUE, 1),
('Maria Oliveira', 'maria.oliveira@email.com', FALSE, 2),
('Pedro Santos', 'pedro.santos@email.com', TRUE, 3)
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    email = VALUES(email),
    RSVP = VALUES(RSVP),
    costume_id = VALUES(costume_id);
