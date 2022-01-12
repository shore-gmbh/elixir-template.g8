import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :$name$, :rabbitmq_url, System.fetch_env!("RABBITMQ_URL")

  config :$name$, $name;format="word-space,Camel"$.Repo,
    # ssl: true,
    # socket_options: [:inet6],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :$name$, $name;format="word-space,Camel"$Web.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    server: true,
    secret_key_base: secret_key_base

  config :shore_service,
    shore_token_secret: System.fetch_env!("SHORE_TOKEN_SECRET"),
    shore_api_base_uri: System.fetch_env!("SHORE_API_BASE_URI")
end

config :sentry,
  dsn: System.get_env("SENTRY_URL"),
  included_environments: ~w(prod staging),
  environment_name: System.get_env("APP_ENVIRONMENT") || "development"

config :shore_service, ShoreService.Tracer,
  adapter: SpandexDatadog.Adapter,
  service: :"$name$-phoenix",
  disabled?: false,
  env: System.get_env("APP_ENVIRONMENT", "development")

config :shore_service, :spandex_datadog,
  host: System.get_env("DOGSTATSD_HOST_IP") || "localhost",
  port: System.get_env("DD_APM_RECEIVER_PORT") || 8126,
  batch_size: System.get_env("SPANDEX_BATCH_SIZE") || 2,
  sync_threshold: System.get_env("SPANDEX_BATCH_SIZE") || 100,
  http: HTTPoison
