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
    field :event_date, :utc_datetime

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
      :event_date,
      :tipster_id,
      :account_id,
      :user_id,
      :sport_id
    ])
    |> validate_required([
      :description,
      :odd,
      :value,
      :event_date,
      :account_id,
      :user_id,
      :sport_id
    ])
    |> validate_user_tipster(:tipster_id)
    |> validate_user_account(:account_id)
    # |> check_balance()
  end

  # def check_balance(changeset) do
  #   when get_change(changeset, :odd) != nil or
  #        get_change(changeset, :value) != nil or
  #        get_change(changeset, :result) != nil or
  #        get_change(changeset, :event_date) != nil or
  #        get_change(changeset, :account_id) != nil do
  #     force_change(changeset, :balance, calculate_balance())
  #   end
  # end

  # def calculate_balance() do
  #   bets =
  #     Bet
  #     |> order_by(:asc, :event_date)
  #     |> Repo.All()
  #     |> Enum.reduce(fn bet ->
  #     end)

  # end

  def validate_user_account(changeset, :account_id, options \\ []) do
    {_, user_id} = changeset |> fetch_field(:user_id)

    validate_change(changeset, :account_id, fn _, account_id ->
      case Account.account_ids_by_user(user_id) |> Enum.member?(account_id) do
        true -> []
        false -> [{:account_id, options[:message] || "Invalid account id."}]
      end
    end)
  end

  def validate_user_tipster(changeset, :tipster_id, options \\ []) do
    {_, user_id} = changeset |> fetch_field(:user_id)

    validate_change(changeset, :tipster_id, fn _, tipster_id ->
      case Tipster.tipsters_ids_by_user(user_id) |> Enum.member?(tipster_id) do
        true -> []
        false -> [{:tipster_id, options[:message] || "Invalid tipster id."}]
      end
    end)
  end

  def list_bets do
    Bet
    |> order_by(:asc, :event_date)
    |> Repo.All()
    |> Repo.preload([:user, :tipster, :sport, account: [:bookmaker, currency: :country]])
  end

  def get_bet!(id) do
    Repo.get!(Bet, id)
    |> Repo.preload([:user, :tipster, :sport, account: [:bookmaker, currency: :country]])
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

    query
    |> Repo.all()
    |> Repo.preload([:user, :tipster, :sport, account: [:bookmaker, currency: :country]])
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
        event_date: x.event_date,
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
