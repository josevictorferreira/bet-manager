defmodule BetManager.Tipster do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias BetManager.Tipster
  alias BetManager.User
  alias BetManager.Repo

  schema "tipsters" do
    belongs_to :user, User
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(tipster, attrs) do
    tipster
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name)
  end

  def list_tipsters do
    Repo.all(Tipster)
    |> Repo.preload([:user])
  end

  def get_tipster!(id) do
    Repo.get!(Tipster, id)
    |> Repo.preload([:user])
  end

  def create_tipster(attrs \\ %{}) do
    %Tipster{}
    |> Tipster.changeset(attrs)
    |> Repo.insert()
  end

  def update_tipster(%Tipster{} = tipster, attrs) do
    tipster
    |> Tipster.changeset(attrs)
    |> Repo.update()
  end

  def delete_tipster(%Tipster{} = tipster) do
    Repo.delete(tipster)
  end

  def tipsters_by_user(user_id) do
    query =
      from r in Tipster,
        where: r.user_id == ^user_id

    query |> Repo.all()
  end

  def tipsters_by_user_formatted(user_id) do
    user_id
    |> Tipster.tipsters_by_user()
    |> Enum.map(fn x ->
      %{
        id: x.id,
        name: x.name,
        inserted_at: x.inserted_at,
        updated_at: x.updated_at
      }
    end)
  end
end
