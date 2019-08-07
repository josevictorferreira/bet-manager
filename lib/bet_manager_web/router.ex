defmodule BetManagerWeb.Router do
  use BetManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BetManagerWeb do
    pipe_through :api
  end
end
