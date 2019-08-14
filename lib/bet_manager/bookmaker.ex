defmodule BetManager.Bookmaker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookmakers" do
    field :logo, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(bookmaker, attrs) do
    bookmaker
    |> cast(attrs, [:name, :logo])
    |> validate_required([:name, :logo])
    |> unique_constraint(:name)
  end
end
