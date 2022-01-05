defmodule $name;format="word-space,Camel"$.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Logger.add_backend(Sentry.LoggerBackend)

    ShoreService.Telemetry.install(:"$name$")

    children = [
      # Start the Ecto repository
      $name;format="word-space,Camel"$.Repo,
      # Start the Telemetry supervisor
      $name;format="word-space,Camel"$Web.Telemetry,
      # Start the Endpoint (http/https)
      $name;format="word-space,Camel"$Web.Endpoint,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: $name;format="word-space,Camel"$.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    $name;format="word-space,Camel"$Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
