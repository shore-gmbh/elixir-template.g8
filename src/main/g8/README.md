# $name;format="word-space,Camel"$

Some description

## Prerequisites

### Environment

- Erlang v24.1.1
- Elixir v1.12.3

You can use [asdf](https://asdf-vm.com/) to install these dependencies in your environment.

### Installing and running locally

```shell
# clone this repository
git clone git@github.com:shore-gmbh/$name$.git

# install hex + rebar
mix local.hex --force
mix local.rebar --force

# authenticate your terminal to be able to download our library.
# you need to ask someone for the "HEXPM_API_KEY" and replace it
# in this command below
mix hex.organization auth shore_gmbh --key \$HEXPM_API_KEY

# install dependencies
mix deps.get

# create and migrate your database
mix ecto.setup

# start Phoenix endpoint
mix phx.server

# or inside IEx
iex -S mix phx.server

# then chech the health check endpoint
http://localhost:4000/health
```

## Installing and running with docker

```shell
# clone this repository
git clone git@github.com:shore-gmbh/$name$.git

# run the docker-compose
docker-compose -f docker/docker-compose.yml up -d

# watch the docker-compose logs
docker-compose -f docker/docker-compose.yml logs -f

# then chech the health check endpoint
http://localhost:4000/health
```

## Built With

[**Elixir**](https://elixir-lang.org/) - Elixir is a dynamic, functional language for building scalable and maintainable applications.

[**Phoenix Framework**](https://hexdocs.pm/phoenix/overview.html) - Phoenix is a web development framework written in Elixir which implements the server-side Model View Controller (MVC) pattern.
