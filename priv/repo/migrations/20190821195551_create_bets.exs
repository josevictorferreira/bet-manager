defmodule BetManager.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :description, :string, null: false
      add :odd, :float, null: false
      add :value, :float, null: false
      add :result, :integer, null: true
      add :tipster_id, references(:tipsters, on_delete: :nothing), null: true
      add :account_id, references(:accounts, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :sport_id, references(:sports, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:bets, [:tipster_id])
    create index(:bets, [:account_id])
    create index(:bets, [:user_id])
    create index(:bets, [:sport_id])
  end
end
