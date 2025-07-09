DROP DATABASE IF EXISTS escritorio;
CREATE DATABASE escritorio;
USE escritorio;

CREATE TABLE usuarios (
  id_usuario INT NOT NULL AUTO_INCREMENT,
  email VARCHAR(100) NOT NULL UNIQUE,
  senha TEXT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE,
  endereco VARCHAR(100),
  bairro VARCHAR(50),
  cidade VARCHAR(50),
  uf CHAR(2),
  cep VARCHAR(9),
  telefone VARCHAR(15),
  tipo_usuario ENUM('cliente', 'advogado', 'administrador') NOT NULL,
  ativo CHAR(1) DEFAULT 'S',
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario)
);

CREATE TABLE precadastro (
  id_precad INT NOT NULL AUTO_INCREMENT,
  CPF VARCHAR(11) NOT NULL UNIQUE,
  PRIMARY KEY (id_precad)
);

CREATE TABLE clientes (
  id_cliente INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL UNIQUE,
  PRIMARY KEY (id_cliente),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE advogados (
  id_advogado INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL UNIQUE,
  oab VARCHAR(20) NOT NULL UNIQUE,
  especialidade ENUM('Geral', 'Civil', 'Criminal', 'Trabalhista', 'Empresarial'),
  PRIMARY KEY (id_advogado),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE administradores (
  id_administrador INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL UNIQUE,
  PRIMARY KEY (id_administrador),
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE agendamentos (
  id_agendamento INT NOT NULL AUTO_INCREMENT,
  id_cliente INT NOT NULL,
  id_advogado INT NOT NULL,
  data DATE NOT NULL,
  hora TIME NOT NULL,
  descricao TEXT,
  status ENUM('agendado', 'concluído', 'cancelado') DEFAULT 'agendado',
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_agendamento),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE,
  FOREIGN KEY (id_advogado) REFERENCES advogados(id_advogado) ON DELETE CASCADE
);

CREATE TABLE processos (
  id_processos INT NOT NULL AUTO_INCREMENT,
  id_advogado INT NOT NULL,
  id_cliente INT NOT NULL,
  descricao TEXT,
  status ENUM('em analise', 'concluído', 'cancelado') DEFAULT 'em analise',
  PRIMARY KEY (id_processos),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE,
  FOREIGN KEY (id_advogado) REFERENCES advogados(id_advogado) ON DELETE CASCADE
);

CREATE TABLE tipo_documento (
  id_tipo_documento INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(70) NOT NULL UNIQUE,
  PRIMARY KEY (id_tipo_documento)
);

CREATE TABLE documentos (
  id_documento INT NOT NULL AUTO_INCREMENT,
  id_cliente INT NOT NULL,
  id_tipo_documento INT NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  descricao TEXT,
  caminho_arquivo TEXT NOT NULL,
  data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_documento),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE,
  FOREIGN KEY (id_tipo_documento) REFERENCES tipo_documento(id_tipo_documento) ON DELETE RESTRICT
);

CREATE TABLE solicitacoes (
  id_solicitacao INT NOT NULL AUTO_INCREMENT,
  id_advogado INT NOT NULL,
  id_cliente INT NOT NULL,
  id_tipo_documento INT NOT NULL,
  descricao TEXT,
  status ENUM('pendente', 'concluída', 'expirada', 'cancelada') DEFAULT 'pendente',
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  data_limite DATE NULL DEFAULT NULL,
  PRIMARY KEY (id_solicitacao),
  FOREIGN KEY (id_advogado) REFERENCES advogados(id_advogado) ON DELETE CASCADE,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE,
  FOREIGN KEY (id_tipo_documento) REFERENCES tipo_documento(id_tipo_documento) ON DELETE RESTRICT
);

INSERT INTO `usuarios` (`email`, `senha`, `nome`, `cpf`, `endereco`, `bairro`, `cidade`, `uf`, `cep`, `telefone`, `tipo_usuario`)
VALUES 
('admin1@escritorio.com', 'senhaAdmin1', 'Administrador 1', '12345678900', 'Endereço 1', 'Bairro 1', 'Cidade 1', 'UF', '12345-678', '(11) 99999-0000', 'administrador');

SET @id_usuario_1 = LAST_INSERT_ID();

INSERT INTO `administradores` (`id_usuario`)
VALUES 
(@id_usuario_1);

INSERT INTO `usuarios` (`email`, `senha`, `nome`, `cpf`, `endereco`, `bairro`, `cidade`, `uf`, `cep`, `telefone`, `tipo_usuario`)
VALUES 
('admin2@escritorio.com', 'senhaAdmin2', 'Administrador 2', '23456789012', 'Endereço 2', 'Bairro 2', 'Cidade 2', 'UF', '23456-789', '(11) 88888-1111', 'administrador');

SET @id_usuario_2 = LAST_INSERT_ID();

INSERT INTO `administradores` (`id_usuario`)
VALUES 
(@id_usuario_2);

INSERT INTO `precadastro` (`CPF`)
VALUES 
('12345678910');
