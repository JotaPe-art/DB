-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS teatro;
USE teatro;

-- Criação da tabela de locais
CREATE TABLE IF NOT EXISTS local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL
);

-- Criação da tabela de diretores
CREATE TABLE IF NOT EXISTS diretor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Criação da tabela de produtores
CREATE TABLE IF NOT EXISTS produtor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Criação da tabela de peças
CREATE TABLE IF NOT EXISTS peça (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    sinopse TEXT,
    id_diretor INT,
    id_produtor INT,
    id_local INT,
    FOREIGN KEY (id_diretor) REFERENCES diretor(id),
    FOREIGN KEY (id_produtor) REFERENCES produtor(id),
    FOREIGN KEY (id_local) REFERENCES local(id)
);

-- Criação da tabela de atores
CREATE TABLE IF NOT EXISTS ator (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Criação da tabela para relacionar atores e peças
CREATE TABLE IF NOT EXISTS ator_peça (
    id_atr INT,
    id_peça INT,
    papel VARCHAR(255),
    PRIMARY KEY (id_atr, id_peça),
    FOREIGN KEY (id_atr) REFERENCES ator(id),
    FOREIGN KEY (id_peça) REFERENCES peça(id)
);

-- Criação da tabela de horários
CREATE TABLE IF NOT EXISTS horario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_peça INT,
    data_hora DATETIME NOT NULL,
    FOREIGN KEY (id_peça) REFERENCES peça(id)
);

-- Inserção de dados iniciais

-- Dados para a tabela de locais
INSERT INTO local (nome, endereco) VALUES
('Teatro Municipal', 'Rua das Flores, 123'),
('Teatro Nacional', 'Avenida Brasil, 456')
ON DUPLICATE KEY UPDATE
    endereco = VALUES(endereco);

-- Dados para a tabela de diretores
INSERT INTO diretor (nome) VALUES
('Ana Souza'),
('Carlos Silva')
ON DUPLICATE KEY UPDATE
    nome = VALUES(nome);

-- Dados para a tabela de produtores
INSERT INTO produtor (nome) VALUES
('Fernanda Lima'),
('Ricardo Mendes')
ON DUPLICATE KEY UPDATE
    nome = VALUES(nome);

-- Dados para a tabela de peças
INSERT INTO peça (titulo, sinopse, id_diretor, id_produtor, id_local) VALUES
('O Rei Leão', 'Uma peça sobre o ciclo da vida em uma savana africana.', 1, 1, 1),
('Hamlet', 'Tragédia sobre a vingança e a corrupção.', 2, 2, 2)
ON DUPLICATE KEY UPDATE
    sinopse = VALUES(sinopse),
    id_diretor = VALUES(id_diretor),
    id_produtor = VALUES(id_produtor),
    id_local = VALUES(id_local);

-- Dados para a tabela de atores
INSERT INTO ator (nome) VALUES
('Juliana Costa'),
('Marcelo Almeida')
ON DUPLICATE KEY UPDATE
    nome = VALUES(nome);

-- Dados para a tabela de relacionamentos de atores e peças
INSERT INTO ator_peça (id_atr, id_peça, papel) VALUES
(1, 1, 'Simba'),
(2, 2, 'Hamlet')
ON DUPLICATE KEY UPDATE
    papel = VALUES(papel);

-- Dados para a tabela de horários
INSERT INTO horario (id_peça, data_hora) VALUES
(1, '2024-11-01 20:00:00'),
(2, '2024-11-02 19:00:00')
ON DUPLICATE KEY UPDATE
    data_hora = VALUES(data_hora);

-- Criação de Procedures e Functions

DELIMITER //

-- Procedure para adicionar um novo local
CREATE PROCEDURE adicionar_local (
    IN p_nome VARCHAR(255),
    IN p_endereco VARCHAR(255)
)
BEGIN
    INSERT INTO local (nome, endereco)
    VALUES (p_nome, p_endereco)
    ON DUPLICATE KEY UPDATE
        endereco = VALUES(endereco);
END //

-- Procedure para adicionar uma nova peça
CREATE PROCEDURE adicionar_peça (
    IN p_titulo VARCHAR(255),
    IN p_sinopse TEXT,
    IN p_id_diretor INT,
    IN p_id_produtor INT,
    IN p_id_local INT
)
BEGIN
    INSERT INTO peça (titulo, sinopse, id_diretor, id_produtor, id_local)
    VALUES (p_titulo, p_sinopse, p_id_diretor, p_id_produtor, p_id_local)
    ON DUPLICATE KEY UPDATE
        sinopse = VALUES(sinopse),
        id_diretor = VALUES(id_diretor),
        id_produtor = VALUES(id_produtor),
        id_local = VALUES(id_local);
END //

-- Procedure para adicionar um novo ator
CREATE PROCEDURE adicionar_ator (
    IN p_nome VARCHAR(255)
)
BEGIN
    INSERT INTO ator (nome)
    VALUES (p_nome)
    ON DUPLICATE KEY UPDATE
        nome = VALUES(nome);
END //

-- Procedure para adicionar um relacionamento ator-peça
CREATE PROCEDURE adicionar_ator_peça (
    IN p_id_atr INT,
    IN p_id_peça INT,
    IN p_papel VARCHAR(255)
)
BEGIN
    INSERT INTO ator_peça (id_atr, id_peça, papel)
    VALUES (p_id_atr, p_id_peça, p_papel)
    ON DUPLICATE KEY UPDATE
        papel = VALUES(papel);
END //

-- Procedure para adicionar um horário de apresentação
CREATE PROCEDURE adicionar_horario (
    IN p_id_peça INT,
    IN p_data_hora DATETIME
)
BEGIN
    INSERT INTO horario (id_peça, data_hora)
    VALUES (p_id_peça, p_data_hora)
    ON DUPLICATE KEY UPDATE
        data_hora = VALUES(data_hora);
END //

-- Função para obter a sinopse de uma peça
CREATE FUNCTION obter_sinopse (
    p_id_peça INT
) RETURNS TEXT
BEGIN
    DECLARE sinopse TEXT;

    SELECT sinopse
    INTO sinopse
    FROM peça
    WHERE id = p_id_peça;

    RETURN sinopse;
END //

-- Função para contar o número de peças em um local
CREATE FUNCTION contar_peças_por_local (
    p_id_local INT
) RETURNS INT
BEGIN
    DECLARE total_peças INT;

    SELECT COUNT(*)
    INTO total_peças
    FROM peça
    WHERE id_local = p_id_local;

    RETURN total_peças;
END //

DELIMITER ;
