defmodule BetManager.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries, primary_key: false) do
      add :code, :string, primary_key: true, null: false
      add :name, :string, null: false
      add :flag, :string, null: false
      add :region, :string, null: false

      timestamps()
    end

    create unique_index(:countries, [:code])
  end
end
