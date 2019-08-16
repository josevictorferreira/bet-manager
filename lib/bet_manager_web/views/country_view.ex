defmodule BetManagerWeb.CountryView do
  use BetManagerWeb, :view

  def render("index.json", countries) do
    %{status: "success", data: countries.data}
  end
end