defmodule BetManager.Repo.Migrations.CreateBookmakers do
  use Ecto.Migration

  def change do
    create table(:bookmakers) do
      add :name, :string
      add :logo, :string

      timestamps()
    end

    create unique_index(:bookmakers, [:name])
  end
end
