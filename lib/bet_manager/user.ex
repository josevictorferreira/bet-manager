defmodule BetManager.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BetManager.User
  alias BetManager.Repo
  alias BetManager.Services.Authenticator

  schema "users" do
    has_many :auth_tokens, BetManager.AuthToken
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email, downcase: true)
    |> put_password_hash()
  end

  def sign_in(email, password) do
    case Comeonin.Bcrypt.check_pass(BetManager.Repo.get_by(User, email: email), password) do
      {:ok, user} ->
        token = Authenticator.generate_token(user)
        Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))
      err -> err
    end
  end

  def sign_out(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case BetManager.Repo.get_by(BetManager.AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end
      error -> error
    end
  end

  def revoke(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case BetManager.Repo.get_by(BetManager.AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.update(Ecto.Changeset.change(auth_token, revoked: true, revoked_at: DateTime.truncate(DateTime.utc_now, :second)))
        end
    end
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash,
        Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
