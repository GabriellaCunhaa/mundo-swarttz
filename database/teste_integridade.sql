-- =============================================================
-- Mundo Swarttz: teste de integridade (um voto por alvo)
-- Rodar DEPOIS de criar_banco.sql, na aba "SQL" do banco mundo_swarttz.
-- =============================================================

USE mundo_swarttz;

-- 1. O visitante a1b2c3... curte o projeto pixelinha. O MySQL aceita.
INSERT INTO curtida (visitante, alvo, tipo)
VALUES ('a1b2c3d4-0000-4000-8000-000000000001', 'pixelinha', 'curtir');

-- 2. Ele muda de ideia. É assim que a API grava um voto:
--    se já existe voto desse visitante nesse alvo, só troca o tipo.
INSERT INTO curtida (visitante, alvo, tipo)
VALUES ('a1b2c3d4-0000-4000-8000-000000000001', 'pixelinha', 'descurtir')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);

-- Continua com UMA linha só, agora com tipo = 'descurtir'.
SELECT visitante, alvo, tipo FROM curtida;

-- 3. Tentativa: gravar um SEGUNDO voto do mesmo visitante no mesmo alvo.
--    O MySQL DEVE RECUSAR, por causa do UNIQUE uq_curtida_visitante_alvo.
INSERT INTO curtida (visitante, alvo, tipo)
VALUES ('a1b2c3d4-0000-4000-8000-000000000001', 'pixelinha', 'curtir');

-- Erro esperado (veja database/README.md):
-- #1062 - Duplicate entry 'a1b2c3d4-0000-4000-8000-000000000001-pixelinha'
-- for key 'uq_curtida_visitante_alvo'
