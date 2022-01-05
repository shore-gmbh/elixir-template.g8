import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :"$name$", $name;format="word-space,Camel"$.Repo,
  username: "postgres",
  password: "postgres",
  database: "$name$_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :"$name$", $name;format="word-space,Camel"$Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "i2s4QVZIYuDraO/P402ZDvBaIebkUeV/cOPdWz6KoAGfI8IFTsHbkiUxbIlo7F0a",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :"$name$",
       :rabbitmq_url,
       System.get_env("RABBITMQ_URL") || "amqp://guest:guest@localhost:5672"

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
