# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bet_manager,
  ecto_repos: [BetManager.Repo]

# Configures the endpoint
config :bet_manager, BetManagerWeb.Endpoint,
  url: [host: "0.0.0.0"],
  secret_key_base: "gAJNKWkTOZXmCZXZ1z0ihB9MJTZ/Tz17kgxypY2aUcogLGlp5quw6xYvlW6papCG",
  render_errors: [view: BetManagerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BetManager.PubSub, adapter: Phoenix.PubSub.PG2]

config :bet_manager, BetManager.Endpoint,
  http: [port: System.get_env("PORT") || 4000]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
