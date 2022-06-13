# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

$if(include_database.truthy)$
config :$name$,
  ecto_repos: [$name;format="word-space,Camel"$.Repo],
  generators: [binary_id: true]
$endif$

$if(include_database.truthy)$
config :$name$, $name;format="word-space,Camel"$.Repo
  migration_primary_key: [type: :uuid],
  migration_foreign_key: [type: :uuid],
  migration_timestamps: [type: :utc_datetime_usec]
$endif$

# Configures the endpoint
config :$name$, $name;format="word-space,Camel"$Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: $name;format="word-space,Camel"$Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: $name;format="word-space,Camel"$.PubSub,
  live_view: [signing_salt: "SHy07qz3"]

# Configures Elixir's Logger
config :logger_json, :backend, metadata: :all

config :logger,
  backends: [LoggerJSON],
  format: "\$time \$metadata[\$level] \$message\n",
  metadata: [:request_id, :trace_id, :span_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla,
  adapter: Tesla.Adapter.Mint,
  max_retries: 5,
  retry_delay: 2000

config :spandex_tesla,
  service: :"$name$-tesla",
  tracer: ShoreService.Tracer

config :spandex_ecto, SpandexEcto.EctoLogger,
  service: :"$name$-postgres",
  tracer: ShoreService.Tracer

config :spandex_phoenix, tracer: ShoreService.Tracer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
