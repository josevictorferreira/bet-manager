defmodule BetManager.Sport do
  use Ecto.Schema
  import Ecto.Changeset
  alias BetManager.Sport
  alias BetManager.Repo

  schema "sports" do
    field :name, :string

    timestamps()
  end

  def changeset(sport, attrs) do
    sport
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def list_sports do
    Repo.all(Sport)
  end

  def list_sports_formatted do
    list_sports()
    |> Enum.map(fn x ->
      %{
        id: x.id,
        name: x.name
      }
    end)
  end

  def get_sport!(id) do
    Repo.get!(Sport, id)
  end

  def create_sport(attrs \\ %{}) do
    %Sport{}
    |> Sport.changeset(attrs)
    |> Repo.insert()
  end

  def update_sport(%Sport{} = sport, attrs) do
    sport
    |> Sport.changeset(attrs)
    |> Repo.update()
  end

  def delete_sport(%Sport{} = sport) do
    Repo.delete(sport)
  end

  def delete_all do
    Repo.delete_all(Sport)
  end
end
