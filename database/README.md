# Banco de dados MySQL

Banco **`mundo_swarttz`**, com três tabelas normalizadas até a 3FN. Ele guarda só o que vem de quem visita o site: as visitas, as curtidas e as mensagens do formulário de contato. O conteúdo do site continua no `js/config.js`. O detalhe de cada coluna está em `dicionario_dados.md`.

## Arquivos
| Arquivo | O que é |
|---|---|
| `visao_geral.md` | Visão geral do modelo: entidades, relacionamentos e perfis |
| `modelo_logico.png` | Modelo lógico: as três tabelas, com tipos, chaves e campos obrigatórios |
| `normalizacao.md` | Verificação da 1FN, 2FN e 3FN e as mudanças feitas no caminho |
| `dicionario_dados.md` | Dicionário de dados: cada coluna com tipo e regras |
| `criar_banco.sql` | Cria o banco e as 3 tabelas (tipos, PK com `AUTO_INCREMENT`, `NOT NULL`, `UNIQUE` e `DEFAULT`) |
| `teste_integridade.sql` | Confere se o banco recusa um segundo voto do mesmo visitante no mesmo projeto |
| `schema.sql` | Estrutura do banco exportada com `mysqldump`, sem dados |

## Como criar o banco localmente (XAMPP)
1. No painel do XAMPP, inicie o **Apache** e o **MySQL**.
2. Abra `localhost/phpmyadmin`, vá na aba **Importar**, escolha `criar_banco.sql` e clique em **Importar**.
3. O banco `mundo_swarttz` aparece na lateral, com 3 tabelas: `curtida`, `mensagem` e `visita`.

O banco usa `utf8mb4_unicode_ci` para aceitar acentos e emojis nas mensagens. Todas as tabelas usam `ENGINE=InnoDB`, o motor padrão do MySQL, que garante as regras de `UNIQUE` e as transações.

## Tabelas
| Tabela | O que guarda |
|---|---|
| `visita` | Cada lugar aberto no mundo 3D, e qual projeto no cinema (contador de visitas) |
| `curtida` | O voto de cada visitante em cada projeto ou no site todo |
| `mensagem` | As mensagens do formulário de contato |

As tabelas são independentes, sem chaves estrangeiras. Os projetos são identificados pelo `id` que têm no `js/config.js` (ex.: `pixelinha`), e a API confere esse `id` antes de gravar.

## Teste de integridade: um voto por alvo
A regra `UNIQUE (visitante, alvo)` da tabela `curtida` garante que o mesmo navegador não vote duas vezes no mesmo projeto. `teste_integridade.sql` faz três coisas:

1. Grava uma curtida no projeto `pixelinha`. **O MySQL aceita.**
2. Troca o voto para descurtida com `INSERT ... ON DUPLICATE KEY UPDATE`, que é o jeito que a API grava os votos. A tabela continua com **uma linha só**.
3. Tenta gravar um **segundo** voto do mesmo visitante no mesmo projeto:

```sql
INSERT INTO curtida (visitante, alvo, tipo)
VALUES ('a1b2c3d4-0000-4000-8000-000000000001', 'pixelinha', 'curtir');
```

**Resultado esperado: o MySQL recusa.** O erro abaixo é o sinal de que a regra está funcionando:

```
#1062 - Duplicate entry 'a1b2c3d4-0000-4000-8000-000000000001-pixelinha'
for key 'uq_curtida_visitante_alvo'
```

O erro quer dizer: já existe uma linha com esse mesmo par (visitante, alvo). Assim o banco nunca guarda dois votos da mesma pessoa no mesmo projeto, e a contagem de curtidas não pode ser inflada.

Se esse `INSERT` for **aceito**, há um problema: o `UNIQUE` não foi criado.
