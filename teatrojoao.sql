CREATE DATABASE IF NOT EXISTS teatro;
USE teatro;
 
-- Tabela para armazenar informações de locais
CREATE TABLE local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL
);
 
-- Tabela para armazenar informações de peças
CREATE TABLE peça (
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
 
-- Tabela para armazenar informações de atores
CREATE TABLE ator (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);
 
-- Tabela para armazenar informações de diretores
CREATE TABLE diretor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);
 
-- Tabela para armazenar informações de produtores
CREATE TABLE produtor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);
 
-- Tabela para relacionar atores e peças
CREATE TABLE ator_peça (
    id_atr INT,
    id_peça INT,
    papel VARCHAR(255),
    PRIMARY KEY (id_atr, id_peça),
    FOREIGN KEY (id_atr) REFERENCES ator(id),
    FOREIGN KEY (id_peça) REFERENCES peça(id)
);
 
-- Tabela para armazenar informações de horários de apresentação
CREATE TABLE horario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_peça INT,
    data_hora DATETIME NOT NULL,
    FOREIGN KEY (id_peça) REFERENCES peça(id)
);