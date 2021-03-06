defmodule BetManager.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias BetManager.AuthToken
  alias BetManager.User
  alias BetManager.Repo

  schema "auth_tokens" do
    belongs_to :user, User
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string
    timestamps()
  end

  @doc false
  def changeset(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
  end

  def get_by_token(token) do
    Repo.get_by(AuthToken, %{token: token})
    |> Repo.preload(user: :auth_tokens)
  end

  def get_last_by_user(user_id) do
    Repo.get_by(AuthToken, %{user_id: user_id})
    |> Repo.preload(user: :auth_tokens)
  end
end
