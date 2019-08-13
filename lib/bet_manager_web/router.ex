defmodule BetManagerWeb.Router do
  use BetManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug BetManager.Plugs.Authenticate
  end

  scope "/api", BetManagerWeb do
    pipe_through [:api, :authenticate]

    scope "/sessions" do
      delete "/sign_out", SessionController, :delete
      post "/revoke", SessionController, :revoke
    end
    resources "/users", UserController, except: [:new, :create, :index, :edit]
  end

  scope "/api", BetManagerWeb do
    pipe_through :api

    scope "/sessions" do
      post "/sign_in", SessionController, :create
    end
    post "/users", UserController, :create
  end

end
