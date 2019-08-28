defmodule BetManagerWeb.TransactionView do
  use BetManagerWeb, :view

  def render("show.json", transaction) do
    %{
      status: "success",
      data: %{
        id: transaction.id,
        value: transaction.value,
        type: transaction.type,
        date: transaction.date,
        inserted_at: transaction.inserted_at,
        updated_at: transaction.updated_at,
        account: %{
          id: transaction.account.id,
          name: transaction.account.name,
          balance: transaction.account.balance,
          inserted_at: transaction.account.inserted_at,
          bookmaker: %{
            id: transaction.account.bookmaker.id,
            name: transaction.account.bookmaker.name,
            logo: transaction.account.bookmaker.logo,
            inserted_at: transaction.account.bookmaker.inserted_at,
            updated_at: transaction.account.bookmaker.updated_at
          },
          currency: %{
            code: transaction.account.currency.code,
            name: transaction.account.currency.name,
            name_plural: transaction.account.currency.name_plural,
            decimal_digits: transaction.account.currency.decimal_digits,
            rounding: transaction.account.currency.rounding,
            symbol: transaction.account.currency.symbol,
            country: %{
              code: transaction.account.currency.country.code,
              name: transaction.account.currency.country.name,
              flag: transaction.account.currency.country.flag,
              region: transaction.account.currency.country.region
            }
          }
        }
      }
    }
  end

  def render("index.json", transactions) do
    %{status: "success", data: transactions.data}
  end
end
