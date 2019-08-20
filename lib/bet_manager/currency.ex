defmodule BetManager.Currency do
  use Ecto.Schema
  import Ecto.Changeset
  alias BetManager.Currency
  alias BetManager.Country
  alias BetManager.Repo

  schema "currencies" do
    belongs_to :country, Country, foreign_key: :country_code, references: :code, type: :string
    field :name, :string
    field :code, :string
    field :symbol, :string
    field :name_plural, :string
    field :decimal_digits, :integer
    field :rounding, :integer

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :symbol, :code, :name_plural, :decimal_digits, :rounding, :country_code])
    |> validate_required([:name, :symbol, :code, :name_plural, :decimal_digits, :rounding, :country_code])
    |> unique_constraint(:code)
  end

  def list_currencies do
    Repo.all(Currency)
    |> Repo.preload(:country)
  end

  def list_currencies_formatted do
    list_currencies()
    |> IO.inspect()
    |> Enum.map(fn x ->
      %{code: x.code,
        name: x.name,
        name_plural: x.name_plural,
        decimal_digits: x.decimal_digits,
        rounding: x.rounding,
        symbol: x.symbol,
        country: %{code: x.country.code,
                 name: x.country.name,
                 flag: x.country.flag,
                 region: x.country.region}} end)
  end

  def get_currency!(id), do: Repo.get!(Currency, id)

  def create_currency(attrs \\ %{}) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end

  def update_currency(%Currency{} = currency, attrs) do
    currency
    |> Currency.changeset(attrs)
    |> Repo.update()
  end

  def delete_currency(%Currency{} = currency) do
    Repo.delete(currency)
  end

  def delete_all do
    Repo.delete_all(Currency)
  end
end
