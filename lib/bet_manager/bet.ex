defmodule BetManager.Bet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bets" do
    field :description, :string
    field :odd, :float
    field :result, :string
    field :value, :float
    field :tipster_id, :id
    field :account_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [:description, :odd, :value, :result])
    |> validate_required([:description, :odd, :value, :result])
  end
end
