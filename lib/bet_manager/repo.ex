defmodule BetManager.Repo do
  use Ecto.Repo,
    otp_app: :bet_manager,
    adapter: Ecto.Adapters.Postgres
end
