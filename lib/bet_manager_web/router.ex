defmodule BetManagerWeb.Router do
  use BetManagerWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:8082"
    plug :accepts, ["json"]
  end

  pipeline :authenticate do
    plug BetManager.Plugs.Authenticate
  end

  scope "/api", BetManagerWeb do
    pipe_through [:api, :authenticate]

    get "/countries", CountryController, :index
    get "/currencies", CurrencyController, :index
    get "/sports", SportController, :index

    scope "/sessions" do
      delete "/sign_out", SessionController, :delete
      post "/revoke", SessionController, :revoke
    end

    resources "/accounts", AccountController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :create, :index, :edit]
    resources "/bookmakers", BookmakerController, except: [:new, :edit]
    resources "/tipsters", TipsterController, except: [:new, :edit]
    resources "/bets", BetController, except: [:new, :edit]
    resources "/transactions", TransactionController, except: [:new, :edit]
    options "/accounts", AccountController, :options
    options "/users", UserController, :options
    options "/bookmakers", BookmakerController, :options
    options "/tipsters", TipsterController, :options
    options "/bets", BetController, :options
    options "/transactions", TransactionController, :options
  end

  scope "/api", BetManagerWeb do
    pipe_through :api

    scope "/sessions" do
      post "/sign_in", SessionController, :create
    end

    post "/users", UserController, :create
  end
end
