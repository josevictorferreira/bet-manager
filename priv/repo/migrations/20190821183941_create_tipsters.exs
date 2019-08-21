defmodule BetManager.Repo.Migrations.CreateTipsters do
  use Ecto.Migration

  def change do
    create table(:tipsters) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:tipsters, [:name])
    create index(:tipsters, [:user_id])
  end
end
