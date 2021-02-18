defmodule LiveChatApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LiveChatApp.Repo,
      # Start the Telemetry supervisor
      LiveChatAppWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveChatApp.PubSub},
      # Start the Endpoint (http/https)
      LiveChatAppWeb.Endpoint
      # Start a worker by calling: LiveChatApp.Worker.start_link(arg)
      # {LiveChatApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveChatApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LiveChatAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
