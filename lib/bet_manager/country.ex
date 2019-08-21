defmodule BetManager.Country do
  use Ecto.Schema
  import Ecto.Changeset
  alias BetManager.Country
  alias BetManager.Repo
  alias BetManager.Currency

  @primary_key{:code, :string, autogenerate: false}
  schema "countries" do
    has_many :currencies, Currency, on_delete: :delete_all, foreign_key: :country_code
    field :flag, :string
    field :name, :string
    field :region, :string

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :flag, :code, :region])
    |> validate_required([:name, :flag, :code, :region])
    |> validate_length(:code, min: 2, max: 2)
    |> unique_constraint(:code)
  end

  def list_countries do
    Repo.all(Country)
  end

  def list_countries_formatted do
    list_countries()
    |> Enum.map(fn x -> %{code: x.code, name: x.name, flag: x.flag, region: x.region} end)
  end

  def get_country!(id), do: Repo.get!(Country, id)

  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  def delete_all do
    Repo.delete_all(Country)
  end
end
