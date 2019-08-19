defmodule BetManager.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :code, :string, null: false
      add :name, :string, null: false
      add :name_plural, :string, null: false
      add :decimal_digits, :integer, null: false
      add :rounding, :integer, null: false
      add :symbol, :string, null: false
      add :country_code, references(:countries, on_delete: :nothing, type: :string, column: :code), null: false

      timestamps()
    end

    create index(:currencies, [:code])
  end
end
