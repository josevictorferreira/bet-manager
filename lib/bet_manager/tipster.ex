defmodule BetManager.Tipster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tipsters" do
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(tipster, attrs) do
    tipster
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
