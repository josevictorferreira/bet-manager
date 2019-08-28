defmodule BetManager.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias BetManager.Transaction
  alias BetManager.Repo
  alias BetManager.Account

  schema "transactions" do
    belongs_to :account, Account
    field :value, :float
    field :type, :string
    field :date, :utc_datetime

    timestamps()
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:value, :type, :date, :account_id])
    |> validate_required([:value, :type, :date, :account_id])
    |> validate_format(
      :type,
      ~r/^((deposit)|(withdraw)){1}$/
    )
    |> validate_number(:value, greater_than: 0.0)
  end

  def list_transactions_by_user(user_id) do
    query =
      from r in Transaction,
        preload: [:account]
        where: r.account.user_id == ^user_id

    query |> Repo.all()
  end

  def get_transaction!(id) do
    Transaction
    |> Repo.get!(id)
  end

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  def transactions_by_user_formatted(user_id) do
    user_id
    |> list_transactions_by_user()
    |> Enum.map(fn x ->
      %{
        id: x.id,
        value: x.value,
        type: x.type,
        date: x.date,
        inserted_at: x.inserted_at,
        updated_at: x.updated_at,
        account: %{
          id: x.account.id,
          name: x.account.name,
          balance: x.account.balance,
          inserted_at: x.account.inserted_at,
          bookmaker: %{
            id: x.account.bookmaker.id,
            name: x.account.bookmaker.name,
            logo: x.account.bookmaker.logo,
            inserted_at: x.account.bookmaker.inserted_at,
            updated_at: x.account.bookmaker.updated_at
          },
          currency: %{
            code: x.account.currency.code,
            name: x.account.currency.name,
            name_plural: x.account.currency.name_plural,
            decimal_digits: x.account.currency.decimal_digits,
            rounding: x.account.currency.rounding,
            symbol: x.account.currency.symbol,
            country: %{
              code: x.account.currency.country.code,
              name: x.account.currency.country.name,
              flag: x.account.currency.country.flag,
              region: x.account.currency.country.region
            }
          }
        }
      }
    end)
  end
end
