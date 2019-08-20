defmodule BetManager.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :string
      add :balance, :float
      add :user_id, references(:users, on_delete: :nothing)
      add :bookmaker_id, references(:bookmakers, on_delete: :nothing)
      add :currency_code, references(:currencies, on_delete: :nothing)

      timestamps()
    end

    create index(:accounts, [:user_id])
    create index(:accounts, [:bookmaker_id])
    create index(:accounts, [:currency_code])
  end
end
