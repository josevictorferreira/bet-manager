defmodule BetManagerWeb.SportController do
  use BetManagerWeb, :controller
  alias BetManager.Sport

  def index(conn, %{}) do
    sports = Sport.list_sports_formatted()
    conn |> render("index.json", %{data: sports})
  end
end
