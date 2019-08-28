defmodule BetManager.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :float, null: false
      add :type, :string, null: false, default: "deposit"
      add :date, :utc_datetime, null: false
      add :account_id, references(:accounts, on_delete: :nothing), null: false

      timestamps()
    end
  end
end
