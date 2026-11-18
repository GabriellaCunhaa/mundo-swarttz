-- =============================================================
-- Mundo Swarttz: dados de exemplo e consultas
-- Rodar DEPOIS de criar_banco.sql, na aba "SQL" do banco mundo_swarttz.
-- O arquivo roda inteiro, de cima para baixo, sem erro.
-- Nomes e e-mails são inventados (@exemplo.com) para não expor ninguém.
-- =============================================================

USE mundo_swarttz;

-- -------------------------------------------------------------
-- 1. INSERT: dados de exemplo (sempre com o nome das colunas)
-- -------------------------------------------------------------

-- Visitas: cada linha é um lugar aberto no mundo 3D.
-- "projeto" só é preenchido no cinema (id do filme no js/config.js).
INSERT INTO visita (visitante, lugar, projeto, dispositivo, criada_em) VALUES
  ('a1b2c3d4-0000-4000-8000-000000000001', 'chegada',    NULL,        'celular',    '2026-11-10 09:12:00'),
  ('a1b2c3d4-0000-4000-8000-000000000001', 'cinema',     'pixelinha', 'celular',    '2026-11-10 09:15:00'),
  ('a1b2c3d4-0000-4000-8000-000000000002', 'chegada',    NULL,        'computador', '2026-11-11 14:30:00'),
  ('a1b2c3d4-0000-4000-8000-000000000002', 'biblioteca', NULL,        'computador', '2026-11-11 14:33:00'),
  ('a1b2c3d4-0000-4000-8000-000000000002', 'cinema',     'mundo',     'computador', '2026-11-11 14:36:00'),
  ('a1b2c3d4-0000-4000-8000-000000000003', 'cinema',     'jc',        'tablet',     '2026-11-12 20:05:00'),
  ('a1b2c3d4-0000-4000-8000-000000000003', 'cartas',     NULL,        'tablet',     '2026-11-12 20:09:00'),
  ('a1b2c3d4-0000-4000-8000-000000000004', 'cinema',     'preco',     'celular',    '2026-11-13 08:40:00'),
  ('a1b2c3d4-0000-4000-8000-000000000005', 'telefone',   NULL,        'computador', '2026-11-14 16:20:00'),
  ('a1b2c3d4-0000-4000-8000-000000000005', 'sobre',      NULL,        'computador', '2026-11-14 16:24:00');

-- Curtidas: um voto por visitante em cada projeto.
INSERT INTO curtida (visitante, projeto, tipo, atualizada_em) VALUES
  ('a1b2c3d4-0000-4000-8000-000000000001', 'pixelinha', 'curtir',    '2026-11-10 09:16:00'),
  ('a1b2c3d4-0000-4000-8000-000000000002', 'mundo',     'curtir',    '2026-11-11 14:37:00'),
  ('a1b2c3d4-0000-4000-8000-000000000002', 'pixelinha', 'curtir',    '2026-11-11 14:40:00'),
  ('a1b2c3d4-0000-4000-8000-000000000003', 'jc',        'descurtir', '2026-11-12 20:06:00'),
  ('a1b2c3d4-0000-4000-8000-000000000004', 'preco',     'curtir',    '2026-11-13 08:41:00'),
  ('a1b2c3d4-0000-4000-8000-000000000005', 'painel',    'curtir',    '2026-11-14 16:25:00');

-- Mensagens do formulário de contato.
INSERT INTO mensagem (nome, email, assunto, texto, status, criada_em) VALUES
  ('Carla Dias',   'carla@exemplo.com',  'Orçamento de site',      'Oi, Gabriella! Quero um site para a minha loja.',          'respondida', '2026-11-09 10:00:00'),
  ('Diego Melo',   'diego@exemplo.com',  'Parceria em projeto',    'Vi o PixeLinha e queria conversar sobre uma parceria.',   'lida',       '2026-11-11 18:20:00'),
  ('Elisa Rocha',  'elisa@exemplo.com',  'Vaga de estágio',        'Temos uma vaga de estágio em desenvolvimento web.',       'nova',       '2026-11-13 09:45:00'),
  ('Fábio Lima',   'fabio@exemplo.com',  'Dúvida sobre o mundo 3D','Como você fez os gatos andarem pelo mundo?',              'nova',       '2026-11-14 21:10:00'),
  ('Gisele Nunes', 'gisele@exemplo.com', 'Vaga remota',            'Procuramos dev júnior para uma vaga remota. Tem interesse?', 'nova',    '2026-11-15 11:30:00');

-- -------------------------------------------------------------
-- 2. SELECT: consultas do painel admin
-- -------------------------------------------------------------

-- WHERE: mensagens que ainda não foram lidas.
SELECT id, nome, assunto, criada_em
FROM mensagem
WHERE status = 'nova';

-- WHERE com AND: quem curtiu o projeto PixeLinha.
SELECT visitante, atualizada_em
FROM curtida
WHERE projeto = 'pixelinha' AND tipo = 'curtir';

-- ORDER BY: visitas do cinema, da mais recente para a mais antiga.
SELECT projeto, dispositivo, criada_em
FROM visita
WHERE lugar = 'cinema'
ORDER BY criada_em DESC;

-- LIKE: mensagens que falam de vaga (qualquer texto antes ou depois de "vaga").
SELECT id, nome, assunto
FROM mensagem
WHERE assunto LIKE '%vaga%';

-- LIMIT: as 3 últimas mensagens que chegaram.
SELECT id, nome, assunto, status
FROM mensagem
ORDER BY criada_em DESC
LIMIT 3;

-- -------------------------------------------------------------
-- 3. UPDATE e DELETE: sempre com WHERE, conferidos com SELECT
--    Primeiro o SELECT com o MESMO WHERE mostra exatamente
--    quais linhas vão mudar. Só depois vem o UPDATE/DELETE.
-- -------------------------------------------------------------

-- UPDATE: a Gabriella leu a mensagem 3 no painel.
SELECT id, nome, status FROM mensagem WHERE id = 3;     -- antes: 1 linha, status 'nova'
UPDATE mensagem SET status = 'lida' WHERE id = 3;
SELECT id, nome, status FROM mensagem WHERE id = 3;     -- depois: status 'lida'

-- DELETE: o visitante 4 desfez a curtida no projeto da calculadora.
SELECT id, visitante, projeto, tipo FROM curtida
WHERE visitante = 'a1b2c3d4-0000-4000-8000-000000000004' AND projeto = 'preco';   -- antes: 1 linha
DELETE FROM curtida
WHERE visitante = 'a1b2c3d4-0000-4000-8000-000000000004' AND projeto = 'preco';
SELECT id, visitante, projeto, tipo FROM curtida
WHERE visitante = 'a1b2c3d4-0000-4000-8000-000000000004' AND projeto = 'preco';   -- depois: nenhuma linha

-- O teste do erro de integridade (voto duplicado, erro #1062) fica em teste_integridade.sql.
