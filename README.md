# 🍔 euComida - Backend

**euComida** é um aplicativo de delivery de comida que nasce com a proposta de ser um concorrente direto ao iFood. Este repositório contém a implementação do backend utilizando Java com Spring Boot.

---

## 🧰 Tecnologias e Frameworks Utilizados

- **Linguagem:** Java 21
- **Framework Principal:** Spring Boot 3.5.0
- **Frameworks auxiliares:**
  - Spring Web
  - Spring Data JPA
  - Spring Security
  - Spring Authorization Server
  - Spring Validation
  - Springdoc OpenAPI (Swagger UI)
  - Flyway
- **Persistência:** MySQL (provisionado com Docker)
- **Autenticação e Autorização:** OAuth2 com JWT
- **Gerenciamento de dependências:** Maven
- **Ambiente de containerização:** Docker + Docker Compose

---

## 🛠️ Estrutura do Banco de Dados

A aplicação utiliza **MySQL** como banco de dados relacional. A modelagem inicial inclui as seguintes entidades:

- `User`: representa os usuários e entregadores do sistema  
- `Role` e `Permission`: controle de acesso baseado em papéis e permissões  
- `Order`: representa os pedidos realizados no sistema  

A **evolução do banco de dados** é gerenciada utilizando o **Flyway**, uma ferramenta moderna de versionamento de migrations SQL.

### 📁 Migrations com Flyway

O Flyway detecta **automaticamente** todos os scripts `.sql` localizados na pasta:

```
src/main/resources/db/migration
```

Os arquivos devem seguir a convenção de nomenclatura:

```
V<versão>__<descrição>.sql
```

> Exemplo de script válido:
>  
> `V001__create-order-table.sql`

Esse script será executado automaticamente ao iniciar a aplicação. O Flyway mantém um histórico das migrations já aplicadas, garantindo controle e integridade do schema do banco de dados em todos os ambientes.

### 📦 Massa de dados para ambiente de desenvolvimento

Quando a aplicação é executada com o profile `dev`, uma massa de dados **para testes** é automaticamente carregada logo após a execução das migrations. Esses dados estão definidos no arquivo:

```
src/main/resources/db/testdata/afterMigrate.sql
```

Este script insere uma **massa de dados inicial para testes**, incluindo:

- Usuário `joao`, com senha `123`, do tipo USER, com a permissão `CREATE_ORDER`
- Usuária `maria`, com senha `123`, do tipo DELIVERY_MAN, com as permissões `CREATE_ORDER` e `CONSULT_ORDER_STATUS`
- Cliente `frontend-web`, necessário para o fluxo de autenticação **Authorization Code com PKCE** a ser utilizado pela aplicação frontend.

Esse script é ideal para facilitar testes locais e simulações de uso da aplicação em ambiente de desenvolvimento. Ele **não deve ser executado** em ambientes como staging ou produção.

> 🔄 A execução com profile `dev` via Docker é explicada mais adiante neste documento, na seção **Execução com Docker Compose**.

---

## 🔐 Estratégia de Autenticação e Autorização

A autenticação e autorização são realizadas com **OAuth2** utilizando **JWT** como token de acesso.

Como as APIs REST serão consumidas por um frontend web (SPA) e por um aplicativo mobile, foi adotado o fluxo de **Authorization Code com PKCE**, por ser o mais seguro e recomendado para SPAs.

Endpoints protegidos exigem um token válido no cabeçalho `Authorization: Bearer <token>`.

### 👤 Usuários de Teste

Dois usuários são automaticamente cadastrados na base de dados ao subir a aplicação com o Flyway:

| Usuário | Senha | Tipo de usuário | Permissões atribuídas |
|--------|--------|------------------|------------------------|
| `joao` | `123`  | USER             | `CREATE_ORDER`         |
| `maria`| `123`  | DELIVERY_MAN     | `CREATE_ORDER`, `CONSULT_ORDER_STATUS` |

**Resumo:**

- `joao` poderá **apenas criar pedidos**.
- `maria` poderá **criar e consultar pedidos**.

### Passo a passo para obter um token válido:

1. **Gerar o code verifier e o code challenge no terminal:**

```bash
CODE_VERIFIER=$(openssl rand -base64 32 | tr -d '=+/' | cut -c1-43)
echo $CODE_VERIFIER

CODE_CHALLENGE=$(echo -n "$CODE_VERIFIER" | openssl dgst -sha256 -binary | openssl base64 | tr -d '=' | tr '/+' '_-')
echo $CODE_CHALLENGE
```
Os valores impressos serão usados nas próximas etapas.

