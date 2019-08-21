defmodule BetManager.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :description, :string
      add :odd, :float
      add :value, :float
      add :result, :string
      add :tipster_id, references(:tipsters, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:bets, [:tipster_id])
    create index(:bets, [:account_id])
    create index(:bets, [:user_id])
  end
end
