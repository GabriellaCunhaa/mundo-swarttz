-- =============================================================
-- Mundo Swarttz: criação do banco MySQL
-- Segue database/dicionario_dados.md (modelo normalizado até a 3FN).
-- Como rodar: veja database/README.md.
-- Atenção: este script APAGA e recria o banco mundo_swarttz.
-- =============================================================

DROP DATABASE IF EXISTS mundo_swarttz;
CREATE DATABASE mundo_swarttz
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE mundo_swarttz;

-- As três tabelas são independentes (nenhuma tem chave estrangeira),
-- então a ordem de criação não importa.

-- Contador de visitas: cada linha é um lugar aberto no mundo 3D.
CREATE TABLE visita (
  id           BIGINT      NOT NULL AUTO_INCREMENT,
  visitante    CHAR(36)    NOT NULL,
  lugar        VARCHAR(20) NOT NULL,
  projeto      VARCHAR(30) NULL,
  dispositivo  ENUM('celular','computador','tablet') NULL,
  criada_em    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_visita PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Curtir e descurtir: um voto por visitante em cada projeto do portfólio
-- (projeto = id do projeto no config.js, ex.: 'pixelinha').
CREATE TABLE curtida (
  id             BIGINT      NOT NULL AUTO_INCREMENT,
  visitante      CHAR(36)    NOT NULL,
  projeto        VARCHAR(30) NOT NULL,
  tipo           ENUM('curtir','descurtir') NOT NULL,
  atualizada_em  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_curtida PRIMARY KEY (id),
  CONSTRAINT uq_curtida_visitante_projeto UNIQUE (visitante, projeto)
) ENGINE=InnoDB;

-- Formulário de contato.
CREATE TABLE mensagem (
  id         INT          NOT NULL AUTO_INCREMENT,
  nome       VARCHAR(80)  NOT NULL,
  email      VARCHAR(120) NOT NULL,
  assunto    VARCHAR(120) NULL,
  texto      TEXT         NOT NULL,
  status     ENUM('nova','lida','respondida') NOT NULL DEFAULT 'nova',
  criada_em  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_mensagem PRIMARY KEY (id)
) ENGINE=InnoDB;
