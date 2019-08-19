defmodule BetManagerWeb.CurrencyView do
  use BetManagerWeb, :view

  def render("index.json", currencies) do
    %{status: "success", data: currencies.data}
  end
end
