# Normalização do banco do Mundo Swarttz (até a 3FN)

O modelo tem três tabelas: `visita`, `curtida` e `mensagem` (detalhe de cada coluna em `dicionario_dados.md`). Este documento confere cada uma contra as três formas normais e registra as mudanças feitas no caminho.

## As três formas normais, em uma linha cada
- **1FN:** cada célula guarda **um valor só** (nada de listas separadas por vírgula) e toda tabela tem chave primária.
- **2FN:** está na 1FN e, se a chave primária for **composta**, cada coluna depende da chave **inteira**, e não só de um pedaço dela.
- **3FN:** está na 2FN e nenhuma coluna depende de **outra coluna que não é chave** (a chamada dependência transitiva: A → B → C).

---

## Verificação da 1FN

| Tabela | Chave primária | Alguma coluna com lista de valores? |
|---|---|---|
| visita | `id` | Não. Cada visita tem um lugar, no máximo um projeto e um dispositivo. |
| curtida | `id` | Não. Cada voto tem um alvo e um tipo. |
| mensagem | `id` | Não. Cada mensagem tem um remetente, um e-mail e um texto. |

As três tabelas estão na 1FN.

## Verificação da 2FN

A 2FN só pode ser violada em tabelas com **chave primária composta**. As três tabelas usam um `id` simples como chave, então nenhuma coluna pode depender "só de um pedaço" dela. As três estão na 2FN.

A regra de um voto por visitante em cada alvo, em `curtida`, é garantida com `UNIQUE (visitante, alvo)`, e não com uma chave primária composta. Assim a tabela mantém o `id` simples, e a regra continua valendo.

## Verificação da 3FN

A pergunta é: alguma coluna depende de outra coluna que não é a chave?

- **visita:** `lugar`, `projeto`, `dispositivo` e `criada_em` descrevem aquela visita. O lugar não determina o projeto (no cinema pode ser qualquer filme), e o visitante não determina o dispositivo (a mesma pessoa pode voltar pelo celular). Nenhuma dependência transitiva.
- **curtida:** `alvo`, `tipo` e `atualizada_em` descrevem aquele voto. Nenhuma coluna é calculada a partir de outra.
- **mensagem:** `nome`, `email`, `assunto`, `texto` e `status` descrevem aquela mensagem. Pode parecer que `email → nome` (o e-mail "decide" o nome), mas o formulário é aberto: a mesma pessoa pode escrever o nome de jeitos diferentes, ou duas pessoas podem usar o mesmo e-mail. Não há um cadastro de remetentes, e cada mensagem guarda o que foi enviado naquela vez.

As três tabelas estão na 3FN.

---

## Mudanças feitas no caminho

### Problema: coluna calculada nas curtidas (violava a 3FN)

Num modelo anterior, a tabela `curtida` usava `projeto_id` vazio para o voto no site todo, e precisava de uma coluna `alvo` calculada a partir dele (`projeto_id` ou 0), só para conseguir impedir votos repetidos.

**Antes:** `curtida`

| id | visitante | projeto_id | alvo | tipo |
|---|---|---|---|---|
| 1 | a1b2c3 | *(vazio)* | 0 | curtir |
| 2 | a1b2c3 | 2 | 2 | curtir |

**Por que era um problema:** `alvo` dependia de `projeto_id`, que não é chave (`id → projeto_id → alvo`): uma dependência transitiva. Era um dado repetido que podia ficar diferente do original.

**Depois:** sobrou só a coluna `alvo`, que é obrigatória e guarda diretamente o que foi votado: o `id` do projeto ou a palavra `site`. Não existe mais coluna calculada, e o `UNIQUE (visitante, alvo)` funciona sem truques.

**Depois:** `curtida`

| id | visitante | alvo | tipo |
|---|---|---|---|
| 1 | a1b2c3 | site | curtir |
| 2 | a1b2c3 | pixelinha | curtir |

### Simplificação: o conteúdo saiu do banco

O modelo anterior também tinha tabelas para o conteúdo do site (projetos, tecnologias, formações, depoimentos e autores) e para os usuários do painel. Elas foram retiradas porque o conteúdo continua no `js/config.js` e o painel tem uma única administradora. O motivo completo está na seção "Decisões tomadas" de [`docs/BANCO-DE-DADOS.md`](../docs/BANCO-DE-DADOS.md).

## Resumo

| Tabela | 1FN | 2FN | 3FN |
|---|---|---|---|
| visita | ✓ | ✓ | ✓ |
| curtida | ✓ | ✓ | ✓ |
| mensagem | ✓ | ✓ | ✓ |
