defmodule BetManagerWeb.TipsterView do
  use BetManagerWeb, :view

  def render("show.json", tipster) do
    %{
      status: "success",
      data: %{
        id: tipster.id,
        name: tipster.name,
        inserted_at: tipster.inserted_at,
        updated_at: tipster.updated_at
      }
    }
  end

  def render("index.json", tipsters) do
    %{status: "success", data: tipsters.data}
  end
end
