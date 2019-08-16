defmodule BetManagerWeb.CountryController do
  use BetManagerWeb, :controller
  alias BetManager.Country

  def index(conn, %{}) do
    countries = Country.list_countries_formatted()
    conn |> render("index.json", %{data: countries})
  end
end