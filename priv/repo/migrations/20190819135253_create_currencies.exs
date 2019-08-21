defmodule BetManager.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies, primary_key: false) do
      add :code, :string, primary_key: true, null: false
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
