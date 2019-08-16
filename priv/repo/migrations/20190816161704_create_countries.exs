defmodule BetManager.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
    create table(:countries) do
      add :name, :string
      add :flag, :string

      timestamps()
    end

    create unique_index(:countries, [:name])
  end
end
