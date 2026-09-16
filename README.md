# MANEJA API

![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-D30001?style=for-the-badge&logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/Postgres-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2671E5?style=for-the-badge&logo=githubactions&logoColor=white)

Backend/API do aplicativo MANEJA, desenvolvido com Ruby on Rails e PostgreSQL.

### Requisitos

![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)
![Docker Compose](https://img.shields.io/badge/Docker_Compose-2496ED?style=flat&logo=docker&logoColor=white)

### Configuração

#### 1. Clone o repositório

```bash
git clone https://github.com/Leafth/maneja-api.git
cd maneja-api
```

#### 2. Configure as variáveis de ambiente

```bash
cp .env.example .env
```

#### 3. Construa as imagens

```bash
docker compose build
```

#### 4. Prepare o banco de dados:

```bash
docker compose run --rm api bin/rails db:prepare
```

#### 5. Suba os serviços:

```bash
docker compose up
```

A API ficará disponível em:

```text
http://localhost:3000
```

Health check:

```text
http://localhost:3000/up
```

### Testes

Execute a suíte de testes:

```bash
docker compose run --rm api bundle exec rspec
```

### Validação completa

Execute todas as validações do projeto:

```bash
docker compose run --rm api bin/ci
```

O comando executa:

- RSpec
- RuboCop
- Brakeman
- Bundler Audit

### Comandos úteis

#### Console Rails

```bash
docker compose run --rm api bin/rails console
```

#### Executar migrations

```bash
docker compose run --rm api bin/rails db:migrate
```

#### Verificar status dos serviços

```bash
docker compose ps
```

#### Visualizar logs

```bash
docker compose logs -f api
```

#### Parar os serviços

```bash
docker compose down
```

#### Parar e remover volumes

```bash
docker compose down -v
```
