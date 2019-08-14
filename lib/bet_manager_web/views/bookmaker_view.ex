defmodule BetManagerWeb.BookmakerView do
  use BetManagerWeb, :view

  def render("show.json", bookmaker) do
    %{status: "success",
    data: %{id: bookmaker.id,
            name: bookmaker.name,
            logo: bookmaker.logo,
            inserted_at: bookmaker.inserted_at,
            updated_at: bookmaker.updated_at}}
  end

  def render("index.json", bookmakers) do
    %{status: "success",
    data: bookmakers.data}
  end
end
