defmodule Jrowah.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      JrowahWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:jrowah, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Jrowah.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Jrowah.Finch},
      # Start a worker by calling: Jrowah.Worker.start_link(arg)
      # {Jrowah.Worker, arg},
      # Start the presence tracker
      JrowahWeb.Presence,
      # Start to serve requests, typically the last entry
      JrowahWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jrowah.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl Application
  def config_change(changed, _new, removed) do
    JrowahWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
