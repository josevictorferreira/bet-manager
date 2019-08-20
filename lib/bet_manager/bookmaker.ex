defmodule BetManager.Bookmaker do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias BetManager.Repo
  alias BetManager.Bookmaker
  alias BetManager.User

  schema "bookmakers" do
    belongs_to :user, User
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
    |> validate_format(:logo, ~r/(?:([^:\/?#]+):)?(?:\/\/([^\/?#]*))?([^?#]*\.(?:jpg|gif|png))(?:\?([^#]*))?(?:#(.*))?/)
  end

  def list_bookmakers do
    Repo.all(Bookmaker)
  end

  def get_bookmaker!(id), do: Repo.get!(Bookmaker, id)

  def create_bookmaker(attrs \\ %{}) do
    %Bookmaker{}
    |> Bookmaker.changeset(attrs)
    |> Repo.insert()
  end

  def update_bookmaker(%Bookmaker{} = bookmaker, attrs) do
    bookmaker
    |> Bookmaker.changeset(attrs)
    |> Repo.update()
  end

  def delete_bookmaker(%Bookmaker{} = bookmaker) do
    Repo.delete(bookmaker)
  end

  def bookmakers_by_user(user_id) do
    query = from r in Bookmaker,
      where: r.user_id == ^user_id or is_nil(r.user_id)
    query |> Repo.all()
  end

  def bookmakers_by_user_formatted(user_id) do
    user_id
    |> Bookmaker.bookmakers_by_user()
    |> Enum.map(fn x -> %{id: x.id, name: x.name, logo: x.logo, inserted_at: x.inserted_at, updated_at: x.updated_at} end)
  end
end
