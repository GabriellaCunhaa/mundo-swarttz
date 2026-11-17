# Dicionário de dados — Mundo Swarttz

Modelo normalizado até a 3FN (veja `normalizacao.md`). Banco: MySQL (TiDB Cloud Starter).

**Legenda:** PK = chave primária · Obrigatório "sim" = `NOT NULL` · Regras: `UNIQUE` (valor não se repete), `DEFAULT` (valor automático quando nada é informado).

| Tabela | Coluna | Tipo | Chave | Obrigatório | Regras | Descrição |
|---|---|---|---|---|---|---|
| visita | id | `BIGINT` | PK | sim | `AUTO_INCREMENT` | Identificador do registro |
| visita | visitante | `CHAR(36)` | — | sim | — | Código aleatório do navegador (não identifica a pessoa) |
| visita | lugar | `VARCHAR(20)` | — | sim | — | chegada, cinema, biblioteca, cartas, telefone, sobre… |
| visita | projeto | `VARCHAR(30)` | — | não | — | `id` do filme aberto no cinema (ex.: pixelinha); vazio nos outros lugares |
| visita | dispositivo | `ENUM('celular','computador','tablet')` | — | não | — | Tipo de tela |
| visita | criada_em | `DATETIME` | — | sim | `DEFAULT CURRENT_TIMESTAMP` | Quando |
| curtida | id | `BIGINT` | PK | sim | `AUTO_INCREMENT` | Identificador do voto |
| curtida | visitante | `CHAR(36)` | — | sim | `UNIQUE (visitante, projeto)` | Código do navegador; um voto por projeto |
| curtida | projeto | `VARCHAR(30)` | — | sim | `UNIQUE (visitante, projeto)` | `id` do projeto votado (ex.: pixelinha) |
| curtida | tipo | `ENUM('curtir','descurtir')` | — | sim | — | O voto |
| curtida | atualizada_em | `DATETIME` | — | sim | `DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` | Quando votou ou trocou o voto |
| mensagem | id | `INT` | PK | sim | `AUTO_INCREMENT` | Identificador da mensagem |
| mensagem | nome | `VARCHAR(80)` | — | sim | — | Quem mandou |
| mensagem | email | `VARCHAR(120)` | — | sim | — | Para responder |
| mensagem | assunto | `VARCHAR(120)` | — | não | — | Assunto da mensagem |
| mensagem | texto | `TEXT` | — | sim | — | A mensagem |
| mensagem | status | `ENUM('nova','lida','respondida')` | — | sim | `DEFAULT 'nova'` | Controle no painel |
| mensagem | criada_em | `DATETIME` | — | sim | `DEFAULT CURRENT_TIMESTAMP` | Quando chegou |

## O que cada tabela guarda

| Tabela | Descrição |
|---|---|
| visita | Cada lugar aberto no mundo 3D (contador de visitas). |
| curtida | Voto de cada visitante em cada projeto do portfólio. |
| mensagem | Mensagens do formulário de contato. |

## Valores aceitos em `lugar` e `projeto`

Esses valores são os `id` usados no `js/config.js` e no `js/zones.js`. A API recusa qualquer outro.

| Coluna | Valores |
|---|---|
| `visita.lugar` | `chegada`, `sobre`, `biblioteca`, `cinema`, `telefone`, `cartas`, `atelie` |
| `visita.projeto` e `curtida.projeto` | os `id` da lista `films` do `config.js` (hoje: `mundo`, `jc`, `pixelinha`, `preco`, `painel`) |
