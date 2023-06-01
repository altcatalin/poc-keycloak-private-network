# poc-keycloak-private-network

How to use [Keycloak backend endpoint](https://www.keycloak.org/server/hostname) through a private network.

## Requirements

The only requirement is to have [Docker](https://www.docker.com/products/docker-desktop/) installed.

## Usage

Start containers and wait until `oauth2-proxy` service is healty (~60s). Open [http://localhost:4180](http://localhost:4180) in browser, use `admin` for username and password to sign in.

```shell
docker compose up
```

Stop containers and remove containers, networks, volumes.

```shell
docker compose down -v --remove-orphans
```

Check `oauth2-proxy` service from [docker-compose.yml](docker-compose.yml#L37) for OIDC client configuration.
