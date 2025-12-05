defmodule LiveAsync.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveAsyncWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:live_async, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveAsync.PubSub},
      # Start a worker by calling: LiveAsync.Worker.start_link(arg)
      # {LiveAsync.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveAsyncWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveAsync.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveAsyncWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
