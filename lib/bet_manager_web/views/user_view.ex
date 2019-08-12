defmodule BetManagerWeb.UserView do
  use BetManagerWeb, :view

  def render("new.json", user) do
    %{status: "success", data: %{id: user.id, email: user.email, inserted_at: user.inserted_at}}
  end
end
