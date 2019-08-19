defmodule BetManager.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :name, :string
      add :symbol, :string
      add :country_id, references(:countries, on_delete: :nothing)

      timestamps()
    end

    create index(:currencies, [:country_id])
  end
end