2. **Iniciar o fluxo de autorização:**

Acesse a URL (substituindo <code_challenge> pelo valor gerado):

```bash
http://localhost:8080/oauth2/authorize?response_type=code&client_id=frontend-web&redirect_uri=http://localhost:4200/callback&scope=profile%20email&code_challenge=<code_challenge>&code_challenge_method=S256
```

3. **Login no Spring Security:**

Você será redirecionado para:

```bash
http://localhost:8080/login
```

Preencha com usuário e senha previamente cadastrados, por exemplo:

- usuário: joao
- senha: 123

4. **Receber o código de autorização:**

Após login, você será redirecionado para:

```bash
http://localhost:4200/callback?code=<authorization_code>
```

5. **Trocar o código pelo token de acesso:**

Execute a requisição abaixo, substituindo <authorization_code> e <code_verifier> pelos valores gerados anteriormente:

```bash
curl --request POST \
  --url http://localhost:8080/oauth2/token \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data grant_type=authorization_code \
  --data client_id=frontend-web \
  --data redirect_uri=http://localhost:4200/callback \
  --data code=<authorization_code> \
  --data code_verifier=<code_verifier>
```

6. **Uso do token:**

Use o token JWT retornado para acessar os endpoints protegidos da API, informando-o no cabeçalho:

```bash
Authorization: Bearer <token>
```

---

## 📈 Estratégia de Escalabilidade e Segurança

- **Escalabilidade Horizontal:** aplicação preparada para rodar em múltiplas instâncias (stateless), ideal para ambientes em nuvem.
- **Segurança:**
  - Tokens JWT assinado com chave privada RSA
  - Spring Security com validações e restrições por escopo/permissão
  - Validação de entrada com `@Valid` e mensagens padronizadas
  - Tratamento global de exceções

---

## 🚀 MVP Inicial

O MVP entregue nesta primeira fase do projeto contém as seguintes funcionalidades:

### 1. Criação de pedidos

```http
curl --request POST \
  --url http://localhost:8080/api/v1/orders \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer <token>' \
  --data '{
    "productId": 1,
    "quantity": 2,
    "address": "Rua Exemplo, 123"
  }'
```

### 2. Consulta de status do pedido

```http
curl --request GET \
  --url http://localhost:8080/api/v1/orders/1/status \
  --header 'Authorization: Bearer <token>'
```

### 3. Autenticação

- Login via fluxo Authorization Code com PKCE
- Emissão e validação de tokens JWT
- Controle de acesso por permissões (`@PreAuthorize`)

---

## 📄 Documentação da API (OpenAPI)

A documentação da API está disponível via Swagger UI:

```
http://localhost:8080/swagger-ui.html
```

---

## ⚠️ Tratamento Global de Erros

Todas as exceções são tratadas por um handler global que retorna:

- Mensagem amigável
- Detalhes técnicos (para devs)
- Código de status HTTP adequado

---

## 🐳 Execução com Docker Compose

Para executar a aplicação e o banco de dados com um único comando:

### Pré-requisitos

- Docker
- Docker Compose

### Passos

1. Acesse a raiz do projeto.
2. Execute:

```bash
SPRING_PROFILES_ACTIVE=dev docker compose -f docker/docker-compose.yaml up -d --build
```

3. A aplicação estará disponível em: `http://localhost:8080`

Para parar os containers:

```bash
docker compose -f docker/docker-compose.yaml down
```

---

## 🧭 Próximos Passos

### Backend

- Implementar filtros de pedidos por status e data
- Implementar histórico de pedidos por usuário
- Criar sistema de avaliação e comentários
- Integração com sistemas de pagamento

### Frontend (Web)

- Tela de login com suporte a PKCE
- Listagem e criação de pedidos
- Tela de status do pedido em tempo real
- Design responsivo

### Mobile

- Tela de login com PKCE
- Visualização de pedidos ativos
- Notificações push (Firebase)
- Roteirização para entregadores

---

## ✅ Tarefas Sugeridas

- [ ] Criar endpoint de atualização de status de pedido
- [ ] Adicionar suporte a refresh token
- [ ] Adicionar testes de integração para autenticação
- [ ] Configurar pipeline CI/CD (GitHub Actions/GitLab CI)
- [ ] Configurar ambientes de staging/produção na nuvem (Kubernetes, AWS, Azure ou GCP)

---

## 👨‍💻 Contato

Em caso de dúvidas, entre em contato com o Tech Lead do projeto.