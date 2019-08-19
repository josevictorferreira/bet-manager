defmodule BetManager.Currency do
  use Ecto.Schema
  import Ecto.Changeset

  schema "currencies" do
    field :name, :string
    field :symbol, :string
    field :country_id, :id

    timestamps()
  end

  @doc false
  def changeset(currency, attrs) do
    currency
    |> cast(attrs, [:name, :symbol])
    |> validate_required([:name, :symbol])
  end
end
