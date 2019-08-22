defmodule BetManager.Bet do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias BetManager.Bet
  alias BetManager.Tipster
  alias BetManager.User
  alias BetManager.Account
  alias BetManager.Sport
  alias BetManager.Repo

  schema "bets" do
    belongs_to :tipster, Tipster
    belongs_to :account, Account
    belongs_to :user, User
    belongs_to :sport, Sport
    field :description, :string
    field :odd, :float
    field :result, Ecto.Type.ResultBet
    field :value, :float

    timestamps()
  end

  @doc false
  def changeset(bet, attrs) do
    bet
    |> cast(attrs, [
      :description,
      :odd,
      :value,
      :result,
      :tipster_id,
      :account_id,
      :user_id,
      :sport_id
    ])
    |> validate_required([:description, :odd, :value, :account_id, :user_id, :sport_id])
  end

  def list_bets do
    Repo.all(Bet)
  end

  def get_bet!(id) do
    Repo.get!(Bet, id)
    |> Repo.preload([:user, :tipster, :sport, account: [currency: :country]])
  end

  def create_bet(attrs \\ %{}) do
    %Bet{}
    |> Bet.changeset(attrs)
    |> Repo.insert()
  end

  def update_bet(%Bet{} = bet, attrs) do
    bet
    |> Bet.changeset(attrs)
    |> Repo.update()
  end

  def delete_bet(%Bet{} = bet) do
    Repo.delete(bet)
  end

  def bets_by_user(user_id) do
    query =
      from r in Bet,
        where: r.user_id == ^user_id

    query |> Repo.all()
  end

  def bets_by_user_formatted(user_id) do
    user_id
    |> Bet.bets_by_user()
    |> Enum.map(fn x ->
      %{
        id: x.id,
        description: x.description,
        odd: x.odd,
        value: x.value,
        result: to_string(x.result),
        sport: %{
          name: x.sport.name
        },
        account: %{
          name: x.account.name,
          balance: x.account.balance,
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
