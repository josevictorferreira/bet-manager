defmodule BetManager.Country do
  use Ecto.Schema
  import Ecto.Changeset
  alias BetManager.Country
  alias BetManager.Repo

  schema "countries" do
    field :flag, :string
    field :name, :string
    field :code, :string
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
    |> Enum.map(fn x -> %{"id" => x.id, "name" => x.name, "flag" => x.flag} end)
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
