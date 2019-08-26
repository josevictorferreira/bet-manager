defmodule BetManagerWeb.BetView do
  use BetManagerWeb, :view

  def render("show.json", bet) do
    %{
      id: bet.id,
      description: bet.description,
      odd: bet.odd,
      value: bet.value,
      result: to_string(bet.result),
      sport: %{
        name: bet.sport.name
      },
      inserted_at: bet.inserted_at,
      updated_at: bet.updated_at,
      account: %{
        name: bet.account.name,
        balance: bet.account.balance,
        bookmaker: %{
          id: bet.account.bookmaker.id,
          name: bet.account.bookmaker.name,
          logo: bet.account.bookmaker.logo,
          inserted_at: bet.account.bookmaker.inserted_at,
          updated_at: bet.account.bookmaker.updated_at
        },
        currency: %{
          code: bet.account.currency.code,
          name: bet.account.currency.name,
          name_plural: bet.account.currency.name_plural,
          decimal_digits: bet.account.currency.decimal_digits,
          rounding: bet.account.currency.rounding,
          symbol: bet.account.currency.symbol,
          country: %{
            code: bet.account.currency.country.code,
            name: bet.account.currency.country.name,
            flag: bet.account.currency.country.flag,
            region: bet.account.currency.country.region
          }
        }
      }
    }
  end

  def render("indebet.json", bets) do
    %{status: "success", data: bets.data}
  end
end
