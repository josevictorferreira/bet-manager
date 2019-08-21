defmodule BetManager.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string, null: false
      add :balance, :float, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :bookmaker_id, references(:bookmakers, on_delete: :nothing), null: false
      add :currency_code, references(:currencies, on_delete: :nothing, type: :string, column: :code), null: false

      timestamps()
    end

    create index(:accounts, [:user_id])
    create index(:accounts, [:bookmaker_id])
    create index(:accounts, [:currency_code])
  end
end
