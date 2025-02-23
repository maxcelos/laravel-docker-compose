## Requirements

- Docker
- [mkcert](https://github.com/FiloSottile/mkcert)

## How to set up locally

Clone this repository

```shell
git clone https://github.com/maxcelos/laravel-docker-compose.git

cd laravel-docker-compose
```

Open it in your IDE, search for `lscore` in all files and replace it with the name of your app, for example `myapp`.

Copy all content of this repository in the root of your Laravel project

Now in the root folder of your project, follow the steps below:

Copy .env

```shell
cp .env.example .env
```

Generate SSL certificates

> Replace `lscore` in the command below with the name of your app, for example `myapp`.

```shell
mkcert -cert-file docker/nginx/ssl/app-cert.pem -key-file docker/nginx/ssl/app-key.pem "*.lscore.localhost" "lscore.localhost"
```

Build docker images

```shell
docker compose build
```

Start containers

```shell
docker compose up -d
```

Install PHP dependencies

```shell
make composer install
```

Install Node dependencies

```shell
make pnpm install
```

Generate key

```shell
make artisan key:generate
```

Run database migration

```shell
make migrate
```

Update your `vite.config.js`, adding the section below in your `defineConfig`:

> Replace `lscore` with your app name, for example `myapp`.

```js
server: {
  host: "0.0.0.0",
    port: 5173,
    cors: true,
    strictPort: true,
    https: {
    key: fs.readFileSync(path.resolve(__dirname, 'docker/nginx/ssl/app-key.pem')),
      cert: fs.readFileSync(path.resolve(__dirname, 'docker/nginx/ssl/app-cert.pem')),
  },
  hmr: {
    host: "lscore.localhost",
  },
},
```

Start the application

```shell
make start
```

> This will run `composer dev` command inside the container

Done.

The app should be available in https://myapp.localhost

> If containers are up you can always access the app.
> The `start` command will run the hot-reload and queues.

### PgAdmin Setup (optional)

The docker compose includes and instance of Web PgAdmin. Use the credentials below to
easily access database.

URL: http://localhost:8081
Username: user@localhost.com
Password: password

In the first access, you need to set up the connection. Follow the steps below

Right click in "Servers" > "Register"

In the "General" tab, set a name (any) for your server.

In the "Connection" tab, set the hostname as "postgres", and database, username and password will be
the values from your .env. If you use the .env.example, it will be "myapp" for all.

## Sonarqube

O SonarQube é uma plataforma de código aberto para análise contínua da qualidade do código. Ele permite identificar bugs, vulnerabilidades, code smells e problemas de segurança, ajudando equipes de desenvolvimento a manterem um código limpo, seguro e sustentável.

### Login

Entre com as credenciais abaixo e será solicitado uma nova senha:

- Usuário: `admin`
- Senha: `admin`

Após o login, gere um Token do tipo Global para poder utilizar no scan das aplicações.

1. Acesse o menu superior direito, no ícone do usuário Admin.
1. Clique em My Account e em seguida na aba Security.
1. Em Generate Tokens, dê um nome ao token ex: `CICD`, escolha tipo Global e sua expiração.
1. Copie o token gerado e cole no arquivo `./docker/scripts/sonarscan.sh` na linha 4.

### Scanear código

Configure a execução dos testes para que gere o arquivo de coverage, o comando `make sonarqube` faz o fluxo para execução do testes e do scan do código.

Para que os testes consiga gerar o coverage, é necessário a instalação do pacote `pcov` no container docker.

O scan irá enviar ao sonarqube o arquivo de coverage gerado para que possa visualizar a cobertura corretamente do código.
