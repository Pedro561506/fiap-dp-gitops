# Fase 2 — Code Review de Segurança

## Identificação
Projeto: FIAP — Infrastructure as Code (GitOps)
Revisor: Pedro de Carvalho Gonçalves
Commit analisado: 27bb4a2
Classificação: Alterações necessárias

## Achado 1 — Credencial exposta no código

Severidade: ALTA

Arquivo: main.tf
Recurso: docker_container.database

Foi identificada uma senha do PostgreSQL armazenada
diretamente no código Terraform, por meio da variável
de ambiente POSTGRES_PASSWORD.

Risco:
A credencial pode ser visualizada por qualquer pessoa
com acesso ao repositório e permanece no histórico Git.

Recomendação:
Utilizar uma variável Terraform sensível, alimentada
por um arquivo .tfvars excluído do versionamento.

## Achado 2 — Exposição indevida do banco

Severidade: ALTA

Arquivo: main.tf
Recurso: docker_container.database

A porta 5432 do PostgreSQL está publicada na porta
5433 do host, utilizando o endereço 0.0.0.0.

Risco:
O banco pode ficar acessível por interfaces externas
do host, ampliando a superfície de ataque.

Recomendação:
Remover a publicação da porta do banco e configurar
uma rede Docker interna, permitindo a comunicação
somente com o contêiner web.

## Parecer final

Solicito alterações antes da aprovação da infraestrutura.

A configuração inicial apresenta exposição de segredo
e publicação desnecessária do serviço de banco de dados.

As correções devem ser realizadas em um novo commit,
preservando o histórico da versão insegura.
