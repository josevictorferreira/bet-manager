defmodule BetManager.Account do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias BetManager.Account
  alias BetManager.User
  alias BetManager.Bookmaker
  alias BetManager.Currency
  alias BetManager.Repo
  alias BetManager.Transaction

  schema "accounts" do
    has_many :transactions, Transaction, on_delete: :delete_all
    belongs_to :user, User
    belongs_to :bookmaker, Bookmaker
    belongs_to :currency, Currency, foreign_key: :currency_code, references: :code, type: :string
    field :balance, :float, default: 0.0
    field :name, :string
    field :initial_balance, :float, virtual: true

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :initial_balance, :bookmaker_id, :currency_code, :user_id])
    |> validate_required([:name])
    |> validate_number(:initial_balance, greater_than_or_equal_to: 0.0)
    |> validate_number(:balance, greater_than_or_equal_to: 0.0)
    |> validate_length(:name, min: 2, max: 50)
    |> assoc_constraint(:bookmaker)
    |> set_balance()
  end

  def set_balance(changeset) do
    balance = get_field(changeset, :balance)

    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{initial_balance: initial_balance}}
      when initial_balance > 0.0 and balance == 0.0 ->
        put_change(changeset, :balance, initial_balance)

      _ ->
        changeset
    end
  end

  def list_accounts_by_user(user_id) do
    Repo.all(
      from r in Account,
        where: r.user_id == ^user_id,
        preload: [:bookmaker, currency: :country]
    )
  end

  def account_ids_by_user(user_id) do
    query =
      from r in Account,
        where: r.user_id == ^user_id,
        select: r.id

    query |> Repo.all()
  end

  def accounts_by_user_formatted(user_id) do
    user_id
    |> list_accounts_by_user()
    |> Enum.map(fn x ->
      %{
        id: x.id,
        name: x.name,
        balance: x.balance,
        inserted_at: x.inserted_at,
        bookmaker: %{
          id: x.bookmaker.id,
          name: x.bookmaker.name,
          logo: x.bookmaker.logo,
          inserted_at: x.bookmaker.inserted_at,
          updated_at: x.bookmaker.updated_at
        },
        currency: %{
          code: x.currency.code,
          name: x.currency.name,
          name_plural: x.currency.name_plural,
          decimal_digits: x.currency.decimal_digits,
          rounding: x.currency.rounding,
          symbol: x.currency.symbol,
          country: %{
            code: x.currency.country.code,
            name: x.currency.country.name,
            flag: x.currency.country.flag,
            region: x.currency.country.region
          }
        }
      }
    end)
  end

  def get_account!(id) do
    Repo.get!(Account, id)
    |> Repo.preload([:bookmaker, :user, currency: :country])
  end

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end
end
