defmodule BetManagerWeb.SportView do
  use BetManagerWeb, :view

  def render("index.json", sports) do
    %{
      status: "success",
      data: sports.data
    }
  end
end
