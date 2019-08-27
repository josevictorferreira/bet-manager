defmodule BetManager.Repo.Migrations.AddDateToBets do
  use Ecto.Migration

  def change do
    alter table("bets") do
      add :event_date, :utc_datetime,
        default: DateTime.utc_now() |> DateTime.to_string(),
        null: false
    end
  end
end
