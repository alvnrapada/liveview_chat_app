# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :live_chat_app,
  ecto_repos: [LiveChatApp.Repo]

# Configures the endpoint
config :live_chat_app, LiveChatAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ykWMP2SAXWr90IUX2RXW+GDo9bT4+6g9bLYE1UcSl4OO1d9ofx1CoGCMzyHkc6XE",
  render_errors: [view: LiveChatAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveChatApp.PubSub,
  live_view: [signing_salt: "jE0cfQYiPO2L/I8OnPlowa4KycjhWpQZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :live_chat_app, :pow,
  user: LiveChatApp.Users.User,
  repo: LiveChatApp.Repo,
  web_module: LiveChatAppWeb

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
