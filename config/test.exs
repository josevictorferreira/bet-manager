use Mix.Config

# Configure your database
config :bet_manager, BetManager.Repo,
  username: "postgres",
  password: "postgres",
  database: "bet_manager_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bet_manager, BetManagerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :bet_manager, BetManager.Repo,
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PASSWORD") || "postgres",
  database: System.get_env("DB_DATABASE_TEST") || "bet_manager_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool_size: (System.get_env("DB_POOL") |> String.to_integer) || 10
