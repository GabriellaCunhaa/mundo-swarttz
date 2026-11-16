# Modelo de dados do Mundo Swarttz

## O projeto
O Mundo Swarttz é o portfólio tech interativo de Gabriella Swarttz, com um mundo 3D e uma versão simples em texto.
O visitante conhece os projetos, as formações e os depoimentos, e pode curtir os projetos e mandar mensagens.
O conteúdo do site fica no `js/config.js`. O banco MySQL guarda só o que vem de quem visita: as visitas, as curtidas e as mensagens. Um painel admin, de uso só da Gabriella, mostra esses dados.

Os arquivos desta pasta (dicionário de dados e scripts SQL) estão listados no [`README.md`](README.md). O detalhe de cada coluna está em [`dicionario_dados.md`](dicionario_dados.md), e o plano completo do banco em [`docs/BANCO-DE-DADOS.md`](../docs/BANCO-DE-DADOS.md).

## Entidades
| Entidade | O que guarda |
|---|---|
| **visita** | Cada lugar aberto no mundo 3D (e qual projeto, no cinema), para o contador de visitas |
| **curtida** | As curtidas e descurtidas de cada projeto e do site todo |
| **mensagem** | As mensagens do formulário de contato |

## Relacionamentos
As três tabelas são independentes: nenhuma tem chave estrangeira.

Os projetos e os lugares do mundo 3D não estão no banco. Eles são identificados pelo mesmo `id` curto que têm no `js/config.js` (ex.: `pixelinha` para o projeto, `cinema` para o lugar). A API confere se esse `id` existe antes de gravar uma visita ou uma curtida.

Por que o conteúdo não está no banco: veja a seção "Decisões tomadas" de [`docs/BANCO-DE-DADOS.md`](../docs/BANCO-DE-DADOS.md).

## Perfis de usuário
| Perfil | O que vê e faz | O que é restrito |
|---|---|---|
| **admin** (Gabriella) | Vê o contador de visitas, as curtidas e descurtidas e as mensagens com e-mail. Marca mensagens como lidas ou respondidas | Nada no sistema |
| **visitante** (público, sem login) | Vê todo o conteúdo do site e o número de curtidas. Envia mensagens e curte ou descurte | Painel, mensagens, descurtidas e contador de visitas |
