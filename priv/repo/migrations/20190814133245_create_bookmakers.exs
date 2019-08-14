defmodule BetManager.Repo.Migrations.CreateBookmakers do
  use Ecto.Migration

  def change do
    create table(:bookmakers) do
      add :name, :string, null: false
      add :logo, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: true

      timestamps()
    end

    create unique_index(:bookmakers, [:name])
  end
end
