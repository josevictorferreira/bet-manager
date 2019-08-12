defmodule BetManagerWeb.UserController do
  use BetManagerWeb, :controller
  alias BetManager.User

  def create(conn, %{"email" => email, "password" => password}) do
    case User.create_user(%{"email" => email, "password" => password}) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> render("new.json", user)
      {:error, _} -> conn |> send_resp(200, "Error")  #do something
    end
  end
end
