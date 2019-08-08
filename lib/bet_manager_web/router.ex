defmodule BetManagerWeb.Router do
  use BetManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug BetManager.Plugs.Authenticate
  end

  scope "/api", BetManagerWeb do
    pipe_through :api

    post "/sessions/sign_in", SessionController, :create
    scope "/sessions" do
      pipe_through :authenticate
      delete "/sign_out", SessionController, :delete
      post "/revoke", SessionController, :revoke
    end
  end

end
