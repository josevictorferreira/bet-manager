defmodule BetManager.Country do
  use Ecto.Schema
  import Ecto.Changeset

  schema "countries" do
    field :flag, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :flag])
    |> validate_required([:name, :flag])
    |> unique_constraint(:name)
  end
end
