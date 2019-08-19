defmodule BetManagerWeb.CurrencyController do
  use BetManagerWeb, :controller
  alias BetManager.Currency

  def index(conn, %{}) do
    currencies = Currency.list_currencies_formatted()
    conn |> render("index.json", %{data: currencies})
  end
end