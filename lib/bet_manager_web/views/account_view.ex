defmodule BetManagerWeb.AccountView do
  use BetManagerWeb, :view

  def render("show.json", account) do
    %{
      id: account.id,
      name: account.name,
      balance: account.balance,
      inserted_at: account.inserted_at,
      bookmaker: %{
        id: account.bookmaker.id,
        name: account.bookmaker.name,
        logo: account.bookmaker.logo,
        inserted_at: account.bookmaker.inserted_at,
        updated_at: account.bookmaker.updated_at
      },
      currency: %{
        code: account.currency.code,
        name: account.currency.name,
        name_plural: account.currency.name_plural,
        decimal_digits: account.currency.decimal_digits,
        rounding: account.currency.rounding,
        symbol: account.currency.symbol,
        country: %{
          code: account.currency.country.code,
          name: account.currency.country.name,
          flag: account.currency.country.flag,
          region: account.currency.country.region
        }
      }
    }
  end

  def render("index.json", accounts) do
    %{status: "success", data: accounts.data}
  end
end