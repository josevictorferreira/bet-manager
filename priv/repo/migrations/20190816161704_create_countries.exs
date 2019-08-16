defmodule BetManager.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :code, :string, null: false
      add :name, :string, null: false
      add :flag, :string, null: false
      add :region, :string, null: false

      timestamps()
    end

    create unique_index(:countries, [:code])
  end
end
